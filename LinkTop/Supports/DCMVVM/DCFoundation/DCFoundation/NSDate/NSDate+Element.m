
#import "NSDate+Element.h"

#import "NSDate+DCFoundation.h"
#import "NSDateFormatCategory.h"

#import "DCInlines.h"

@implementation NSDate (Element)

+ (BOOL)validateDateElement:(NSDateElement)e
{
  return (
          e.year > 0
          && NSIntegerIsInRange(e.month,  NSMakeRangeV2(1, 12))
          && NSIntegerIsInRange(e.day,    NSMakeRangeV2(1, [self daysOfMonth:e.month year:e.year]))
          && NSIntegerIsInRange(e.hour,   NSMakeRangeV2(0, 24))
          && NSIntegerIsInRange(e.minute, NSMakeRangeV2(0, 60))
          && NSIntegerIsInRange(e.second, NSMakeRangeV2(0, 60))
          );
}

+ (NSDate *)dateWithElement:(NSDateElement)e
{
  NSDate *date = nil;
  
  if ([self validateDateElement:e]) {
    NSString *str = [NSString stringWithFormat:
                         @"%04zd-%02zd-%02zd %02zd:%02zd:%02zd",
                         e.year, e.month, e.day, e.hour, e.minute, e.second];
    return [str dateWithFormat:NSDateFormatFull];
  }
  
  return date;
}

- (NSDateElement)element
{
  NSString *str = [self stringWithFormat:NSDateFormatFull];

  NSArray *arr     = [str    componentsSeparatedByString:@" "];
  NSArray *dateArr = [arr[0] componentsSeparatedByString:@"-"];
  NSArray *timeArr = [arr[1] componentsSeparatedByString:@":"];
  
  NSDateElement e = {
    [dateArr[0] integerValue],
    [dateArr[1] integerValue],
    [dateArr[2] integerValue],
    [timeArr[0] integerValue],
    [timeArr[1] integerValue],
    [timeArr[2] integerValue]
  };
  
  return e;
}

@end
