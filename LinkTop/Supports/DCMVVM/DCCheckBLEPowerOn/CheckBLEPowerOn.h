//
//  CheckBLEPowerOn.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/2.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CheckBLEPowerOnDelegate <NSObject>

@optional
- (void)centralManagerDidUpdateState:(CBCentralManager *)central;

@end

@interface CheckBLEPowerOn : NSObject

@property (nonatomic, assign) id<CheckBLEPowerOnDelegate> delegate;

- (instancetype)initWithDelegate:(id)delegate;

+ (instancetype)checkItOut;

@end
