
#import "UIView+FrameShortcuts.h"

@implementation UIView (FrameShortcuts)

- (CGFloat)x {
  return CGRectGetMinX(self.frame);
}

- (CGFloat)y {
  return CGRectGetMinY(self.frame);
}

- (CGFloat)width {
  return CGRectGetWidth(self.frame);
}

- (CGFloat)height {
  return CGRectGetHeight(self.frame);
}


- (void)setX:(CGFloat)x {
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}

- (void)setY:(CGFloat)y {
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}


@end
