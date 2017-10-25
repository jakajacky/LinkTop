
/******************************************************************************
 *  @file   : DCBizNetworkOperation.h
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-20
 *  @brief  : 网络请求业务操作基类（抽象类）
 ******************************************************************************/


#import "DCBizOperation.h"

#import "DCHttpRequest.h"
#import "DCMVVMConfiguration.h"

/*!
 *  @brief  网络请求业务操作基类
 */
@interface DCBizNetworkOperation : DCBizOperation

+ (instancetype)operation;

@property (nonatomic,readonly) DCHttpRequest * request;

@end

@interface DCBizNetworkOperation (DCHttpRequestConvenience)

/*!
 *  @brief  获取 GET 请求的 DCHttpRequest 实例
 */
- (DCHttpRequest *)getRequestWithBaseUrl:(NSString *)baseUrl
                                  method:(NSString *)method
                                  params:(NSDictionary *)params;

/*!
 *  @brief  获取 POST 请求的 DCHttpRequest 实例
 */
- (DCHttpRequest *)postRequestWithBaseUrl:(NSString *)baseUrl
                                   method:(NSString *)method
                                   params:(id)params;

@end
