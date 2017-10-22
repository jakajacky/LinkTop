//
//  ECGViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/22.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "ECGViewController.h"
#import "ECGView.h"
#import "LibHealthCombineSDK.h"
#import "SDKHealthMoniter.h"
#import "UIView+Rotate.h"

@interface ECGViewController ()<sdkHealthMoniterDelegate>

@property (nonatomic, strong) ECGView *ecgView;
@property (nonatomic, strong) SDKHealthMoniter *sdkHealth;

@end

@implementation ECGViewController

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
    self.ecgView.navi.leftViewDidClicked = ^{
        [myself dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
    [self.ecgView.startMeasureBtn addTarget:self
                                          action:@selector(startMeasureBtnDidClicked:)
                                forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"ECGViewController 释放");
    [self.view removeFromSuperview];
    [self.view removeAllSubviews];
    self.view = nil;
}

- (void)startMeasureBtnDidClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 开始测量
        
        [self.sdkHealth startECG];
    }
    else {
        // 结束测量
        
        [self.sdkHealth endECG];
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
}


/**
 *  @discussion  Get Oximetry results
 *
 *  @param Oximetry Oximetry value
 *  @param heartRate heartRate value
 */
-(void)receiveOximetryData:(double)oxy andHeartRate:(int)heartRate {
    NSLog(@"血氧测量结果：%f, 脉率:%d",oxy,heartRate);
    
}




/**
 *  @discussion Get BloodPressure results
 *
 *  @param BloodPressure Systolic_pressure value Diastolic_pressure value
 *          Heart_beat value
 */
-(void)receiveBloodPressure:(int)Systolic_pressure andDiastolic_pressure:(int)Diastolic_pressure andHeart_beat:(int)Heart_beat {
    NSLog(@"血压测量结果：%d, %d",Systolic_pressure,Diastolic_pressure);

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
    NSLog(@"心电区间最大值：%d",rrMax);
}

-(void)receiveECGDataRRMin:(int)rrMin {
    NSLog(@"心电区间最小值：%d",rrMin);
}

-(void)receiveECGDataHRV:(int)hrv {
    NSLog(@"心率变异性：%d",hrv);
}

-(void)receiveECGDataMood:(int)mood {
    NSLog(@"心情值：%d",mood);
}

-(void)receiveECGDataSmoothedWave:(int)smoothedWave {
    NSLog(@"revData：%d",smoothedWave);
}

-(void)receiveECGDataHeartRate:(int)heartRate {
    NSLog(@"心率结果：%d",heartRate);
    // 测量结束
//    [self.sdkHealth endECG];
    // 主线程修改UI
    dispatch_async(dispatch_get_main_queue(), ^{
        self.ecgView.startMeasureBtn.selected = NO;
        
    });
}

-(void)receiveECGDataBreathRate:(int)breathRate {
    
}

/*!
 *  @method bloodPressureAbnormal
 *
 *  @param message   The <code>str</code> that abnormal message.
 *
 *  @discussion         This method is invoked when bloodPressure
 *  abnormal dicconnect
 */
-(void)bloodPressureAbnormal:(NSString *)message {
    NSLog(@"血压异常：%@",message);
}

#pragma mark - properties
- (ECGView *)ecgView {
    if (!_ecgView) {
        _ecgView = (ECGView *)self.view;
    }
    return _ecgView;
}

@end
