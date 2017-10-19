//
//  DeviceManger.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/19.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "DeviceManger.h"

@implementation DeviceManger

static DeviceManger *deviceM = nil;

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceM = [[self alloc] init];
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

@end
