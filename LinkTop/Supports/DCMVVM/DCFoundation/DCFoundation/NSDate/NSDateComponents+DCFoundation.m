
#import "NSDateComponents+DCFoundation.h"

@implementation NSDateComponents (DCFoundation)

+ (NSDateComponents *)componentsFromDate:(NSDate *)date
{
  NSCalendarUnit unit  = NSCalendarUnitEra               |
                         NSCalendarUnitYear              |
                         NSCalendarUnitMonth             |
                         NSCalendarUnitDay               |
                         NSCalendarUnitHour              |
                         NSCalendarUnitMinute            |
                         NSCalendarUnitSecond            |
                         NSCalendarUnitWeekday           |
                         NSCalendarUnitWeekdayOrdinal    |
                         NSCalendarUnitWeekOfMonth       |
                         NSCalendarUnitWeekOfYear;
  
  NSCalendar *calendar = [NSCalendar currentCalendar];

  return [calendar components:unit fromDate:date];
}

+ (NSDateComponents *)currentComponents
{
  return [self componentsFromDate:[NSDate date]];
}

@end
