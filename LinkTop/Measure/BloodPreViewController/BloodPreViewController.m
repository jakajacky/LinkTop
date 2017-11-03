//
//  BloodPreViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/22.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "BloodPreViewController.h"
#import "BloodPreView.h"
#import "MeasureAPI.h"
#import "UIView+Rotate.h"

typedef void(^RothmanStepOneComplete)(BOOL,id);

@interface BloodPreViewController ()

@property (nonatomic, strong) BloodPreView *bloodPreView;
@property (nonatomic, strong) MeasureAPI   *measureAPI;
@property (nonatomic, copy)   RothmanStepOneComplete rothmanStepOneComplete;
@end

@implementation BloodPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) myself = self;
    
    self.bloodPreView.navi.leftViewDidClicked = ^{
        [myself dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
    [self.bloodPreView.startMeasureBtn addTarget:self
                                           action:@selector(startMeasureBtnDidClicked:)
                                 forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"BloodPreViewController 释放");
    [self.view removeFromSuperview];
    [self.view removeAllSubviews];
    self.view = nil;
}

- (void)startMeasureBtnDidClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 开始测量
        [self.bloodPreView.tempre_loading startRotating];
        [[DeviceManger defaultManager] measureBloodPresureWithConnect:^(CBPeripheral *peripheral) {
            
        } disconnect:^(CBPeripheral *peripheral) {
            
        } bleAbnormal:^{
            
        } receiveBloodPData:^(int systolic_pressure, int diastolic_pressure, int heartrate) {
            // 主线程修改UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.bloodPreView.tempre_loading stopRotating];
                self.bloodPreView.startMeasureBtn.selected = NO;
                self.bloodPreView.resultValue.text = [NSString stringWithFormat:@"%d/%d",systolic_pressure, diastolic_pressure];
            });
            
            // 测量有误：
            if (systolic_pressure<=0 || diastolic_pressure<=0) {
                return;
            }
            
            // 测量无误，但是结果异常：
            if (_isRothmanMeasure) {
                DiagnosticList *diag = [[DiagnosticList alloc] initWithDictionary:@{@"sbp" : @(systolic_pressure),
                                                                                    @"dbp" : @(diastolic_pressure)}];
                if (systolic_pressure<90 || diastolic_pressure<60 || systolic_pressure>140 || diastolic_pressure>90) {
                    _rothmanStepOneComplete(NO,diag); // 异常
                }
                else {
                    _rothmanStepOneComplete(YES,diag); // 正常
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
                                     @"sbp"             : @(systolic_pressure), // 收缩压
                                     @"dbp"             : @(diastolic_pressure),// 舒张压
                                     @"device_id"       : device_id?device_id:@"", // 设备id
                                     @"device_key"      : device_key?device_key:@"", // 设备key
                                     @"device_power"    : @(100),
                                     @"device_soft_ver" : soft_v?soft_v:@"", // 软件版本
                                     @"device_hard_ver" : hard_v?hard_v:@"", // 硬件版本
                                     };
            [self.measureAPI uploadResult:params type:MTBloodPresure completion:^(BOOL success, id result, NSString *msg) {
                
                if (success) {
                    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                    [SVProgressHUD dismissWithDelay:1.5];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"上传失败"];
                    [SVProgressHUD dismissWithDelay:1.5];
                }
            }];
            
        } bpAbnormalComplete:^(NSString *message) {
            // 血压异常
            NSLog(@"----+++---++%@",message);
        }];
    }
    else {
        // 结束测量
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bloodPreView.tempre_loading stopRotating];
            [[DeviceManger defaultManager] endMeasureBloodPresure];
        });
    }
    
}

- (void)startRothmanStepOneMeasureWithViewController:(UIViewController *)vc endCompletion:(void(^)(BOOL success,id result))complete {
    _rothmanStepOneComplete = complete;
    [vc presentViewController:self animated:YES completion:^{
        
    }];
}

#pragma mark - properties
- (BloodPreView *)bloodPreView {
    if (!_bloodPreView) {
        _bloodPreView = (BloodPreView *)self.view;
    }
    return _bloodPreView;
}

- (MeasureAPI *)measureAPI {
    if (!_measureAPI) {
        _measureAPI = [MeasureAPI biz];
    }
    return _measureAPI;
}

@end
