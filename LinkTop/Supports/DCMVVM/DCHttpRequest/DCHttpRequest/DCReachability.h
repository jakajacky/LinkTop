//
//  DCReachability.h
//  DCHttpRequest
//
//  Created by Duke on 14-7-24.
//  Copyright (c) 2014年 Duke. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief  网络状态监测类
 */
@interface DCReachability : NSObject

/*!
 *  @brief  开始监听网络状态
 */
- (void)startMonitoring;

/*!
 *  @brief  停止监听网络状态
 */
- (void)stopMonitoring;

/*!
 *  @brief  返回是否可以访问网络
 */
- (BOOL)isReachable;

/*!
 *  @brief  返回是否可以通过 WiFi 访问网络
 */
- (BOOL)isReachableViaWiFi;

/*!
 *  @brief  返回是否可以通过蜂窝数据访问网络
 */
- (BOOL)isReachableViaWWAN;

/*!
 *  @brief  网络状态切换到 未知 时的回调代码块
 */
@property (atomic,copy) void(^reachabilityStatusDidChangeToUnknownBlock)();

/*!
 *  @brief  网络状态切换到 WiFi 时的回调代码块
 */
@property (atomic,copy) void(^reachabilityStatusDidChangeToWiFiBlock)();

/*!
 *  @brief  网络状态切换到 蜂窝数据 时的回调代码块
 */
@property (atomic,copy) void(^reachabilityStatusDidChangeToWWANBlock)();

/*!
 *  @brief  网络状态切换到 不可连接 时的回调代码块
 */
@property (atomic,copy) void(^reachabilityStatusDidChangeToNotReachableBlock)();

/**
 *  @brief  单例获取 DCReachability 实例
 */
+ (instancetype)getInstance;

@end
