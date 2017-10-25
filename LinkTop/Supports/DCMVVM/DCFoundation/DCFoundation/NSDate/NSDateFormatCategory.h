
#import <Foundation/Foundation.h>

/*!
 *  @brief  日期 - 字符串 转换格式
 */
typedef NS_ENUM(NSInteger, NSDateFormat) {
  /**
   *  @brief  Example: 2012-11-30 18:30:59
   */
  NSDateFormatFull,
  
  /**
   *  @brief  Example: 2012
   */
  NSDateFormatYear,
  
  /**
   *  @brief  Example: 11
   */
  NSDateFormatMonth,
  
  /**
   *  @brief  Example: 30
   */
  NSDateFormatDay,
  
  /**
   *  @brief  Example: 2012.11.30
   */
  NSDateFormatYearMonthDayPoint,
  
  /**
   *  @brief  Example: 2012-11-30
   */
  NSDateFormatYearMonthDay,
  
  /**
   *  @brief  Example: 2012-11
   */
  NSDateFormatYearMonth,
  
  /**
   *  @brief  Example: 11-30
   */
  NSDateFormatMonthDay,
  
  /**
   *  @brief  Example: 18
   */
  NSDateFormatHour,
  
  /**
   *  @brief  Example: 30
   */
  NSDateFormatMinute,
  
  /**
   *  @brief  Example: 59
   */
  NSDateFormatSecond,
  
  /**
   *  @brief  Example: 18:30:59
   */
  NSDateFormatHourMinuteSecond,
  
  /**
   *  @brief  Example: 18:30
   */
  NSDateFormatHourMinute,

  /**
   *  @brief  Example: 30:59
   */
  NSDateFormatMinuteSecond,
  
  /**
   *  @brief  Example: 11-30 18:30
   */
  NSDateFormatMonthDayHourMinute,
  
  /**
   *  @brief  Example: 1~7 (1为星期日)
   */
  NSDateFormatDayOfWeek,
  
  /**
   *  @brief  Example: Jan
   */
  NSDateFormatMonth_English,
  
  /**
   *  @brief  Example: 2012年11月30日
   */
  NSDateFormatYearMonthDay_Chinese,
  
  /**
   *  @brief  Example: 2012年11月
   */
  NSDateFormatYearMonth_Chinese,
  
  /**
   *  @brief  Example: 11月30日
   */
  NSDateFormatMonthDay_Chinese,
  
  /**
   *  @brief  Example: 2012年11月30日 下午
   */
  NSDateFormatYearMonthDayAMPM_Chinese,
  
  /**
   *  @brief  Example: 上午 或 下午
   */
  NSDateFormatAMPM
};

@interface NSDate (DateFormat)

/*!
 *  @brief  将日期转换为指定格式的字符串
 *  @see    NSDateFormat
 */
- (NSString *)stringWithFormat:(NSDateFormat)format;

@end

@interface NSString (DateFormat)

/*!
 *  @brief  将字符串转换为指定格式的日期
 *  @see    NSDateFormat
 */
- (NSDate *)dateWithFormat:(NSDateFormat)format;

@end
