//
//  MeasureManager.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/1.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "MeasureManager.h"

@interface MeasureManager ()

@property (nonatomic, strong) MeasureAPI *measureAPI;

@end

@implementation MeasureManager

static MeasureManager *measureM = nil;

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        measureM = [[self alloc] init];
    });
    return measureM;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if (!measureM) {
            measureM = [super allocWithZone:zone];
        }
        return measureM;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
