
#import <Foundation/Foundation.h>

@interface NSDateComponents (DCFoundation)

/*!
 *  @brief  返回指定日期的 NSDateComponents 对象
 *
 *  @return 单位包括：
 *          Era, Year, Month, Day, Hour, Minute, Second,
 *          Weekday, WeekdayOrdinal, WeekOfMonth, WeekOfYear
 */
+ (NSDateComponents *)componentsFromDate:(NSDate *)date;

/*!
 *  @brief  返回当前时间的 NSDateComponents 对象
 *
 *  @return 单位包括：
 *          Era, Year, Month, Day, Hour, Minute, Second,
 *          Weekday, WeekdayOrdinal, WeekOfMonth, WeekOfYear
 */
+ (NSDateComponents *)currentComponents;

@end
