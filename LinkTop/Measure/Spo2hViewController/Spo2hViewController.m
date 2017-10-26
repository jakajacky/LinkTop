//
//  Spo2hViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/20.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "Spo2hViewController.h"
#import "Spo2hView.h"

#import "UIView+Rotate.h"

@interface Spo2hViewController ()

@property (nonatomic, strong) Spo2hView *spo2hView;

@end

@implementation Spo2hViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) myself = self;
    
    self.spo2hView.navi.leftViewDidClicked = ^{
        [myself dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
    [self.spo2hView.startMeasureBtn addTarget:self
                                       action:@selector(startMeasureBtnDidClicked:)
                             forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"Spo2hViewController 释放");
    [self.view removeFromSuperview];
    [self.view removeAllSubviews];
    self.view = nil;
}

- (void)startMeasureBtnDidClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 开始测量
        [self.spo2hView.tempre_loading startRotating];
        [[DeviceManger defaultManager] measureSpo2hWithConnect:^(CBPeripheral *peripheral) {
            
        } disconnect:^(CBPeripheral *peripheral) {
            
        } bleAbnormal:^{
            
        } receiveSpo2hData:^(double oxy, int heartrate) {
            //结束
            self.spo2hView.startMeasureBtn.selected = NO;
            [self.spo2hView.tempre_loading stopRotating];
            
            // 更新UI结果
            self.spo2hView.Spo2hValue.text     = [NSString stringWithFormat:@"%.1f",oxy];
            self.spo2hView.PulseRateValue.text = [NSString stringWithFormat:@"%d",heartrate];
            self.spo2hView.spo2h_unit.text = @"%";
            self.spo2hView.pulse_unit.text = @"bmp";
        }];
    }
    else {
        // 结束测量
        [self.spo2hView.tempre_loading stopRotating];
        [[DeviceManger defaultManager] endMeasureSpo2h];
    }
}

#pragma mark - properties
- (Spo2hView *)spo2hView {
    if (!_spo2hView) {
        _spo2hView = (Spo2hView *)self.view;
    }
    return _spo2hView;
}

@end
