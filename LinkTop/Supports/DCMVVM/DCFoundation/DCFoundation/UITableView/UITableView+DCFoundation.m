
#import "UITableView+DCFoundation.h"

@implementation UITableView (DCFoundation)

- (void)selectFirstRow
{
  [self selectRow:0 inSection:0 animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)selectRow:(NSInteger)row
{
  [self selectRow:row inSection:0 animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)selectRow:(NSInteger)row inSection:(NSInteger)section
{
  [self selectRow:row inSection:section animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)selectRow:(NSInteger)row
        inSection:(NSInteger)section
         animated:(BOOL)animated
   scrollPosition:(UITableViewScrollPosition)scrollPosition
{
  if ([self numberOfSections] > section && [self numberOfRowsInSection:section] > row) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
  }
}

- (void)deselectRows
{
  NSArray *indexPaths = [self indexPathsForSelectedRows];
  for (NSIndexPath *indexPath in indexPaths) {
    [self deselectRowAtIndexPath:indexPath animated:NO];
  }
}

@end
