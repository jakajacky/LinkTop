//
//  DeviceManger.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/19.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "DeviceManger.h"
#import "LibHealthCombineSDK.h"
#import "SDKHealthMoniter.h"

typedef void(^DidConnectedComplete)(CBPeripheral *peripheral);
typedef void(^DisconnectComplete)(CBPeripheral *peripheral);
typedef void(^BleAbnormalDisconnectComplete)(void);

typedef void(^BpAbnormalComplete)(NSString *message);
typedef void(^ReceiveTempComplete)(double temperatrue);
typedef void(^ReceiveSpo2hComplete)(double oxy,int heartrate);
typedef void(^ReceiveBloodPComplete)(int s_p,int d_p,int heartrate);

@interface DeviceManger ()<sdkHealthMoniterDelegate>
{
    int isConnectTimeout;
    DidConnectedComplete          _didConnectedComplete_ble;
    DisconnectComplete            _disconnectComplete_ble;
    BleAbnormalDisconnectComplete _bleAbnormalDisconnectComplete_ble;
    
    
    ReceiveTempComplete           _receiveTempComplete;
    ReceiveSpo2hComplete          _receiveSpo2hComplete;
    ReceiveBloodPComplete         _receiveBloodPComplete;
    BpAbnormalComplete            _bpAbnormalComplete;
    
    
}
@property (nonatomic, strong) SDKHealthMoniter *sdkHealth;
@property (nonatomic, strong) NSMutableArray   *peripherals;
@property (nonatomic, strong) NSTimer          *timer;

@end

@implementation DeviceManger

static DeviceManger *deviceM = nil;

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceM = [[self alloc] init];
        
        // 启动服务
        [[LibHealthCombineSDK Instance] StartHealthMonitorServiceWithDelegate:deviceM TcpStateChangeBlock:^(NSDictionary *dict) {
            
        }];
        
        // 获取健康检测仪SDK对象
        deviceM.sdkHealth = [LibHealthCombineSDK Instance].LT_HealthMonitor;
        //    self.sdkHealth = [[SDKHealthMoniter alloc] init];
        //    self.sdkHealth.sdkHealthMoniterdelegate =self;
        
        deviceM.peripherals = [NSMutableArray array];
    });
    return deviceM;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if (!deviceM) {
            deviceM = [super allocWithZone:zone];
        }
        return deviceM;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - 连接
- (void)startConnectWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                     disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                    bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete {
    // 先扫描，2s后开始连接
    [self.sdkHealth scanStart];
    _didConnectedComplete_ble          = didConnectedComplete;
    _disconnectComplete_ble            = disconnectComplete;
    _bleAbnormalDisconnectComplete_ble = bleAbnormalDisconnectComplete;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 用于超时计算
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        isConnectTimeout = 0;
        if (self.peripherals.count>0) {
            NSDictionary *dic = self.peripherals[0];
            if ([dic.allKeys containsObject:@"LocalName"]&&[dic[@"LocalName"] isEqualToString:@"HC02-F00483"]) {//483 46A
                [self.sdkHealth connectBlueTooth:self.peripherals.firstObject[@"peripheral"]];
            }
        }
        
    });
}

#pragma mark - 断开
- (void)endConnect {
    [self.sdkHealth disconnectBlueTooth:self.peripheral];
}

#pragma mark - 测量体温
- (void)measureThermometerWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                           disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                          bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete
               receiveThermometerData:(void(^)(double temperature))receiveComplete {
    [self.sdkHealth startThermometerTest];
    
    _didConnectedComplete_ble = didConnectedComplete;
    _disconnectComplete_ble   = disconnectComplete;
    _bleAbnormalDisconnectComplete_ble = bleAbnormalDisconnectComplete;
    _receiveTempComplete = receiveComplete;
}
#pragma mark - 结束测量体温
- (void)endMeasureThermometer {
    [self.sdkHealth endThermometerTest];
}

#pragma mark - 测量血氧
- (void)measureSpo2hWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                           disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                          bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete
               receiveSpo2hData:(void(^)(double oxy,int heartrate))receiveComplete {
    [self.sdkHealth startOximetryTest];
    
    _didConnectedComplete_ble = didConnectedComplete;
    _disconnectComplete_ble   = disconnectComplete;
    _bleAbnormalDisconnectComplete_ble = bleAbnormalDisconnectComplete;
    _receiveSpo2hComplete     = receiveComplete;
}

#pragma mark - 结束测量血氧
- (void)endMeasureSpo2h {
    [self.sdkHealth endOximetryTest];
}

