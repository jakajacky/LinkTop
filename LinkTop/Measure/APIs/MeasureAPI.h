//
//  MeasureAPI.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "DCBiz.h"

typedef enum : NSUInteger {
    MTBloodPresure,
    MTTemperature,
    MTSpo2h,
    MTHeartRate,
} MeasureType;

@interface MeasureAPI : DCBiz

- (void)uploadResult:(NSDictionary *)result type:(MeasureType)type completion:(void(^)(BOOL,id,NSString *))complete;

@end
