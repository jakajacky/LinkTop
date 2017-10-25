
#import "UICollectionView+DCFoundation.h"

@implementation UICollectionView (DCFoundation)

- (void)reloadSection:(NSInteger)section
{
  NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
  [self reloadSections:indexSet];
}

@end
