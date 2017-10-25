
#import "NSDate+DCFoundation.h"

#import "NSDate+Element.h"
#import "NSDateComponents+DCFoundation.h"
#import "NSDateFormatCategory.h"

@implementation NSDate (Utilities)

- (long long)milliseconds
{
  return [self timeIntervalSince1970] * 1000;
}

+ (long long)millisecondsSince1970
{
  return [Now() timeIntervalSince1970] * 1000;
}

+ (long long)millisecondsWithDate:(NSDate *)date
{
  return [date timeIntervalSince1970] * 1000;
}

+ (NSDate *)dateWithMilliseconds:(long long)milliseconds
{
  return [NSDate dateWithTimeIntervalSince1970:milliseconds / 1000];
}

- (BOOL)isSameDayWithDate:(NSDate *)otherDate
{
  if (!otherDate) {
    return NO;
  }
  
  NSDateComponents *otherComponents = [NSDateComponents componentsFromDate:otherDate];
  NSDateComponents *components      = [NSDateComponents componentsFromDate:self];

  return (components.year  == otherComponents.year  &&
          components.month == otherComponents.month &&
          components.day   == otherComponents.day);
}

- (BOOL)isToday
{
  return [self isSameDayWithDate:Now()];
}

- (BOOL)isThisWeek
{
  NSDateComponents *nowComponents = [NSDateComponents currentComponents];
  NSDateComponents *components    = [NSDateComponents componentsFromDate:self];
  
  return nowComponents.year       == components.year       &&
         nowComponents.weekOfYear == components.weekOfYear;
}

- (BOOL)isThisMonth
{
  NSDateComponents *nowComponents = [NSDateComponents currentComponents];
  NSDateComponents *components    = [NSDateComponents componentsFromDate:self];
  
  return nowComponents.year  == components.year  &&
         nowComponents.month == components.month;
}

- (NSString *)dayOfWeekInChinese
{
  NSString *str[] = {
    @"星期日",
    @"星期一",
    @"星期二",
    @"星期三",
    @"星期四",
    @"星期五",
    @"星期六",
  };
  NSInteger i = [[self stringWithFormat:NSDateFormatDayOfWeek] intValue];
  return str[i - 1];
}

- (BOOL)isExpired
{
  return [self milliseconds] < [Now() milliseconds];
}

+ (NSDate *)firstDayOfMonth
{
  NSDateComponents *components = [NSDateComponents currentComponents];
  
  NSInteger y = components.year;
  NSInteger m = components.month;
  NSInteger d = 1;
  
  NSString *string = [NSString stringWithFormat:@"%zd-%02zd-%02zd", y, m, d];
  return [string dateWithFormat:NSDateFormatYearMonthDay];
}

+ (NSDate *)lastDayOfMonth
{
  NSDateComponents *components = [NSDateComponents currentComponents];
  
  NSInteger y = components.year;
  NSInteger m = components.month;
  NSInteger d = [self daysOfMonth:m year:y];
  
  NSString *string = [NSString stringWithFormat:@"%zd-%02zd-%02zd", y, m, d];
  return [string dateWithFormat:NSDateFormatYearMonthDay];
}

+ (NSDate *)firstDayOfWeek
{
  NSDateComponents *components = [NSDateComponents currentComponents];
  
  NSInteger w = components.weekday;
  
  long long firstDayOfWeekMillsecond = [Now() millisecondsAtHour:0] - MSECONDS_PER_DAY * (w - 1);
  
  return [NSDate dateWithMilliseconds:firstDayOfWeekMillsecond];
}

+ (NSDate *)lastDayOfWeek
{
  NSDateComponents *components = [NSDateComponents currentComponents];
  
  NSInteger w = components.weekday;
  
  long long lastDayOfWeekMillsecond = [Now() millisecondsAtHour:0] + MSECONDS_PER_DAY * (7 - w);
  
  return [NSDate dateWithMilliseconds:lastDayOfWeekMillsecond];
}

+ (NSDate *)today
{
  NSTimeInterval timeInterval = [Now() timeIntervalAtHour:0];

  return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

- (NSTimeInterval)timeIntervalAtHour:(NSInteger)hour
{
  NSCalendar       *calendar   = [NSCalendar currentCalendar];
  NSDateComponents *components = [NSDateComponents componentsFromDate:self];
  
  [components setHour:hour];
  [components setMinute:0];
  [components setSecond:0];
  
  NSDate *date = [calendar dateFromComponents:components];
  return [date timeIntervalSince1970];
}

- (long long)millisecondsAtHour:(NSInteger)hour
{
  return [self timeIntervalAtHour:hour] * 1000;
}

- (NSInteger)year
{
  return self.element.year;
}

- (NSInteger)month
{
  return self.element.month;
}

- (NSInteger)day
{
  return self.element.day;
}

- (NSInteger)nextYear
{
  return self.year + 1;
}

- (NSInteger)nextMonth
{
  NSInteger month = self.month;
  
  if (month == 12) {
    return 1;
  }
  
  return month + 1;
}

- (NSInteger)yearForNextMonth
{
  NSInteger month = self.month;
  
  if (month == 12) {
    return self.year + 1;
  }
  
  return self.year;
}

+ (NSInteger)monthOfString:(NSString *)str
{
  if ([str length] < 3) {
    return 0;
  }
  NSString *str3 = [[str substringToIndex:3] lowercaseString];

  NSArray *monthStrList = @[@"jan", @"feb", @"mar", @"apr", @"may", @"jun",
                            @"jul", @"aug", @"sep", @"oct", @"nov", @"dec"];

  NSInteger index = [monthStrList indexOfObject:str3];
  if (0 <= index &&  index < monthStrList.count) {
    return index + 1;
  }
  return 0;
}

+ (NSString *)stringOfMonth:(NSInteger)month
{
  NSString *str = nil;
  
  switch (month) {
    case 1:str = @"Jan.";break;
    case 2:str = @"Feb.";break;
    case 3:str = @"Mar.";break;
    case 4:str = @"Apr.";break;
    case 5:str = @"May.";break;
    case 6:str = @"Jun.";break;
    case 7:str = @"Jul.";break;
    case 8:str = @"Aug.";break;
    case 9:str = @"Sep.";break;
    case 10:str = @"Oct.";break;
    case 11:str = @"Nov.";break;
    case 12:str = @"Dec.";break;
    default:break;
  }
  
  return str;
}

+ (NSString *)fullStringOfMonth:(NSInteger)month
{
  NSString *str = nil;
  
  switch (month) {
    case 1:str = @"January";break;
    case 2:str = @"February";break;
    case 3:str = @"March";break;
    case 4:str = @"April";break;
    case 5:str = @"May";break;
    case 6:str = @"June";break;
    case 7:str = @"July";break;
    case 8:str = @"August";break;
    case 9:str = @"September";break;
    case 10:str = @"October";break;
    case 11:str = @"November";break;
    case 12:str = @"December";break;
    default:break;
  }
  
  return str;
}

+ (NSInteger)daysOfMonth:(NSInteger)month year:(NSInteger)year
{
  if (month == 4 || month == 6 || month == 9 || month == 11) {
    return 30;
  }
  else if (month == 2) {
    return [self isLeapYear:year] ? 29 : 28;
  }
  
  return 31;
}

+ (BOOL)isLeapYear:(NSInteger)year
{
  return year % 100 == 0 ? year % 400 == 0 : year % 4 == 0;
}

- (BOOL)isAM
{
  return [self element].hour < MIDDAY_HOUR;
}

- (BOOL)isPM
{
  return [self element].hour >= MIDDAY_HOUR;
}

@end
