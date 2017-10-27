//
//  HeartRateViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/20.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "HeartRateViewController.h"
#import "HeartRateView.h"

#import "UIView+Rotate.h"
@interface HeartRateViewController ()

@property (nonatomic, strong) HeartRateView *heartRateView;

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
            
        } receiveSpo2hData:^(double oxy, int heartrate) {
            // 测量结束
            [self.heartRateView.tempre_loading stopRotating];
            self.heartRateView.startMeasureBtn.selected = NO;
            
            self.heartRateView.heartRateValue.text = [NSString stringWithFormat:@"%d",heartrate];
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

@end
