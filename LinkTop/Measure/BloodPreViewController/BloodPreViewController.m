//
//  BloodPreViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/22.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "BloodPreViewController.h"
#import "BloodPreView.h"

#import "UIView+Rotate.h"

@interface BloodPreViewController ()

@property (nonatomic, strong) BloodPreView *bloodPreView;

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
        } bpAbnormalComplete:^(NSString *message) {
            // 血压异常
            NSLog(@"----+++---++%@",message);
        }];
    }
    else {
        // 结束测量
        [self.bloodPreView.tempre_loading stopRotating];
        [[DeviceManger defaultManager] endMeasureBloodPresure];
    }
    
}

#pragma mark - properties
- (BloodPreView *)bloodPreView {
    if (!_bloodPreView) {
        _bloodPreView = (BloodPreView *)self.view;
    }
    return _bloodPreView;
}

@end
