//
//  DCHttpRequest.m
//  DCHttpRequest
//
//  Created by Duke on 14-7-24.
//  Copyright (c) 2014年 Duke. All rights reserved.
//

#import "DCHttpRequest.h"
#import "DCReachability.h"

#import "AFNetworking.h"
#import "AFgzipRequestSerializer.h"

#import "NSString+HttpRequestAdditions.h"

#import "AES.h"

@interface DCHttpRequest ()

@property (nonatomic,strong) DCReachability         * reachability;
@property (nonatomic,strong) AFHTTPRequestOperation * operation;
@property (nonatomic,strong) NSMutableURLRequest    * request;

@property (nonatomic,readonly) NSString * typeString;
@property (nonatomic,readonly) id         completeParams;

@property (nonatomic,strong) NSMutableDictionary * additionalHeader;

@end

@implementation DCHttpRequest

- (instancetype)init
{
  self = [super init];
  
  if (self) {
    _type             = DCHttpRequestTypeGET;
    _timeout          = 25.0;
    _additionalHeader = [NSMutableDictionary dictionary];
  }
  
  return self;
}

+ (instancetype)request
{
  return [[self alloc] init];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
  if (value == nil) {
    [self.additionalHeader removeObjectForKey:field];
  }
  else {
    self.additionalHeader[field] = value;
  }
}

- (void)startWithSuccess:(void (^)(id))success
                 failure:(void (^)(NSInteger, NSString *, NSDictionary *))failure
{
  if (!self.reachability.isReachable) {
    if (self.allowsLogRequestError) {
      NSLog(@"\nmethod:%@\nerrorCode:%d\n%@\n\n", self.method, 0, @"无法连接网络");
    }
    failure(0123, @"无法连接网络", nil);
    return;
  }
  
  if (self.type == DCHttpRequestTypePOST) {
    [self preparePostRequest];
  }
  else {
    [self prepareGetRequest];
  }
  
  NSString          *method = self.method;
  DCHttpRequestType  type   = self.type;
  
  self.operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
  
  BOOL      isEncryptionEnabled = self.isEncryptionEnabled;
  NSString *encryptionKey       = self.encryptionKey;
  
  BOOL allowsLogResponseGET  = self.allowsLogResponseGET;
  BOOL allowsLogResponsePOST = self.allowsLogResponsePOST;
  BOOL allowsLogRequestError = self.allowsLogRequestError;
  
  [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSInteger  statusCode     = operation.response.statusCode;
    NSString  *responseString = nil;
    
    if (isEncryptionEnabled) {
      NSString *encryptedString = [[NSString alloc] initWithData:responseObject
                                                        encoding:NSUTF8StringEncoding];
      responseString = [[AES AES256] decryptString:encryptedString withKey:encryptionKey progress:nil];
    }
    else {
      responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    }
    
    responseObject = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                     options:0
                                                       error:nil];
    
    switch (type) {
      case DCHttpRequestTypeGET:
        if (allowsLogResponseGET) {
          NSLog(@"\nmethod:%@\nstatusCode:%zd\n%@\n\n", method, statusCode, responseString);
        }
        break;
      case DCHttpRequestTypePOST:
        if (allowsLogResponsePOST) {
          NSLog(@"\nmethod:%@\nstatusCode:%zd\n%@\n\n", method, statusCode, responseString);
        }
        break;
      default:
        break;
    }
    
    if (operation.response.statusCode == 200) {
      NSDictionary *data = responseObject[@"data"];
      NSInteger  code    = [responseObject[@"code"] integerValue];
      NSString  *msg     = responseObject[@"msg"];
      NSString  *errMsg  = responseObject[@"error"][0];
      if (code == 10000) {
          success(data);
        
      }
      else if (code == 90000) {
          if (allowsLogRequestError) {
              NSLog(@"\nmethod:%@\nerrorCode:%zd\n%@\n\n", method, code, msg);
          }
          failure(code, errMsg?errMsg:msg, data);
      }
      else {
          if (allowsLogRequestError) {
              NSLog(@"\nmethod:%@\nerrorCode:%zd\n%@\n\n", method, code, errMsg);
          }
          failure(code, msg, data);
      }
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSInteger errCode = operation.response.statusCode;
    NSString *errMsg  = error.localizedDescription;
    if (allowsLogRequestError) {
      NSLog(@"\nmethod:%@\nerrorCode:%zd\n%@\n\n", method, errCode, errMsg);
    }
    failure(errCode, errMsg, nil);
  }];
  
  [self start];
}

- (void)cancelRequest
{
  if (self.request) {
    [self.operation cancel];
    self.operation = nil;
    self.request = nil;
  }
}

