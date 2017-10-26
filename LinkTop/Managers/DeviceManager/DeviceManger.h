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
@property (nonatomic, strong) NSString *deviceID;

+ (instancetype)defaultManager;

- (void)startConnectWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                     disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                    bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete;

- (void)endConnect;

- (void)measureThermometerWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                           disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                          bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete
               receiveThermometerData:(void(^)(double temperature))receiveComplete;

- (void)endMeasureThermometer;

- (void)measureSpo2hWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                     disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                    bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete
               receiveSpo2hData:(void(^)(double oxy,int heartrate))receiveComplete;

- (void)endMeasureSpo2h;

- (void)measureBloodPresureWithConnect:(void(^)(CBPeripheral *peripheral))didConnectedComplete
                            disconnect:(void(^)(CBPeripheral *peripheral))disconnectComplete
                           bleAbnormal:(void(^)(void))bleAbnormalDisconnectComplete
                     receiveBloodPData:(void(^)(int systolic_pressure,int diastolic_pressure,int heartrate))receiveComplete
                    bpAbnormalComplete:(void(^)(NSString *message))bpAbnormalComplete;

- (void)endMeasureBloodPresure;

@end
