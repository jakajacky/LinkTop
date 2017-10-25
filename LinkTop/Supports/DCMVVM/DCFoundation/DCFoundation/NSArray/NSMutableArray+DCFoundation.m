
#import "NSMutableArray+DCFoundation.h"

@implementation NSMutableArray (DCFoundation)

- (void)reverse
{
  for (int i = 0; i < [self count] / 2; i++) {
    NSInteger j = [self count] - 1 - i;
    id iObj = self[i];
    id jObj = self[j];
    [self replaceObjectAtIndex:i withObject:jObj];
    [self replaceObjectAtIndex:j withObject:iObj];
  }
}

@end
