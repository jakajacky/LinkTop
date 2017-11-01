//
//  HeartRateViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/20.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "HeartRateViewController.h"
#import "HeartRateView.h"
#import "MeasureAPI.h"
#import "UIView+Rotate.h"
@interface HeartRateViewController ()

@property (nonatomic, strong) HeartRateView *heartRateView;
@property (nonatomic, strong) MeasureAPI    *measureAPI;

@end

@implementation HeartRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) myself = self;
    
    self.heartRateView.navi.leftViewDidClicked = ^{
        [myself dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
    [self.heartRateView.startMeasureBtn addTarget:self
                                           action:@selector(startMeasureBtnDidClicked:)
                                 forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"HeartRateViewController 释放");
    [self.view removeFromSuperview];
    [self.view removeAllSubviews];
    self.view = nil;
}

- (void)startMeasureBtnDidClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 开始测量
        [self.heartRateView.tempre_loading startRotating];
        [[DeviceManger defaultManager] measureSpo2hWithConnect:^(CBPeripheral *peripheral) {
            
        } disconnect:^(CBPeripheral *peripheral) {
            
        } bleAbnormal:^{
            
        } receiveSpo2hData:^(double oxy) {
            
        } receiveSpo2hResult:^(double oxy, int heartrate) {
            // 测量结束
            dispatch_async(dispatch_get_main_queue(), ^{
                self.heartRateView.heartRateValue.text = [NSString stringWithFormat:@"%d",heartrate];
                
                [self.heartRateView.tempre_loading stopRotating];
                self.heartRateView.startMeasureBtn.selected = NO;
            });
            
            // 上传数据
            [SVProgressHUD showWithStatus:@"正在上传"];
            Patient *user = [LoginManager defaultManager].currentPatient;
            NSString *device_id  = [DeviceManger defaultManager].deviceID;
            NSString *device_key = [DeviceManger defaultManager].deviceKEY;
            NSString *soft_v  = [DeviceManger defaultManager].softVersion;
            NSString *hard_v  = [DeviceManger defaultManager].hardVersion;
            NSDictionary *params = @{@"user_id"         : user.user_id,   // 用户名
                                     @"hr"              : @(heartrate),      // 心率
                                     @"device_id"       : device_id?device_id:@"", // 设备id
                                     @"device_key"      : device_key?device_key:@"", // 设备key
                                     @"device_power"    : @(100),
                                     @"device_soft_ver" : soft_v?soft_v:@"", // 软件版本
                                     @"device_hard_ver" : hard_v?hard_v:@"", // 硬件版本
                                     };
            [self.measureAPI uploadResult:params type:MTHeartRate completion:^(BOOL success, id result, NSString *msg) {
                
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
        [self.heartRateView.tempre_loading stopRotating];
        [[DeviceManger defaultManager] endMeasureSpo2h];
    }
    
}

#pragma mark - properties
- (HeartRateView *)heartRateView {
    if (!_heartRateView) {
        _heartRateView = (HeartRateView *)self.view;
    }
    return _heartRateView;
}

- (MeasureAPI *)measureAPI {
    if (!_measureAPI) {
        _measureAPI = [MeasureAPI biz];
    }
    return _measureAPI;
}

@end
