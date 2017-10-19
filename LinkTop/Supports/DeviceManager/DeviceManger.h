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

+ (instancetype)defaultManager;



@end
