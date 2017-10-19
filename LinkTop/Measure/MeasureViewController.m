//
//  MeasureViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/10.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "MeasureViewController.h"
#import "MeasureNaviRightView.h"
#import "MeasureNaviLeftView.h"
#import "LibHealthCombineSDK.h"
#import "SDKHealthMoniter.h"
@interface MeasureViewController ()<sdkHealthMoniterDelegate>

@property (nonatomic, strong) SDKHealthMoniter *sdkHealth;

@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) NSMutableArray *peripherals;

@property (nonatomic, strong) MeasureNaviRightView *rightview;

@end

@implementation MeasureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 更改导航栏
    [self prepareNavigationColor];
    
    // 启动服务
    [[LibHealthCombineSDK Instance] StartHealthMonitorServiceWithDelegate:self TcpStateChangeBlock:^(NSDictionary *dict) {

    }];
    
    // 获取健康检测仪SDK对象
    self.sdkHealth = [LibHealthCombineSDK Instance].LT_HealthMonitor;
//    self.sdkHealth = [[SDKHealthMoniter alloc] init];
//    self.sdkHealth.sdkHealthMoniterdelegate =self;
    
    self.peripherals = [NSMutableArray array];
    [self.sdkHealth scanStart];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 修改导航栏和状态栏渐变色
- (void)prepareNavigationColor {
    // iOS7之后，设置状态栏和导航栏统一背景色，是很简单的，但是渐变颜色又是特殊的一种
    [ChangeView2GradientColor changeView:self.navigationController.navigationBar toGradientColors:@[UIColorHex(#1F67B6),UIColorHex(#51A8F2),UIColorHex(#89BDF4),UIColorHex(#C1E4FE)]];
    
    // 重新自定义设置导航栏
    // 左侧视图
    MeasureNaviLeftView *leftview = [[MeasureNaviLeftView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    
    // 标题
    UILabel *title_copy = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title_copy.textAlignment = NSTextAlignmentCenter;
    title_copy.text = @"测量";
    title_copy.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    title_copy.textColor = [UIColor whiteColor];
    
    // 右侧视图
    __weak typeof(self) myself = self;
    _rightview = [[MeasureNaviRightView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    _rightview.connectBlock = ^(BOOL isConnected) {
        NSLog(@"连接");
        for (int i = 0; i<self.peripherals.count; i++) {
            NSDictionary *dic = myself.peripherals[i];
            if ([dic[@"LocalName"] isEqualToString:@"HC02-F00483"]) {
                [myself.sdkHealth connectBlueTooth:myself.peripherals.firstObject[@"peripheral"]];
                [myself.sdkHealth scanStop];
            }
        }
    };
    
    [ChangeView2GradientColor changeControllerView:self.view withNavi:self.navigationItem setLeftView:leftview RightView:_rightview Title:title_copy];
    
}


#pragma mark - 蓝牙回调
- (void)didScanedPeripherals:(NSMutableArray *)foundPeripherals {
    NSLog(@"搜索到设备个数%ld",(long)foundPeripherals.count);
    [self.peripherals removeAllObjects];
    [self.peripherals addObjectsFromArray:foundPeripherals];
    
//    [self.sdkHealth connectBlueTooth:foundPeripherals.firstObject[@"peripheral"]];
//    [self.sdkHealth scanStop];
}

- (void)didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"连接到设备%@",peripheral);
    self.peripheral = peripheral;
    [DeviceManger defaultManager].peripheral = peripheral;
    self.rightview.isPeriperalConnected = YES;
}

- (void)disconnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"蓝牙断开连接");
}

/**
 * 测量温度的回调
 */
- (void)receiveThermometerData:(double)temperature {
    NSLog(@"体温测量结果：%f",temperature);
}


/**
 *  @discussion  Get Oximetry results
 *
 *  @param Oximetry Oximetry value
 *  @param heartRate heartRate value
 */
- (void)receiveOximetryData:(double)oxy andHeartRate:(int)heartRate {
    
}




/**
 *  @discussion Get BloodPressure results
 *
 *  @param BloodPressure Systolic_pressure value Diastolic_pressure value
 *          Heart_beat value
 */
- (void)receiveBloodPressure:(int)Systolic_pressure andDiastolic_pressure:(int)Diastolic_pressure andHeart_beat:(int)Heart_beat {
    
}

/**
 *  @discussion
 *
 *  @param msgtype msgType ENUM
 *  @param row     if row!=nil , according to this param ,invoke method getBloodSugarInRow in this object(SDKHealthMoniter) to transform blood sugar
 */
- (void) receiveBloodSugar:(MSGTYPE) msgtype andRow:(NSNumber*) row {
    
}



/**
 *  @discussion Get ECG results
 *
 *  @param ECGData rrMax value rrMin value HRV value
 *                  mood value smoothWave LineData heartRate Value
 */
- (void)receiveECGDataRRmax:(int)rrMax {
    
}

- (void)receiveECGDataRRMin:(int)rrMin {
    
}

- (void)receiveECGDataHRV:(int)hrv {
    
}

- (void)receiveECGDataMood:(int)mood {
    
}

- (void)receiveECGDataSmoothedWave:(int)smoothedWave {
    
}

- (void)receiveECGDataHeartRate:(int)heartRate {
    
}


- (BOOL)prefersStatusBarHidden {
  return NO;
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
