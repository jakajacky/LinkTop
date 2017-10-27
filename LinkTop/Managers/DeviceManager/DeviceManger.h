//
//  DeviceManger.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/19.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface DeviceManger : NSObject

@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) NSString *softVersion;
@property (nonatomic, strong) NSString *hardVersion;

+ (instancetype)defaultManager;

/**
 * 连接设备
 */
- (void)startConnectWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                     disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                    bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete;
/**
 * 断开连接
 */
- (void)endConnect;

/**
 * 测量体温
 */
- (void)measureThermometerWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                           disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                          bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete
               receiveThermometerData:(void(^)(double temperature))receiveComplete;
/**
 * 结束体温测量
 */
- (void)endMeasureThermometer;

/**
 * 测量血氧
 * @param didConnectedComplete 蓝牙连接回调
 */
- (void)measureSpo2hWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                     disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                    bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete
               receiveSpo2hData:(void(^)(double oxy,int heartrate))receiveComplete;
/**
 * 结束测量血氧
 */
- (void)endMeasureSpo2h;

/**
 * 测量血压
 */
- (void)measureBloodPresureWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                            disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                           bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete
                     receiveBloodPData:(void(^)(int systolic_pressure,int diastolic_pressure,int heartrate))receiveComplete
                    bpAbnormalComplete:(void(^)(NSString *message))bpAbnormalComplete;
/**
 * 结束测量血压
 */
- (void)endMeasureBloodPresure;

/**
 * 测量心电
 */
- (void)measureECGWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                   disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                  bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete
                 receiveRRMax:(void(^)(int rrmax))receiveRRMaxComplete
                 receiveRRMin:(void(^)(int rrmin))receiveRRMinComplete
                   receiveHRV:(void(^)(int hrv))receiveHRVComplete
                  receiveMood:(void(^)(int mood))receiveMoodComplete
             receiveSmothWave:(void(^)(int revdata))receiveSmothWaveComplete
             receiveHeartRate:(void(^)(int heartrate))receiveHeartRateComplete
    ReceiveBreathRateComplete:(void(^)(int breathrate))receiveBreathRateComplete;
/**
 * 结束测量心电
 */
- (void)endMeasureECG;

/**
 * 获取设备ID和key
 */
- (void)getDeviceIdAndKey:(void(^)(NSString *PID,NSString *key))receiveDeviceIDandKeyComplete;
@end
