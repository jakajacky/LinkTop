//
//  DCReachability.m
//  DCHttpRequest
//
//  Created by Duke on 14-7-24.
//  Copyright (c) 2014年 Duke. All rights reserved.
//

#import "DCReachability.h"
#import "AFNetworkReachabilityManager.h"

@interface DCReachability ()

@property (nonatomic,strong) AFNetworkReachabilityManager *manager;

@end

@implementation DCReachability

- (void)startMonitoring
{
  [self.manager startMonitoring];
}

- (void)stopMonitoring
{
  [self.manager stopMonitoring];
}

- (BOOL)isReachable
{
  return self.manager.isReachable;
}

- (BOOL)isReachableViaWiFi
{
  return self.manager.isReachableViaWiFi;
}

- (BOOL)isReachableViaWWAN
{
  return self.manager.isReachableViaWWAN;
}

- (AFNetworkReachabilityManager *)manager
{
  if (_manager == nil) {
    _manager = [AFNetworkReachabilityManager sharedManager];
    
    __weak __typeof(self) weakSelf = self;
    
    [_manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
      switch (status) {
        case AFNetworkReachabilityStatusUnknown:
          if (weakSelf.reachabilityStatusDidChangeToUnknownBlock) {
            weakSelf.reachabilityStatusDidChangeToUnknownBlock();
          }
          break;
        case AFNetworkReachabilityStatusNotReachable:
          if (weakSelf.reachabilityStatusDidChangeToNotReachableBlock) {
            weakSelf.reachabilityStatusDidChangeToNotReachableBlock();
          }
          break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
          if (weakSelf.reachabilityStatusDidChangeToWiFiBlock) {
            weakSelf.reachabilityStatusDidChangeToWiFiBlock();
          }
          break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
          if (weakSelf.reachabilityStatusDidChangeToWWANBlock) {
            weakSelf.reachabilityStatusDidChangeToWWANBlock();
          }
          break;
        default:
          break;
      }
    }];
  }
  
  return _manager;
}

#pragma mark -
#pragma mark Singleton Definition

static id instance = nil;

+ (instancetype)getInstance
{
  @synchronized(self){
    if (!instance) {
      instance = [[self alloc] init];
    }
  }
  
  return instance;
}

+ (instancetype)allocWithZone:(NSZone *)zone
{
  @synchronized(self){
    if (!instance) {
      instance = [super allocWithZone:zone];
    }
  }
  
  return instance;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
  return self;
}

@end
