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


- (void)uploadResult:(NSDictionary *)result type:(MeasureType)type completion:(void(^)(BOOL,id,NSString *))complete {
//    params = @{@"user_id" : user.Id,  // 用户名
//               @"sbp"     : @"L",     // 收缩压
//               @"dbp"     : @"L",     // 舒张压
//               @"spo2h"   : @"1.0",   // 血氧
//               @"temp"    : @"",      // 体温
//               @"hr"      : @1,       // 心率
//               @"respiration" : @"iPad",         // 呼吸率
//               @"device_id"   : @"c4ff2322",     // 设备id
//               @"ecg_raw"     : @"233,334,4322", // 心电原始数据
//               @"ecg_freq"    : @122,            // 心电采样率
//               @"spo2h_raw"   : @"34,22,65",     // 血氧原始数据
//               @"spo2h_freq"  : @125,            // 血氧采样率
//               @"rr"          : @1,  // 心率
//               @"rr_max"      : @1,  // 最大值
//               @"rr_min"      : @1,  // 最小值
//               @"mood"        : @1,   // 心情
//               @"hrv"         : @1,  // 变异率
//               @"device_power" : @122, // 电量
//               @"device_key"   : @"c4f4432", // 设备key
//               @"device_soft_ver" : @"v1.2", // 软件版本
//               @"device_hard_ver" : @"v1.2", // 硬件版本
//               };  // 血氧采样率
    params = result;
    [self loadRequestProperties];
    
    [self.request startWithSuccess:^(id result) {
        
        DiagnosticList *diagnotic = [[DiagnosticList alloc] initWithDictionary:result];
        diagnotic.Id = result[@"id"];
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

- (DCDatabase *)mainDatabase {
    return [self database:@"main.db" withKey:@"1234567890ABCDEF"];
}

@end
