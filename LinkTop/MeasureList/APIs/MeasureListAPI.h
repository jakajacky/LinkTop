//
//  MeasureListAPI.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/2.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "DCBiz.h"
#import "CommonEntities.h"
@interface MeasureListAPI : DCBiz

- (void)downloadRecentData:(NSDictionary *)param completion:(void(^)(BOOL,id,NSString *))complete;

@end
