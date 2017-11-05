//
//  MeasureAPI.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "DCBiz.h"
#import "CommonEntities.h"
@interface MeasureAPI : DCBiz

- (void)uploadResult:(NSDictionary *)result type:(MeasureType)type completion:(void(^)(BOOL,id,NSString *))complete;
- (void)downloadResultWithUserId:(NSString *)user_id recordId:(NSString *)Id completion:(void(^)(BOOL,id,NSString *))complete;

- (DiagnosticList *)getNewestRothmanIndexInfo;
@end
