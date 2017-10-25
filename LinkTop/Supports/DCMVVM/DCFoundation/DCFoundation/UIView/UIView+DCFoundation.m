
#import "UIView+DCFoundation.h"

@implementation UIView (DCFoundation)

- (void)removeSubviews
{
  NSArray *subviews = self.subviews;
  
  for (UIView *subview in subviews) {
    [subview removeFromSuperview];
  }
}

- (void)setVisible:(BOOL)visible
{
  self.hidden = !visible;

}

- (BOOL)isVisible
{
  return !self.hidden;
}

@end
