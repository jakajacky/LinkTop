//
//  MeasureListAPI.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/2.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "MeasureListAPI.h"
#import "DCHttpRequest.h"

@interface MeasureListAPI ()
{
    NSDictionary *params;
}
@property (nonatomic, strong) DCHttpRequest *request;
@property (nonatomic, strong) DCDatabase *mainDatabase;

@end

@implementation MeasureListAPI


- (void)downloadRecentData:(NSDictionary *)param completion:(void(^)(BOOL,id,NSString *))complete {
    params = param;
    [self loadRequestProperties];
    
    [self.request startWithSuccess:^(id result) {
        
//        DiagnosticList *diagnotic = [[DiagnosticList alloc] initWithDictionary:result];
//        diagnotic.Id = result[@"id"];
//        diagnotic.spo2h_raw = params[@"spo2h_raw"];
//        diagnotic.ecg_raw   = params[@"ecg_raw"];
//        diagnotic.isSent = YES;
//        diagnotic.type = type;
        // 存储数据库
//        [self.mainDatabase updateObjects:@[diagnotic]];
        NSMutableArray *datas = [NSMutableArray array];
        for (NSDictionary *dic in result[@"list"]) {
            DiagnosticList *diagnotic = [[DiagnosticList alloc] initWithDictionary:dic];
            BOOL isSpo2h = [dic.allKeys containsObject:@"spo2h"];
            BOOL isRespi = [dic.allKeys containsObject:@"respiration"];
            BOOL isTemp  = [dic.allKeys containsObject:@"temp"];
            BOOL isSbp = [dic.allKeys containsObject:@"sbp"];
            BOOL isHr = [dic.allKeys containsObject:@"hr"];
            if (isSpo2h && isRespi && isTemp && isSbp && isHr) { // Rothman
                diagnotic.Id = dic[@"id"];
                diagnotic.isSent = YES;
                diagnotic.type = MTRothmanIndex;
            }
            else if (isSpo2h) { // 血氧
                
                diagnotic.Id = dic[@"id"];
                diagnotic.isSent = YES;
                diagnotic.type = MTSpo2h;
            }
            else if (isRespi) { // ECG
                
                diagnotic.Id = dic[@"id"];
                diagnotic.isSent = YES;
                diagnotic.type = MTECG;
            }
            else if (isTemp) { // 体温
                
                diagnotic.Id = dic[@"id"];
                diagnotic.isSent = YES;
                diagnotic.type = MTTemperature;
            }
            else if (isSbp) { // 血压
                
                diagnotic.Id = dic[@"id"];
                diagnotic.isSent = YES;
                diagnotic.type = MTBloodPresure;
            }
            else if (isHr) {  // 心率
                
                diagnotic.Id = dic[@"id"];
                diagnotic.isSent = YES;
                diagnotic.type = MTHeartRate;
            }
            [datas addObject:diagnotic];
        }
        NSLog(@"download result:%@",result);
        complete(YES, datas, @"");
    } failure:^(NSInteger errCode, NSString *errMsg, NSDictionary *userInfo) {
        complete(NO, userInfo,errMsg);
    }];
}

- (void)loadRequestProperties
{
    [self.request cancelRequest];
    
    self.request.type    = DCHttpRequestTypePOST;
    self.request.baseUrl = BASE_URL;
    self.request.method  = @"linktop/recentData";
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


#pragma mark - database operations
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
