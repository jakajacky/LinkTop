//
//  Spo2hViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/20.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "Spo2hViewController.h"
#import "Spo2hView.h"
#import "LibHealthCombineSDK.h"
#import "SDKHealthMoniter.h"
#import "UIView+Rotate.h"

@interface Spo2hViewController ()<sdkHealthMoniterDelegate>

@property (nonatomic, strong) Spo2hView *spo2hView;
@property (nonatomic, strong) SDKHealthMoniter *sdkHealth;

@end

@implementation Spo2hViewController

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
    self.spo2hView.navi.leftViewDidClicked = ^{
        [myself dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
    
    
    [self.spo2hView.startMeasureBtn addTarget:self action:@selector(startMeasureBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    // 开始动画
    [self.spo2hView.tempre_loading startRotating];
    [self.sdkHealth startOximetryTest];
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
}


/**
 *  @discussion  Get Oximetry results
 *
 *  @param Oximetry Oximetry value
 *  @param heartRate heartRate value
 */
-(void)receiveOximetryData:(double)oxy andHeartRate:(int)heartRate {
    NSLog(@"血氧测量结果：%f, 脉率:%d",oxy,heartRate);
    [self.spo2hView.tempre_loading stopRotating];
    self.spo2hView.Spo2hValue.text     = [NSString stringWithFormat:@"%.1f",oxy];
    self.spo2hView.PulseRateValue.text = [NSString stringWithFormat:@"%d",heartRate];
    self.spo2hView.spo2h_unit.text = @"%";
    self.spo2hView.pulse_unit.text = @"bmp";
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
- (Spo2hView *)spo2hView {
    if (!_spo2hView) {
        _spo2hView = (Spo2hView *)self.view;
    }
    return _spo2hView;
}

@end