- (void)clearAndCancelRequest
{
  if (self.request) {
    [self.operation setCompletionBlock:nil];
    [self.operation cancel];
    self.operation = nil;
    self.request = nil;
  }
}

- (BOOL)isCancelled
{
  return self.operation.isCancelled;
}

- (BOOL)isExecuting
{
  return self.operation.isExecuting;
}

- (BOOL)isFinished
{
  return self.operation.isFinished;
}

- (BOOL)isReady
{
  return self.operation.isReady;
}

#pragma mark -
#pragma mark Private Methods

- (void)prepareGetRequest
{
  NSString *urlString = [self urlStringWithParams:self.completeParams];
  
  if (self.allowsLogMethod) {
    NSLog(@"\nGET\n%@\n\n", urlString);
  }
  
  AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
  serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-gzip", nil];
  
  self.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  self.request.HTTPMethod      = self.typeString;
  self.request.timeoutInterval = self.timeout;
  
  [self.request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
  
  [self.additionalHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    [self.request setValue:obj forHTTPHeaderField:key];
  }];
}

- (void)preparePostRequest
{
  NSString *urlString = [self urlStringWithParams:nil];
  NSData   *HTTPBody  = nil;
  
  AFHTTPRequestSerializer *httpSerializer = nil;
  
  if (self.isEncryptionEnabled) {
    httpSerializer = [AFHTTPRequestSerializer serializer];
    
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:self.completeParams
                                                         options:0
                                                           error:nil];
    
    NSString *paramsString = [[NSString alloc] initWithData:paramsData
                                                   encoding:NSUTF8StringEncoding];
    
    NSString *encryptedString = [[AES AES256] encryptString:paramsString
                                                    withKey:self.encryptionKey
                                                   progress:nil];
    HTTPBody = [encryptedString dataUsingEncoding:NSUTF8StringEncoding];
  }
  else {
    httpSerializer = [AFJSONRequestSerializer serializer];
    
    HTTPBody = [NSJSONSerialization dataWithJSONObject:self.completeParams options:0 error:nil];
  }
  
  AFgzipRequestSerializer *gzipSerializer = [AFgzipRequestSerializer serializerWithSerializer:httpSerializer];
  
  self.request = [gzipSerializer requestWithMethod:self.typeString
                                         URLString:urlString
                                        parameters:nil
                                             error:nil];
  
  [self.request setValue:@"application/x-gzip" forHTTPHeaderField:@"Content-Type"];
  
  [self.additionalHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    [self.request setValue:obj forHTTPHeaderField:key];
  }];
  
  if (self.allowsLogMethod) {
    NSLog(@"\nPOST\n%@\n%@\n\n", urlString, self.params);
  }
  
  self.request.URL             = [NSURL URLWithString:urlString];
  self.request.HTTPMethod      = self.typeString;
  self.request.timeoutInterval = self.timeout;
  self.request.HTTPBody        = HTTPBody;
}

- (NSString *)urlStringWithParams:(id)params
{
  NSMutableString *url = [NSMutableString string];
  
  [url appendFormat:@"%@/%@?", self.baseUrl, self.method];
  
  if ([params isKindOfClass:[NSDictionary class]]) {
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
      NSString *val = [obj isKindOfClass:[NSString class]] ? [obj dchr_urlEncode] : obj;
      [url appendFormat:@"%@=%@&", key, val];
    }];
  }
  
  [url deleteCharactersInRange:NSMakeRange(url.length - 1, 1)];
  
  return url;
}

- (void)start
{
  if (self.allowsLogHeader) {
    NSLog(@"\nRequest Headers :\n%@", self.request.allHTTPHeaderFields);
  }
  
  [[NSOperationQueue mainQueue] addOperation:self.operation];
}

#pragma mark -
#pragma mark Properties

- (AFHTTPRequestOperation *)operation
{
  if (!_operation) {
    _operation = [[AFHTTPRequestOperation alloc] initWithRequest:self.request];
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
  }
  
  return _operation;
}

- (DCReachability *)reachability
{
  return [DCReachability getInstance];
}

- (NSString *)typeString
{
  NSString *str = nil;
  
  switch (self.type) {
    case DCHttpRequestTypeGET:
      str = @"GET";
      break;
    case DCHttpRequestTypePOST:
      str = @"POST";
      break;
    default:
      str = @"UNKNOWN";
      break;
  }
  
  return str;
}

- (id)completeParams
{
  id params = nil;
  if ([self.params isKindOfClass:[NSDictionary class]]) {
    params = [NSMutableDictionary dictionaryWithDictionary:self.params];
    params[@"tik"] = @([[NSDate date] timeIntervalSince1970]);
  }
  else {
    params = self.params;
  }
  
  return params;
}

@end
