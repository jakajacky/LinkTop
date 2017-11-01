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

@interface BloodPreViewController ()

@property (nonatomic, strong) BloodPreView *bloodPreView;
@property (nonatomic, strong) MeasureAPI   *measureAPI;
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
                self.bloodPreView.resultValue.text = [NSString stringWithFormat:@"%d/%d",systolic_pressure, diastolic_pressure];
            });
            
            // 上传数据
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
                                     @"device_soft_ver" : soft_v?soft_v:@"", // 软件版本
                                     @"device_hard_ver" : hard_v?hard_v:@"", // 硬件版本
                                     };
            [self.measureAPI uploadResult:params type:MTBloodPresure completion:^(BOOL success, id result, NSString *msg) {
                // 结束UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.bloodPreView.tempre_loading stopRotating];
                    self.bloodPreView.startMeasureBtn.selected = NO;
                });
                if (success) {
                    
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
