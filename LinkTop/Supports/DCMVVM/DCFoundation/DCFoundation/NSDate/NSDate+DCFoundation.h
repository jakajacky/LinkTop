
#import <Foundation/Foundation.h>

#define MSECONDS_PER_DAY  86400000
#define SECONDS_PER_DAY   86400

#define MSECONDS_PER_HOUR 3600000
#define SECONDS_PER_HOUR  3600

#define MSECONDS_PER_MINITE 60000
#define SECONDS_PER_MINITE  60

#define HOURS_PER_DAY 24
#define MIDDAY_HOUR   12

/*!
 *  @brief  当前时间
 */
NS_INLINE NSDate* Now() {
  return [NSDate date];
}

@interface NSDate (DCFoundation)

/*!
 *  @brief  毫秒值
 *
 *  @return 13 位毫秒值
 */
- (long long)milliseconds;

/*!
 *  @brief  使用毫秒值实例化 NSDate
 *
 *  @param milliseconds 13 位毫秒值
 */
+ (NSDate *)dateWithMilliseconds:(long long )milliseconds;

/*!
 *  @brief  返回当前日期与指定日期是否为同一天
 *
 *  @param otherDate 指定的日期
 * 
 *  @discussion  精度单位：天，不比较小时及比其更小的单位。
 *               即（2015-01-01 12:00 与 2015-01-01 18:30 比较，结果为 YES)
 */
- (BOOL)isSameDayWithDate:(NSDate *)otherDate;

/*!
 *  @brief  返回当前日期是否为今天
 */
- (BOOL)isToday;

/*!
 *  @brief  返回当前日期是否为本周
 */
- (BOOL)isThisWeek;

/*!
 *  @brief  返回当前日期是否为本月
 */
- (BOOL)isThisMonth;

/*!
 *  @brief  返回中文的星期字符串
 *
 *  @return @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六",
 */
- (NSString *)dayOfWeekInChinese;

/*!
 *  @brief  返回当前日期是否早于现在的时间
 */
- (BOOL)isExpired;

/*!
 *  @brief  返回本月第一天零点的日期
 */
+ (NSDate *)firstDayOfMonth;

/*!
 *  @brief  返回本月最后一天零点的日期
 */
+ (NSDate *)lastDayOfMonth;

/*!
 *  @brief  返回本周第一天零点的日期
 */
+ (NSDate *)firstDayOfWeek;

/*!
 *  @brief  返回本周最后一天零点的日期
 */
+ (NSDate *)lastDayOfWeek;

/*!
 *  @brief  返回今天零点的日期
 */
+ (NSDate *)today;

/*!
 *  @brief  返回当前日期指定整点时间的毫秒值
 *
 *  @return 13 位毫秒值
 */
- (long long)millisecondsAtHour:(NSInteger)hour;

/*!
 *  @brief  返回年份
 */
- (NSInteger)year;

/*!
 *  @brief  返回月份
 */
- (NSInteger)month;

/*!
 *  @brief  返回日期
 */
- (NSInteger)day;

/*!
 *  @brief  返回当前日期下一年的年份
 */
- (NSInteger)nextYear;

/*!
 *  @brief  返回当前日期下一个月的月份
 *
 *  @return 如果当前日期为 12 月，则返回 1 月
 */
- (NSInteger)nextMonth;

/*!
 *  @brief  返回单期日期下一个月的年份
 *
 *  @return 如果当前日期为 12 月，则返回下一年的年份
 */
- (NSInteger)yearForNextMonth;

/*!
 *  @brief  将英文月份转换为月份数字
 *
 *  @return 1月份返回1，2月份返回2...如果传入无效参数，则返回0
 */
+ (NSInteger)monthOfString:(NSString *)str;

/*!
 *  @brief  将月份数字转换为英文缩写
 *
 *  @param month 取值范围 [1, 12]
 */
+ (NSString *)stringOfMonth:(NSInteger)month;

/*!
 *  @brief  将月份数字转换为英文全称
 *
 *  @param month 取值范围 [1, 12]
 */
+ (NSString *)fullStringOfMonth:(NSInteger)month;

/*!
 *  @brief  返回指定年、月中包含的天数
 *
 *  @return 闰年 2 月返回 29 天
 */
+ (NSInteger)daysOfMonth:(NSInteger)month year:(NSInteger)year;

/*!
 *  @brief  返回指定年份是否为闰年
 */
+ (BOOL)isLeapYear:(NSInteger)year;

/*!
 *  @brief  返回当前日期是否为上午
 */
- (BOOL)isAM;

/*!
 *  @brief  返回当前日期是否为下午
 */
- (BOOL)isPM;

@end

/*!
 *  @brief  返回指定毫秒值是否为上午
 */
NS_INLINE BOOL MillisecondsIsAM(long long ms)
{
  return [[NSDate dateWithMilliseconds:ms] isAM];
}

/*!
 *  @brief  返回指定毫秒值是否为下午
 */
NS_INLINE BOOL MillisecondsIsPM(long long ms)
{
  return [[NSDate dateWithMilliseconds:ms] isPM];
}
