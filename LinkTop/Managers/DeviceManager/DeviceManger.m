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
typedef void(^ReceiveSpo2hDataComplete)(double oxy);
typedef void(^ReceiveBloodPComplete)(int s_p,int d_p,int heartrate);

typedef void(^ReceiveRRMaxComplete)(int rrmax);
typedef void(^ReceiveRRMinComplete)(int rrmin);
typedef void(^ReceiveHRVComplete)(int hrv);
typedef void(^ReceiveMoodComplete)(int mood);
typedef void(^ReceiveSmothWaveComplete)(int revdata);
typedef void(^ReceiveHeartRateComplete)(int heartrate);
typedef void(^ReceiveBreathRateComplete)(int breathrate);

typedef void(^ReceiveDeviceIDandKeyComplete)(NSString *,NSString *);

@interface DeviceManger ()<sdkHealthMoniterDelegate>
{
    int isConnectTimeout;
    DidConnectedComplete          _didConnectedComplete_ble;
    DisconnectComplete            _disconnectComplete_ble;
    BleAbnormalDisconnectComplete _bleAbnormalDisconnectComplete_ble;
    
    
    ReceiveTempComplete           _receiveTempComplete;
    ReceiveSpo2hComplete          _receiveSpo2hComplete;
    ReceiveSpo2hDataComplete      _receiveSpo2hDataComplete;
    ReceiveBloodPComplete         _receiveBloodPComplete;
    BpAbnormalComplete            _bpAbnormalComplete;
    
    ReceiveRRMaxComplete          _receiveRRMaxComplete;
    ReceiveRRMinComplete          _receiveRRMinComplete;
    ReceiveHRVComplete            _receiveHRVComplete;
    ReceiveMoodComplete           _receiveMoodComplete;
    ReceiveSmothWaveComplete      _receiveSmothWaveComplete;
    ReceiveHeartRateComplete      _receiveHeartRateComplete;
    ReceiveBreathRateComplete     _receiveBreathRateComplete;
    
