//
//  TemperViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/18.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "TemperViewController.h"
#import "TempreView.h"
#import "MeasureAPI.h"
#import "DeviceManger.h"
#import "UIView+Rotate.h"

typedef void(^RothmanStepTwoComplete)(BOOL,id);

@interface TemperViewController ()

@property (nonatomic, strong) TempreView *tempreView;
@property (nonatomic, strong) MeasureAPI *measureAPI;
@property (nonatomic, copy)   RothmanStepTwoComplete rothmanStepTwoComplete;

@end

@implementation TemperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) myself = self;
    
    self.tempreView.controlTypeOfTemp.valueChangedBlock = ^(NSInteger currentIndex) {
        [myself reloadTemperatureValueToView:myself.tempreView.tempretureValue.text];
    };
    
    self.tempreView.navi.leftViewDidClicked = ^{
        [myself dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
    [self.tempreView.startMeasureBtn addTarget:self
                                        action:@selector(startMeasureBtnDidClicked:)
                              forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tempreView.navi.leftViewDidClicked = nil; // 这种block记得及时释放，否则控制器一直持有，无法dealloc
    self.tempreView.navi.rightViewDidClicked = nil;
    self.tempreView.controlTypeOfTemp.valueChangedBlock = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"Tempreture控制器 释放");
    [self.tempreView removeFromSuperview];
    [self.tempreView removeAllSubviews];
    self.tempreView = nil;
}

- (void)startMeasureBtnDidClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 开始测量
        [self.tempreView.tempre_loading startRotating];
        [[DeviceManger defaultManager] measureThermometerWithConnect:^(CBPeripheral *peripheral) {
            NSLog(@"--+++temp--++蓝牙连接++--+++");
        } disconnect:^(CBPeripheral *peripheral) {
            NSLog(@"--+++temp--++蓝牙断开++--+++");
        } bleAbnormal:^{
            NSLog(@"--+++temp--++蓝牙异常++--+++");
        } receiveThermometerData:^(double temperature) {
            
            // 更新UI结果
            dispatch_async(dispatch_get_main_queue(), ^{
                double temperatureNew = temperature*1.8+32;
                if (self.tempreView.controlTypeOfTemp.currentIndex==1) {
                    self.tempreView.tempreType.text = @"℉";
                    temperatureNew = temperature*1.8+32;
                }
                else {
                    temperatureNew = temperature;
                    self.tempreView.tempreType.text = @"℃";
                }
                self.tempreView.tempretureValue.text = [NSString stringWithFormat:@"%.1f",temperatureNew];
                // 结束UI
                self.tempreView.startMeasureBtn.selected = NO;
                [self.tempreView.tempre_loading stopRotating];
            });
            NSString *handletemp = [NSString stringWithFormat:@"%.1f",temperature];
            // 测量有误：
            if (temperature<=0) {
                return;
            }
            // 测量无误，但可能存在结果异常：
            if (_isRothmanMeasure) {
                
                DiagnosticList *diag = [[DiagnosticList alloc] initWithDictionary:@{@"temp" : handletemp}];
                if (temperature<36.2 || temperature>37.4) {
                    _rothmanStepTwoComplete(NO,diag); // 异常
                }
                else {
                    _rothmanStepTwoComplete(YES,diag); // 正常
                }
                return;
            }
            
            // 上传数据
            [SVProgressHUD showWithStatus:@"正在上传"];
            Patient *user = [LoginManager defaultManager].currentPatient;
            NSString *device_id  = [DeviceManger defaultManager].deviceID;
            NSString *device_key = [DeviceManger defaultManager].deviceKEY;
            NSString *soft_v  = [DeviceManger defaultManager].softVersion;
            NSString *hard_v  = [DeviceManger defaultManager].hardVersion;
            NSDictionary *params = @{@"user_id"         : user.user_id,   // 用户名
                                     @"temp"            : @(temperature), // 体温
                                     @"device_id"       : device_id?device_id:@"", // 设备id
                                     @"device_key"      : device_key?device_key:@"", // 设备key
                                     @"device_power"    : @(100),
                                     @"device_soft_ver" : soft_v?soft_v:@"", // 软件版本
                                     @"device_hard_ver" : hard_v?hard_v:@"", // 硬件版本
                       };
            [self.measureAPI uploadResult:params type:MTTemperature completion:^(BOOL success, id result, NSString *msg) {
                
                if (success) {
                    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                    [SVProgressHUD dismissWithDelay:1.5];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"上传失败"];
                    [SVProgressHUD dismissWithDelay:1.5];
                }
            }];
            
        }];
    }
    else {
        // 结束测量
        [self.tempreView.tempre_loading stopRotating];
        [[DeviceManger defaultManager] endMeasureThermometer];
    }
    
}

- (void)startRothmanStepTwoMeasureWithViewController:(UIViewController *)vc endCompletion:(void(^)(BOOL success,id result))complete {
    _rothmanStepTwoComplete = complete;
    [vc presentViewController:self animated:NO completion:^{
        
    }];
}

#pragma mark - 处理温度单位
- (void)reloadTemperatureValueToView:(NSString *)temperatureString {
    double temperatureNew;
    double temperature = [temperatureString doubleValue];
    if (self.tempreView.controlTypeOfTemp.currentIndex==1) {
        temperatureNew = temperature*1.8+32;
        self.tempreView.tempreType.text = @"℉";
    }
    else {
        temperatureNew = (temperature-32)/1.8;
        self.tempreView.tempreType.text = @"℃";
    }
    
    if (![temperatureString isEqualToString:@"--"]) {
        self.tempreView.tempretureValue.text = [NSString stringWithFormat:@"%.1f",temperatureNew];
    }
}

#pragma mark - properties
- (TempreView *)tempreView {
    if (!_tempreView) {
        _tempreView = (TempreView *)self.view;
    }
    return _tempreView;
}

- (MeasureAPI *)measureAPI {
    if (!_measureAPI) {
        _measureAPI = [MeasureAPI biz];
    }
    return _measureAPI;
}


@end
