//
//  TimeInterval2DateString.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/5.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "TimeInterval2DateString.h"

@implementation TimeInterval2DateString

+ (NSString *)TimeIntervalToDateString:(long long)time {
    // 时间
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

@end