    ReceiveDeviceIDandKeyComplete _receiveDeviceIDandKeyComplete;
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

#pragma mark -测量血氧
- (void)measureSpo2hWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                     disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                    bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete
               receiveSpo2hData:(void(^)(double oxy))receiveSpo2hDataComplete
               receiveSpo2hResult:(void(^)(double oxy,int heartrate))receiveComplete {
    [self.sdkHealth startOximetryTest];
    
    _didConnectedComplete_ble = didConnectedComplete;
    _disconnectComplete_ble   = disconnectComplete;
    _bleAbnormalDisconnectComplete_ble = bleAbnormalDisconnectComplete;
    _receiveSpo2hDataComplete = receiveSpo2hDataComplete;
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

#pragma mark - 测量ECG
- (void)measureECGWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                            disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                           bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete
                 receiveRRMax:(void(^)(int rrmax))receiveRRMaxComplete
                 receiveRRMin:(void(^)(int rrmin))receiveRRMinComplete
                   receiveHRV:(void(^)(int hrv))receiveHRVComplete
                  receiveMood:(void(^)(int mood))receiveMoodComplete
             receiveSmothWave:(void(^)(int revdata))receiveSmothWaveComplete
             receiveHeartRate:(void(^)(int heartrate))receiveHeartRateComplete
    ReceiveBreathRateComplete:(void(^)(int breathrate))receiveBreathRateComplete {
    [self.sdkHealth startECG];
    
    _didConnectedComplete_ble = didConnectedComplete;
    _disconnectComplete_ble   = disconnectComplete;
    _bleAbnormalDisconnectComplete_ble = bleAbnormalDisconnectComplete;
    
    _receiveRRMaxComplete = receiveRRMaxComplete;
    _receiveRRMinComplete = receiveRRMinComplete;
    _receiveHRVComplete   = receiveHRVComplete;
    _receiveMoodComplete  = receiveMoodComplete;
    _receiveSmothWaveComplete = receiveSmothWaveComplete;
    _receiveHeartRateComplete = receiveHeartRateComplete;
    _receiveBreathRateComplete = receiveBreathRateComplete;
}

#pragma mark - 结束测量ECG
- (void)endMeasureECG {
    [self.sdkHealth endECG];
}

#pragma mark - 获取设备ID和key
- (void)getDeviceIdAndKey:(void(^)(NSString *PID,NSString *key))receiveDeviceIDandKeyComplete {
    [self.sdkHealth startToGetPidAndKey];
    _receiveDeviceIDandKeyComplete = receiveDeviceIDandKeyComplete;
}

#pragma mark - 蓝牙和测量结果 回调
- (void)didScanedPeripherals:(NSMutableArray *)foundPeripherals {
    NSLog(@"DM搜索到设备个数%ld",(long)foundPeripherals.count);
    [self.peripherals removeAllObjects];
    [self.peripherals addObjectsFromArray:foundPeripherals];
}

- (void)didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"DM连接到设备%@",peripheral);
    self.peripheral = peripheral;
    
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
    self.softVersion = nil;
    self.hardVersion = nil;
    
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
 *   @discussion  Get Oximetry wave data
 *
 *   @param oxyWave 单个点的值
 */
-(void)receiveOximetryWave:(double)oxyWave {
    NSLog(@"DM血氧revData：%f",oxyWave);
    if (_receiveSpo2hDataComplete) {
        _receiveSpo2hDataComplete(oxyWave);
    }
}

#pragma mark - 测量血压
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

-(void)receiveECGDataRRmax:(int)rrMax {
    NSLog(@"DM心电区间最大值：%d",rrMax);
    if (_receiveRRMaxComplete) {
        _receiveRRMaxComplete(rrMax);
    }
}

-(void)receiveECGDataRRMin:(int)rrMin {
    NSLog(@"DM心电区间最小值：%d",rrMin);
    if (_receiveRRMinComplete) {
        _receiveRRMinComplete(rrMin);
    }
}

-(void)receiveECGDataHRV:(int)hrv {
    NSLog(@"DM心率变异性：%d",hrv);
    [self.sdkHealth endECG];
    if (_receiveHRVComplete) {
        _receiveHRVComplete(hrv);
    }
}

-(void)receiveECGDataMood:(int)mood {
    NSLog(@"DM心情值：%d",mood);
    if (_receiveMoodComplete) {
        _receiveMoodComplete(mood);
    }
}

-(void)receiveECGDataSmoothedWave:(int)smoothedWave {
    NSLog(@"DM revData：%d",smoothedWave);
    if (_receiveSmothWaveComplete) {
        _receiveSmothWaveComplete(smoothedWave);
    }
}

-(void)receiveECGDataHeartRate:(int)heartRate {
    NSLog(@"DM心率结果：%d",heartRate);
    if (_receiveHeartRateComplete) {
        _receiveHeartRateComplete(heartRate);
    }
}

- (void)receiveECGDataBreathRate:(int)breathRate {
    NSLog(@"DM呼吸率：%d", breathRate);
    if (_receiveBreathRateComplete) {
        _receiveBreathRateComplete(breathRate);
    }
}

-(void)blueToothAbnormalDisconnect {
    NSLog(@"DM蓝牙异常断开连接");
    self.peripheral = nil;
    self.softVersion = nil;
    self.hardVersion = nil;
    
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
    self.softVersion = softversion;
}



/*!
 *  @method hardVersion  硬件版本
 *
 *  @param hardversion  hardware version
 *
 */
- (void)hardVersion:(NSString*)hardversion {
    NSLog(@"DM硬件版本：%@",hardversion);
    self.hardVersion = hardversion;
    [self.sdkHealth startToGetPidAndKey];
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
    self.deviceID  = pid;
    self.deviceKEY = key;
    if (_receiveDeviceIDandKeyComplete) {
        _receiveDeviceIDandKeyComplete(pid,key);
    }
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
