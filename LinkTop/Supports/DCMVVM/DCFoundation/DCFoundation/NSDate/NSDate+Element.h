
#import <Foundation/Foundation.h>

typedef struct NSDateElement {
  NSInteger year;
  NSInteger month;  // [1, 12]
  NSInteger day;    // [1, daysOfMonth:year:]
  NSInteger hour;   // [0, 24]
  NSInteger minute; // [0, 60]
  NSInteger second; // [0, 60]
} NSDateElement;

@interface NSDate (Element)

/*!
 *  @brief  验证 NSDateElement 合法性
 */
+ (BOOL)validateDateElement:(NSDateElement)e;

/*!
 *  @brief  使用 NSDateElement 实例化 NSDate
 */
+ (NSDate *)dateWithElement:(NSDateElement)e;

/*!
 *  @brief  返回当前日期的 NSDateElement 对象
 */
- (NSDateElement)element;

@end
