//
//  TemperViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/18.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "TemperViewController.h"
#import "TempreView.h"
#import "LibHealthCombineSDK.h"
#import "SDKHealthMoniter.h"
#import "UIView+Rotate.h"
@interface TemperViewController ()<sdkHealthMoniterDelegate>

@property (nonatomic, strong) TempreView *tempreView;
@property (nonatomic, strong) SDKHealthMoniter *sdkHealth;

@end

@implementation TemperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) myself = self;
    // 启动服务
    [[LibHealthCombineSDK Instance] StartHealthMonitorServiceWithDelegate:self TcpStateChangeBlock:^(NSDictionary *dict) {
        
    }];
    
    // 获取健康检测仪SDK对象
    self.sdkHealth = [LibHealthCombineSDK Instance].LT_HealthMonitor;
    //    self.sdkHealth = [[SDKHealthMoniter alloc] init];
    //    self.sdkHealth.sdkHealthMoniterdelegate =self;
    
    
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
        [self.sdkHealth startThermometerTest];
    }
    else {
        // 结束测量
        [self.tempreView.tempre_loading stopRotating];
        [self.sdkHealth endThermometerTest];
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

#pragma mark - 蓝牙回调
- (void)didScanedPeripherals:(NSMutableArray *)foundPeripherals {
    NSLog(@"搜索到设备个数%ld",(long)foundPeripherals.count);
}

- (void)didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"连接到设备%@",peripheral);
}

- (void)disconnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"蓝牙断开连接");
}

/**
 * 测量温度的回调
 */
-(void)receiveThermometerData:(double)temperature {
    NSLog(@"体温测量结果：%f",temperature);
    // 结束
    self.tempreView.startMeasureBtn.selected = NO;
    [self.tempreView.tempre_loading stopRotating];
    [self.sdkHealth endThermometerTest];
    
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
}


/**
 *  @discussion  Get Oximetry results
 *
 *  @param Oximetry Oximetry value
 *  @param heartRate heartRate value
 */
-(void)receiveOximetryData:(double)oxy andHeartRate:(int)heartRate {
    
}




/**
 *  @discussion Get BloodPressure results
 *
 *  @param BloodPressure Systolic_pressure value Diastolic_pressure value
 *          Heart_beat value
 */
-(void)receiveBloodPressure:(int)Systolic_pressure andDiastolic_pressure:(int)Diastolic_pressure andHeart_beat:(int)Heart_beat {
    
}

/**
 *  @discussion
 *
 *  @param msgtype msgType ENUM
 *  @param row     if row!=nil , according to this param ,invoke method getBloodSugarInRow in this object(SDKHealthMoniter) to transform blood sugar
 */
-(void) receiveBloodSugar:(MSGTYPE) msgtype andRow:(NSNumber*) row {
    
}



/**
 *  @discussion Get ECG results
 *
 *  @param ECGData rrMax value rrMin value HRV value
 *                  mood value smoothWave LineData heartRate Value
 */
-(void)receiveECGDataRRmax:(int)rrMax {
    
}

-(void)receiveECGDataRRMin:(int)rrMin {
    
}

-(void)receiveECGDataHRV:(int)hrv {
    
}

-(void)receiveECGDataMood:(int)mood {
    
}

-(void)receiveECGDataSmoothedWave:(int)smoothedWave {
    
}

-(void)receiveECGDataHeartRate:(int)heartRate {
    
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
