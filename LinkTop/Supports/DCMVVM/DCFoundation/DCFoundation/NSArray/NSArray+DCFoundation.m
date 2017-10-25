
#import "NSArray+DCFoundation.h"
#import "NSMutableArray+DCFoundation.h"

@implementation NSArray (DCFoundation)

- (NSArray *)reversedArray
{
  NSMutableArray *array = [NSMutableArray arrayWithArray:self];
  
  [array reverse];
  
  return [NSArray arrayWithArray:array];
}

@end
