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
#import "LoginViewController.h"

#define ConnectTimeout 10

@interface MeasureViewController ()<sdkHealthMoniterDelegate>
{
    int isConnectTimeout;
}
@property (nonatomic, strong) SDKHealthMoniter     *sdkHealth;

@property (nonatomic, strong) CBPeripheral         *peripheral;

@property (nonatomic, strong) NSMutableArray       *peripherals;

@property (nonatomic, strong) MeasureNaviRightView *rightview;

@property (nonatomic, strong) MeasureNaviLeftView  *leftview;

@property (nonatomic, strong) NSTimer              *timer;

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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 登录页面判断
    [[LoginManager defaultManager] shouldShowLoginViewControllerIn:self];
    _leftview.name.text = [LoginManager defaultManager].currentPatient.login_name;
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
    _leftview = [[MeasureNaviLeftView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    
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
        if (myself.peripheral) {
            NSLog(@"准备断开连接");
            [myself.sdkHealth disconnectBlueTooth:myself.peripheral];
        }
        else {
            [SVProgressHUD show];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            
            // 先扫描，2s后开始连接
            [myself.sdkHealth scanStart];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 用于超时计算
                myself.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:myself selector:@selector(timerRun) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:myself.timer forMode:NSDefaultRunLoopMode];
                isConnectTimeout = 0;
                if (myself.peripherals.count>0) {
                    NSDictionary *dic = myself.peripherals[0];
                    if ([dic.allKeys containsObject:@"LocalName"]&&[dic[@"LocalName"] isEqualToString:@"HC02-F00483"]) {//483 46A
                        [myself.sdkHealth connectBlueTooth:myself.peripherals.firstObject[@"peripheral"]];
                    }
                }
                
            });
            
            
        }
    };
    
    [ChangeView2GradientColor changeControllerView:self.view withNavi:self.navigationItem setLeftView:_leftview RightView:_rightview Title:title_copy];
    
}

#pragma mark - 蓝牙回调
- (void)didScanedPeripherals:(NSMutableArray *)foundPeripherals {
    NSLog(@"搜索到设备个数%ld",(long)foundPeripherals.count);
    [self.peripherals removeAllObjects];
    [self.peripherals addObjectsFromArray:foundPeripherals];
}

- (void)didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"连接到设备%@",peripheral);
    self.peripheral = peripheral;
    [DeviceManger defaultManager].peripheral = peripheral;
    self.rightview.isPeriperalConnected = YES;

    [SVProgressHUD dismissWithDelay:0.37];
    [self.sdkHealth scanStop];
    
    // 重置计数器
    isConnectTimeout = 0;
    [_timer invalidate];
    _timer = nil;
}

- (void)disconnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"蓝牙主动断开连接");
    self.peripheral = nil;
    [DeviceManger defaultManager].peripheral = nil;
    self.rightview.isPeriperalConnected = NO;
    [self.peripherals removeAllObjects];
//    [self.sdkHealth scanStart];
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

-(void)blueToothAbnormalDisconnect {
    NSLog(@"蓝牙异常断开连接");
    self.peripheral = nil;
    [DeviceManger defaultManager].peripheral = nil;
    self.rightview.isPeriperalConnected = NO;
    [self.peripherals removeAllObjects];
//    [self.sdkHealth scanStart];
    
    // 重置计数器
    isConnectTimeout = 0;
    [_timer invalidate];
    _timer = nil;
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


/*!
 *  @method softVersion  软件版本
 *
 *  @param softversion   software version in device
 */
- (void)softVersion:(NSString*) softversion {
    NSLog(@"软件版本：%@",softversion);
    [DeviceManger defaultManager].softVersion = softversion;
}



/*!
 *  @method hardVersion  硬件版本
 *
 *  @param hardversion  hardware version
 *
 */
- (void)hardVersion:(NSString*)hardversion {
    NSLog(@"硬件版本：%@",hardversion);
    [DeviceManger defaultManager].hardVersion = hardversion;
}

/*!
 *  @method devicePidAndKey  获取设备id 和 安全码
 *
 *  @param pid 设备id
 *  @param key 安全码
 *
 */
- (void)devicePidAndKey:(NSString *)pid Key:(NSString *)key {
    NSLog(@"设备id:%@,安全码%@", pid,key);
}

#pragma mark - 超时计算
- (void)timerRun {
    NSLog(@"....");
    isConnectTimeout += 1;
    if (isConnectTimeout >= ConnectTimeout) {
        [SVProgressHUD showErrorWithStatus:@"连接超时,请检查设备"];
        [SVProgressHUD dismissWithDelay:1.5];
        
        // 重置计数器
        isConnectTimeout = 0;
        [_timer invalidate];
        _timer = nil;
        
        [self.sdkHealth scanStop];
    }
}

- (BOOL)prefersStatusBarHidden {
  return NO;
}

#pragma mark - 进入温度测量页面
- (IBAction)TemperatureBtnDidClicked:(id)sender {
    if (!self.peripheral) {
        [SVProgressHUD showErrorWithStatus:@"未连接设备"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissWithDelay:1.5];
    }
    else {
        [self performSegueWithIdentifier:@"temperature" sender:self];
    }
}

#pragma mark - 进入血氧测量页面
- (IBAction)Spo2hBtnDidClicked:(id)sender {
    if (!self.peripheral) {
        [SVProgressHUD showErrorWithStatus:@"未连接设备"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissWithDelay:1.5];
    }
    else {
        [self performSegueWithIdentifier:@"spo2h" sender:self];
    }
}

#pragma mark - 进入心率测量页面
- (IBAction)HeartRateBtnDidClicked:(id)sender {
    if (!self.peripheral) {
        [SVProgressHUD showErrorWithStatus:@"未连接设备"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissWithDelay:1.5];
    }
    else {
        [self performSegueWithIdentifier:@"heartrate" sender:self];
    }
}

#pragma mark - 进入血压测量页面
- (IBAction)BloodPreBtnDidClicked:(id)sender {
    if (!self.peripheral) {
        [SVProgressHUD showErrorWithStatus:@"未连接设备"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissWithDelay:1.5];
    }
    else {
        [self performSegueWithIdentifier:@"bloodpre" sender:self];
    }
}

- (IBAction)ECGBtnDidClicked:(id)sender {
    if (!self.peripheral) {
        [SVProgressHUD showErrorWithStatus:@"未连接设备"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissWithDelay:1.5];
    }
    else {
        [self performSegueWithIdentifier:@"ecg" sender:self];
    }
}



@end
