//
//  TemperViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/18.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "TemperViewController.h"
#import "TempreView.h"

#import "UIView+Rotate.h"
@interface TemperViewController ()

@property (nonatomic, strong) TempreView *tempreView;

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
            // 结束
            self.tempreView.startMeasureBtn.selected = NO;
            [self.tempreView.tempre_loading stopRotating];
            
            // 更新UI结果
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
        }];
    }
    else {
        // 结束测量
        [self.tempreView.tempre_loading stopRotating];
        [[DeviceManger defaultManager] endMeasureThermometer];
    }
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