#pragma mark - 测量血压
- (void)measureBloodPresureWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                     disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                    bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete
               receiveBloodPData:(void(^)(int systolic_pressure,int diastolic_pressure,int heartrate))receiveComplete
                    bpAbnormalComplete:(void(^)(NSString *message))bpAbnormalComplete {
    [self.sdkHealth startBloodPressure];
    
    _didConnectedComplete_ble = didConnectedComplete;
    _disconnectComplete_ble   = disconnectComplete;
    _bleAbnormalDisconnectComplete_ble = bleAbnormalDisconnectComplete;
    _receiveBloodPComplete    = receiveComplete;
    _bpAbnormalComplete       = bpAbnormalComplete;
}

#pragma mark - 结束测量血压
- (void)endMeasureBloodPresure {
    [self.sdkHealth endBloodPressure];
}

#pragma mark - 蓝牙回调
- (void)didScanedPeripherals:(NSMutableArray *)foundPeripherals {
    NSLog(@"DM搜索到设备个数%ld",(long)foundPeripherals.count);
    [self.peripherals removeAllObjects];
    [self.peripherals addObjectsFromArray:foundPeripherals];
}

- (void)didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"DM连接到设备%@",peripheral);
    self.peripheral = peripheral;
    [DeviceManger defaultManager].peripheral = peripheral;
    
    if (_didConnectedComplete_ble) {
        _didConnectedComplete_ble(peripheral);
    }
    
    [self.sdkHealth scanStop];
    
    // 重置计数器
    isConnectTimeout = 0;
    [_timer invalidate];
    _timer = nil;
}

- (void)disconnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"DM蓝牙主动断开连接");
    self.peripheral = nil;
    [DeviceManger defaultManager].peripheral = nil;
    
    if (_disconnectComplete_ble) {
        _disconnectComplete_ble(peripheral);
    }
    
    [self.peripherals removeAllObjects];
    //    [self.sdkHealth scanStart];
}

/**
 * 测量温度的回调
 */
- (void)receiveThermometerData:(double)temperature {
    NSLog(@"DM体温测量结果：%f",temperature);
    [self.sdkHealth endThermometerTest];
    if (_receiveTempComplete) {
        _receiveTempComplete(temperature);
    }
}


/**
 *  @discussion  Get Oximetry results
 *
 *  @param oxy 血氧值
 *  @param heartRate 心率
 */
- (void)receiveOximetryData:(double)oxy andHeartRate:(int)heartRate {
    NSLog(@"DM血氧测量结果：%f",oxy);
    [self.sdkHealth endOximetryTest];
    if (_receiveSpo2hComplete) {
        _receiveSpo2hComplete(oxy,heartRate);
    }
}




/**
 *  @discussion Get BloodPressure results
 *
 *  @param BloodPressure Systolic_pressure value Diastolic_pressure value
 *          Heart_beat value
 */
- (void)receiveBloodPressure:(int)Systolic_pressure andDiastolic_pressure:(int)Diastolic_pressure andHeart_beat:(int)Heart_beat {
    NSLog(@"DM血压测量结果：%d",Systolic_pressure);
    [self.sdkHealth endBloodPressure];
    if (_receiveBloodPComplete) {
        _receiveBloodPComplete(Systolic_pressure,Diastolic_pressure,Heart_beat);
    }
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
    NSLog(@"DM蓝牙异常断开连接");
    self.peripheral = nil;
    [DeviceManger defaultManager].peripheral = nil;
    
    [self.peripherals removeAllObjects];
    //    [self.sdkHealth scanStart];
    if (_bleAbnormalDisconnectComplete_ble) {
        _bleAbnormalDisconnectComplete_ble();
    }
    
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
    NSLog(@"DM血压异常：%@",message);
    if (_bpAbnormalComplete) {
        _bpAbnormalComplete(message);
    }
}


/*!
 *  @method softVersion  软件版本
 *
 *  @param softversion   software version in device
 */
- (void)softVersion:(NSString*) softversion {
    NSLog(@"DM软件版本：%@",softversion);
    [DeviceManger defaultManager].softVersion = softversion;
}



/*!
 *  @method hardVersion  硬件版本
 *
 *  @param hardversion  hardware version
 *
 */
- (void)hardVersion:(NSString*)hardversion {
    NSLog(@"DM硬件版本：%@",hardversion);
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
    NSLog(@"DM设备id:%@,安全码%@", pid,key);
}

- (void)receiveECGDataBreathRate:(int)breathRate {
    NSLog(@"DM呼吸率：%d", breathRate);
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

@end
