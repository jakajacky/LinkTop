//
//  MeasureAPI.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "MeasureAPI.h"
#import "DCHttpRequest.h"

@interface MeasureAPI ()
{
    NSDictionary *params;
}
@property (nonatomic, strong) DCHttpRequest *request;
@property (nonatomic, strong) DCDatabase *mainDatabase;

@end

@implementation MeasureAPI

/**
 * 上传测量数据
 * 线上计算Rothman index
 */
- (void)uploadResult:(NSDictionary *)result type:(MeasureType)type completion:(void(^)(BOOL,id,NSString *))complete {
    params = result;
    [self loadRequestProperties];
    
    [self.request startWithSuccess:^(id result) {
        
        DiagnosticList *diagnotic = [[DiagnosticList alloc] initWithDictionary:result];
        diagnotic.Id = result[@"id"];
        diagnotic.spo2h_raw = params[@"spo2h_raw"];
        diagnotic.ecg_raw   = params[@"ecg_raw"];
        diagnotic.isSent = YES;
        diagnotic.type = type;
        // 存储数据库
        [self.mainDatabase updateObjects:@[diagnotic]];
        
        complete(YES, result, @"");
    } failure:^(NSInteger errCode, NSString *errMsg, NSDictionary *userInfo) {
        complete(NO, userInfo,errMsg);
    }];
}

- (void)loadRequestProperties
{
    [self.request cancelRequest];
    
    self.request.type    = DCHttpRequestTypePOST;
    self.request.baseUrl = BASE_URL;
    self.request.method  = @"linktop/u/save";
    self.request.params  = params;
    
    self.request.allowsLogMethod       = kLogEnabled;
    self.request.allowsLogHeader       = kHttpRequestAllowsLogHeader;
    self.request.allowsLogResponseGET  = kHttpRequestAllowsLogResponseGET;
    self.request.allowsLogResponsePOST = kHttpRequestAllowsLogResponsePOST;
    self.request.allowsLogRequestError = kHttpRequestAllowsLogRequestError;
    
    Patient *user = [LoginManager defaultManager].currentPatient;
    
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

- (void)deleteCurrentPatientFromMainDB:(Patient *)patient {
    patient.isLastAdd = NO;
    [self.mainDatabase updateObjects:@[patient]];
}

- (DiagnosticList *)getNewestRothmanIndexInfo {
    NSString *sql = [NSString stringWithFormat:
                     @"SELECT * FROM %@ where type = ? ORDER BY create_date DESC",
                     [DiagnosticList tableName]];
    
    NSArray *result = [self.mainDatabase query:sql withArguments:@[@(MTRothmanIndex)] convertTo:[DiagnosticList class]];
    
    return result.firstObject;
}

- (DCDatabase *)mainDatabase {
    return [self database:@"main.db" withKey:@"1234567890ABCDEF"];
}

@end
