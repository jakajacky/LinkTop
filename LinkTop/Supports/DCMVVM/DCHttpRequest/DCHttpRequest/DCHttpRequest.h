//
//  DCHttpRequest.h
//  DCHttpRequest
//
//  Created by Duke on 14-7-24.
//  Copyright (c) 2014年 Duke. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief  网络请求类型枚举
 */
typedef NS_ENUM(NSUInteger, DCHttpRequestType) {
  /**
   *  @brief  GET 请求
   */
  DCHttpRequestTypeGET,
  /**
   *  @brief  POST 请求
   */
  DCHttpRequestTypePOST,
  /**
   *  @brief  其他请求
   */
  DCHttpRequestTypeOthers
};

/*!
 *  @brief  网络请求基类
 */
@interface DCHttpRequest : NSObject

/** @name  properties */

/*!
 *  @brief  网络请求类型
 *  @see    DCHttpRequestType
 */
@property (nonatomic,assign) DCHttpRequestType   type;

/*!
 *  @brief      网络请求 HOST 及 路径 组成的 base URL
 *  @discussion Example: http://192.168.1.10:1234/service
 */
@property (nonatomic,copy)   NSString          * baseUrl;

/*!
 *  @brief      请求方法名
 *  @discussion Example: getCalls
 */
@property (nonatomic,copy)   NSString          * method;

/*!
 *  @brief      请求参数
 *  @discussion 若使用 GET 请求，则参数类型只能为 NSDictionary；
 *              若使用 POST 请求，则参数类型可以是 NSArray 或 NSDictionary
 */
@property (nonatomic,copy)   id                  params;

/*!
 *  @brief       超时时间
 *  @discussion  单位：秒；默认值 15.0
 */
@property (nonatomic,assign) NSTimeInterval      timeout;

- (instancetype)init;
+ (instancetype)request;

/*!
 *  @brief  设置指定的 HTTP 请求头
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/*!
 *  @brief  发起请求
 *
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 *
 *  @discussion  每次发起请求时，会首先检测网络情况，若网络不通，则直接调用 failure，错误码为0
 */
- (void)startWithSuccess:(void (^)(id result))success
                 failure:(void (^)(NSInteger errCode, NSString *errMsg, NSDictionary *userInfo))failure;

/*!
 *  @brief  取消当前请求，会调用 failure 的回调，错误码为0
 */
- (void)cancelRequest;

/*!
 *  @brief  取消当前请求，不会会调用任何回调
 */
- (void)clearAndCancelRequest;

- (BOOL)isCancelled;
- (BOOL)isExecuting;
- (BOOL)isFinished;
- (BOOL)isReady;

/*!
 *  @brief  是否允许打印请求方法名
 */
@property (nonatomic) BOOL allowsLogMethod;

/*!
 *  @brief  是否允许打印请求头
 */
@property (nonatomic) BOOL allowsLogHeader;

/*!
 *  @brief  是否允许打印 GET 请求的结果
 */
@property (nonatomic) BOOL allowsLogResponseGET;

/*!
 *  @brief  是否允许打印 POST 请求的结果
 */
@property (nonatomic) BOOL allowsLogResponsePOST;

/*!
 *  @brief  是否允许打印错误信息
 */
@property (nonatomic) BOOL allowsLogRequestError;

/*!
 *  @brief  请求结果是否加密
 */
@property (nonatomic)      BOOL      isEncryptionEnabled;

/*!
 *  @brief       请求结果密钥
 *  @discussion  当 isEncryptionEnabled 属性为 NO 时，该属性不生效
 */
@property (nonatomic,copy) NSString *encryptionKey;

@end
