//
//  LoginAPI.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "LoginAPI.h"
#import "DCHttpRequest.h"
#import "CommonEntities.h"

@interface LoginAPI ()
{
    NSDictionary *params;
}
@property (nonatomic, strong) DCHttpRequest *request;
@property (nonatomic, strong) DCDatabase *mainDatabase;


@end

@implementation LoginAPI

- (void)loginWithUserName:(NSString *)name pwd:(NSString *)password completion:(void(^)(BOOL success, Patient *user, NSString *msg))complete {
    params = @{@"login_name" : name,
               @"password"   : password};
    [self loadRequestPropertiesWithMethod:@"auth/linkLogin"];
    
    [self.request startWithSuccess:^(id result) {
        NSDictionary *dic = @{
                              @"Id"        :result[@"id"]?result[@"id"]:@"",
                              @"user_id"   :result[@"user_id"]?result[@"user_id"]:@"",
                              @"login_name":name,
                              @"password"  :password,
                              @"gender"    :result[@"gender"]?result[@"gender"]:@"",
                              @"age"       :result[@"age"]?result[@"age"]:@"",
                              @"weight"    :result[@"weight"]?result[@"weight"]:@"",
                              @"height"    :result[@"height"]?result[@"height"]:@"",
                              @"birth"     :result[@"birth"]?result[@"birth"]:@"",
                              @"APP_KEY"   :result[@"APP_KEY"]?result[@"APP_KEY"]:@"",
                              @"APP_TOKEN" :result[@"APP_TOKEN"]?result[@"APP_TOKEN"]:@"",
                              @"is_quest"  :result[@"is_quest"]?result[@"is_quest"]:@"",
                              @"isLastAdd" :@YES,
                              };
        Patient *patient = [[Patient alloc] initWithDictionary:dic];
        // 存储到数据库
        [self.mainDatabase updateObjects:@[patient]];
        complete(YES, patient, @"");
        
    } failure:^(NSInteger errCode, NSString *errMsg, NSDictionary *userInfo) {
        complete(NO, nil,errMsg);
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

- (Patient *)getCurrentPatientFormMainDB {
    NSString *sql = [NSString stringWithFormat:
                     @"SELECT * FROM %@ where isLastAdd = ?",
                     [Patient tableName]];
    
    NSArray *result = [self.mainDatabase query:sql withArguments:@[@(YES)] convertTo:[Patient class]];
    
    return result.firstObject;
}

- (DCDatabase *)mainDatabase {
    return [self database:@"main.db" withKey:@"1234567890ABCDEF"];
}

@end
