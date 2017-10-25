
#import "NSMutableString+DCFoundation.h"

@implementation NSMutableString (DCFoundation)

- (void)deleteLastCharacter
{
  NSInteger length = self.length;
  if (length > 0) {
    [self deleteCharactersInRange:NSMakeRange(length - 1, 1)];
  }
}

@end
