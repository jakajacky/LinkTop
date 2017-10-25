/******************************************************************************
 *  @file   : DCBizNetworkOperation.m
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-20
 *  @brief  : 网络请求业务操作基类（抽象类）
 ******************************************************************************/

#import "DCBizNetworkOperation.h"

@interface DCBizNetworkOperation ()

@property (nonatomic,readwrite) DCHttpRequest       * request;
@property (nonatomic,readonly)  DCMVVMConfiguration * configuration;

@end

@implementation DCBizNetworkOperation

+ (instancetype)operation
{
  return [[self alloc] init];
}

- (DCMVVMConfiguration *)configuration
{
  return [DCMVVMConfiguration getInstance];
}

- (DCHttpRequest *)request
{
  if (!_request) {
    _request = [[DCHttpRequest alloc] init];
    
    _request.allowsLogMethod       = self.configuration.httpRquestAllowsLogMethod;
    _request.allowsLogHeader       = self.configuration.httpRquestAllowsLogHeader;
    _request.allowsLogResponseGET  = self.configuration.httpRquestAllowsLogResponseGET;
    _request.allowsLogResponsePOST = self.configuration.httpRquestAllowsLogResponsePOST;
    _request.allowsLogRequestError = self.configuration.httpRquestAllowsLogRequestError;
  }
  
  return _request;
}

@end

@implementation DCBizNetworkOperation (DCHttpRequestConvenience)

- (DCHttpRequest *)getRequestWithBaseUrl:(NSString *)baseUrl
                                  method:(NSString *)method
                                  params:(NSDictionary *)params
{
  [self.request clearAndCancelRequest];
  
  self.request.type    = DCHttpRequestTypeGET;
  self.request.baseUrl = baseUrl;
  self.request.method  = method;
  self.request.params  = params;
  
  return self.request;
}

- (DCHttpRequest *)postRequestWithBaseUrl:(NSString *)baseUrl
                                   method:(NSString *)method
                                   params:(id)params
{
  [self.request clearAndCancelRequest];
  
  self.request.type    = DCHttpRequestTypePOST;
  self.request.baseUrl = baseUrl;
  self.request.method  = method;
  self.request.params  = params;
  
  return self.request;
}

@end
