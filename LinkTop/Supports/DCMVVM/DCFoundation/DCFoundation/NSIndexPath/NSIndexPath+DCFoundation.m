
#import "NSIndexPath+DCFoundation.h"

@implementation NSIndexPath (DCFoundation)

+ (NSIndexPath *)firstRow {
  return [NSIndexPath indexPathForRow:0 inSection:0];
}

+ (NSIndexPath *)firstItem {
  return [NSIndexPath indexPathForItem:0 inSection:0];
}

@end
