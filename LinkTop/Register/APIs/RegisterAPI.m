//
//  RegisterAPI.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/26.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "RegisterAPI.h"
#import "DCHttpRequest.h"
#import "CommonEntities.h"

@interface RegisterAPI ()
{
    NSDictionary *params;
}
@property (nonatomic, strong) DCHttpRequest *request;
@property (nonatomic, strong) DCDatabase *mainDatabase;

@end

@implementation RegisterAPI

#pragma mark - network operation

- (void)registerWithPhone:(NSString *)phone pwd:(NSString *)pwd compeletion:(void(^)(BOOL, id))complete {
    params = @{@"login_name" : phone,
               @"password" : pwd};
    [self loadRequestPropertiesWithMethod:@"auth/linkReg"];
    
    [self.request startWithSuccess:^(id result) {
        complete(YES, result);
        
    } failure:^(NSInteger errCode, NSString *errMsg, NSDictionary *userInfo) {
        if (errCode==20000) {
            complete(NO, @"用户已存在");
        }
        else {
            complete(NO, errMsg);
        }
    }];
}

- (void)loadRequestPropertiesWithMethod:(NSString *)method
{
    [self.request cancelRequest];
    
    self.request.type    = DCHttpRequestTypePOST;
    self.request.baseUrl = BASE_URL;
    self.request.method  = method;
    self.request.params  = params;
    
    self.request.allowsLogMethod       = kLogEnabled;
    self.request.allowsLogHeader       = kHttpRequestAllowsLogHeader;
    self.request.allowsLogResponseGET  = kHttpRequestAllowsLogResponseGET;
    self.request.allowsLogResponsePOST = kHttpRequestAllowsLogResponsePOST;
    self.request.allowsLogRequestError = kHttpRequestAllowsLogRequestError;
    
    [self.request setValue:ACCESS_TOKEN
        forHTTPHeaderField:@"ACCESS_TOKEN"];
    [self.request setValue:@"application/json"
        forHTTPHeaderField:@"Content-Type"];
}

- (void)loadRequestTokenPropertiesWithMethod:(NSString *)method
{
    [self.request cancelRequest];
    
    self.request.type    = DCHttpRequestTypePOST;
    self.request.baseUrl = BASE_URL;
    self.request.method  = method;
    self.request.params  = params;
    
    self.request.allowsLogMethod       = kLogEnabled;
    self.request.allowsLogHeader       = kHttpRequestAllowsLogHeader;
    self.request.allowsLogResponseGET  = kHttpRequestAllowsLogResponseGET;
    self.request.allowsLogResponsePOST = kHttpRequestAllowsLogResponsePOST;
    self.request.allowsLogRequestError = kHttpRequestAllowsLogRequestError;
    
    Patient *user;
    
    [self.request setValue:[NSString stringWithFormat:@"%lld",user.APP_KEY]
        forHTTPHeaderField:@"APP_KEY"];
    [self.request setValue:user.APP_TOKEN
        forHTTPHeaderField:@"APP_TOKEN"];
    [self.request setValue:ACCESS_TOKEN
        forHTTPHeaderField:@"ACCESS_TOKEN"];
    [self.request setValue:@"application/json"
        forHTTPHeaderField:@"Content-Type"];
}

- (DCHttpRequest *)request {
    if (!_request) {
        _request = [[DCHttpRequest alloc] init];
    }
    return _request;
}

#pragma mark - database operation
- (DCDatabase *)mainDatabase {
    return [self database:@"main.db" withKey:@"1234567890ABCDEF"];
}

@end
