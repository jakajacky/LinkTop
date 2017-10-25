
/******************************************************************************
 *  @file   : DCResult.m
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-21
 *  @brief  : 业务操作结果基类
 ******************************************************************************/

#import "DCResult.h"

@interface DCResult ()

@property (nonatomic,readwrite) BOOL          success;
@property (nonatomic,readwrite) NSInteger     errorCode;
@property (nonatomic,readwrite) NSString     *errorMessage;
@property (nonatomic,readwrite) NSDictionary *userInfo;
@end

@implementation DCResult

+ (instancetype)successResult
{
  DCResult *r = [[self alloc] init];
  r.success = YES;
  return r;
}

+ (instancetype)errorResultWithCode:(NSInteger)code message:(NSString *)message
{
  return [self errorResultWithCode:code message:message userInfo:nil];
}

+ (instancetype)errorResultWithCode:(NSInteger)code
                            message:(NSString *)message
                           userInfo:(NSDictionary *)userInfo
{
  DCResult *r = [[self alloc] init];
  r.success      = NO;
  r.errorCode    = code;
  r.errorMessage = message;
  r.userInfo     = userInfo;
  return r;
}

@end
