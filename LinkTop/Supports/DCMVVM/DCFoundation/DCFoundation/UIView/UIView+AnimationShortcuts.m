
#import "UIView+AnimationShortcuts.h"
#import "UIView+FrameShortcuts.h"

#define kUIViewMoveAnimationDuration        0.4
#define kUIViewFadeAnimationDuration        0.5

UIImage * DCFDT_SnapshotView(UIView *view)
{
  UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

@implementation UIView (AnimationShortcuts)

- (void)moveX:(CGFloat)x
{
  self.x += x;
}

- (void)moveY:(CGFloat)y
{
  self.y += y;
}

- (void)moveX:(CGFloat)x completion:(void (^)())completion
{
  [UIView animateWithDuration:kUIViewMoveAnimationDuration
                   animations:^{
                     self.x += x;
                   }
                   completion:^(BOOL finished) {
                     if (completion) {
                       completion();
                     }
                   }];
}

- (void)moveY:(CGFloat)y completion:(void (^)())completion
{
  [UIView animateWithDuration:kUIViewMoveAnimationDuration
                   animations:^{
                     self.y += y;
                   }
                   completion:^(BOOL finished) {
                     if (completion) {
                       completion();
                     }
                   }];
}

- (void)setX:(CGFloat)x completion:(void (^)())completion
{
  [UIView animateWithDuration:kUIViewMoveAnimationDuration
                   animations:^{
                     self.x = x;
                   }
                   completion:^(BOOL finished) {
                     if (completion) {
                       completion();
                     }
                   }];
}

- (void)setY:(CGFloat)y completion:(void (^)())completion
{
  [UIView animateWithDuration:kUIViewMoveAnimationDuration
                   animations:^{
                     self.y = y;;
                   }
                   completion:^(BOOL finished) {
                     if (completion) {
                       completion();
                     }
                   }];
}

- (void)fadeout:(void (^)())completion {
  [UIView animateWithDuration:kUIViewFadeAnimationDuration
                   animations:^{
                     self.alpha = 0.0;
                   }
                   completion:^(BOOL finished) {
                     if (completion != nil) {
                       completion();
                     }
                   }];
}

- (void)fadein:(void (^)())completion {
  [UIView animateWithDuration:kUIViewFadeAnimationDuration
                   animations:^{
                     self.alpha = 1.0;
                   }
                   completion:^(BOOL finished) {
                     if (completion != nil) {
                       completion();
                     }
                   }];
}

- (void)changeFrameTo:(CGRect)frame completion:(void (^)())completion
{
  [UIView animateWithDuration:kUIViewMoveAnimationDuration
                   animations:^{
                     self.frame = frame;
                   }
                   completion:^(BOOL finished) {
                     completion();
                   }];
}

- (void)reloadWithAnimationDirection:(UIViewReloadAnimationDirection)animationDirection
                     reloadDataBlock:(void (^)())reloadDataBlock
                          completion:(void (^)())completion
{
  UIView *superview = self.superview;
  
  UIView *baseView = [[UIView alloc] initWithFrame:self.frame];
  baseView.clipsToBounds = YES;
  baseView.backgroundColor = [UIColor clearColor];
  [superview addSubview:baseView];
  
  BOOL animated = YES;
  CGRect frame = self.bounds;
  CGFloat x = 0, y = 1;
  
  switch (animationDirection) {
    case UIViewReloadAnimationDirectionTop:
      y = -frame.size.height;
      break;
    case UIViewReloadAnimationDirectionBottom:
      y = frame.size.height;
      break;
    case UIViewReloadAnimationDirectionLeft:
      x = -frame.size.width;
      break;
    case UIViewReloadAnimationDirectionRight:
      x = frame.size.width;
      break;
    default:
      animated = NO;
      break;
  }
  
  frame.origin.x += x;
  frame.origin.y += y;
  
  UIImageView *leavingMirror = nil, *commingMirror = nil;
  if (animated) {
    leavingMirror = [[UIImageView alloc] initWithImage:DCFDT_SnapshotView(self)];
    [baseView addSubview:leavingMirror];
  }
  
  reloadDataBlock();
  
  if (animated) {
    commingMirror = [[UIImageView alloc] initWithImage:DCFDT_SnapshotView(self)];
    commingMirror.frame = frame;
    [baseView addSubview:commingMirror];
    
    [self removeFromSuperview];
  }
  
  switch (animationDirection) {
    case UIViewReloadAnimationDirectionTop:
    case UIViewReloadAnimationDirectionBottom:
    {
      [leavingMirror moveY:-y
                completion:^{
                  [leavingMirror removeFromSuperview];
                }];
      
      [commingMirror moveY:-y
                completion:^{
                  [commingMirror removeFromSuperview];
                  [baseView removeFromSuperview];
                  [superview addSubview:self];
                  completion();
                }];
    }
      break;
    case UIViewReloadAnimationDirectionLeft:
    case UIViewReloadAnimationDirectionRight:
    {
      [leavingMirror moveX:-x
                completion:^{
                  [leavingMirror removeFromSuperview];
                }];
      
      [commingMirror moveX:-x
                completion:^{
                  [commingMirror removeFromSuperview];
                  [baseView removeFromSuperview];
                  [superview addSubview:self];
                  completion();
                }];
      
    }
      break;
    default:
      [baseView removeFromSuperview];
      completion();
      break;
  }
}

- (void)reloadWithAnimationDirection:(UIViewReloadAnimationDirection)animationDirection
                              offset:(CGFloat)offset
                     reloadDataBlock:(void (^)())reloadDataBlock
                          completion:(void (^)())completion
{
  UIView *superView = self.superview;
  
  UIView *baseView = [[UIView alloc] initWithFrame:self.frame];
  baseView.backgroundColor = [UIColor clearColor];
  [superView addSubview:baseView];
  
  BOOL animated = YES;
  CGRect frame = self.bounds;
  CGFloat x = 0, y = 0;
  
  CGFloat absOffset = fabs(offset);
  
  switch (animationDirection) {
    case UIViewReloadAnimationDirectionTop:
      y = -absOffset;
      break;
    case UIViewReloadAnimationDirectionBottom:
      y = absOffset;
      break;
    case UIViewReloadAnimationDirectionLeft:
      x = -absOffset;
      break;
    case UIViewReloadAnimationDirectionRight:
      x = absOffset;
      break;
    default:
      animated = NO;
      break;
  }
  
  frame.origin.x += x;
  frame.origin.y += y;
  
  UIImageView *leavingMirror = nil, *commingMirror = nil;
  if (animated) {
    leavingMirror = [[UIImageView alloc] initWithImage:DCFDT_SnapshotView(self)];
    [baseView addSubview:leavingMirror];
  }
  
  reloadDataBlock();
  
  if (animated) {
    commingMirror = [[UIImageView alloc] initWithImage:DCFDT_SnapshotView(self)];
    commingMirror.frame = frame;
    [baseView addSubview:commingMirror];
    
    [self removeFromSuperview];
  }
  
  switch (animationDirection) {
    case UIViewReloadAnimationDirectionTop:
    case UIViewReloadAnimationDirectionBottom:
    {
      [leavingMirror moveY:-y completion:^{
        [leavingMirror removeFromSuperview];
      }];
      
      [commingMirror moveY:-y completion:^{
        [commingMirror removeFromSuperview];
        [baseView removeFromSuperview];
        [superView addSubview:self];
        completion();
      }];
    }
      break;
    case UIViewReloadAnimationDirectionLeft:
    case UIViewReloadAnimationDirectionRight:
    {
      [leavingMirror moveX:-x completion:^{
        [leavingMirror removeFromSuperview];
      }];
      
      [commingMirror moveX:-x completion:^{
        [commingMirror removeFromSuperview];
        [baseView removeFromSuperview];
        [superView addSubview:self];
        completion();
      }];
    }
      break;
    default:
      [baseView removeFromSuperview];
      completion();
      break;
  }
}

- (void)reloadWithX:(CGFloat)x
    reloadDataBlock:(void (^)())reloadDataBlock
         completion:(void (^)())completion
{
  UIView *superview = self.superview;
  
  UIView *baseView = [[UIView alloc] initWithFrame:self.frame];
  baseView.clipsToBounds = YES;
  baseView.backgroundColor = [UIColor clearColor];
  [superview addSubview:baseView];
  
  UIImageView *leavingMirror = [[UIImageView alloc] initWithImage:DCFDT_SnapshotView(self)];
  [baseView addSubview:leavingMirror];
  
  reloadDataBlock();
  
  UIImageView *commingMirror = [[UIImageView alloc] initWithImage:DCFDT_SnapshotView(self)];
  CGRect frame = commingMirror.frame;
  frame.origin.x -= x;
  commingMirror.frame = frame;
  [baseView addSubview:commingMirror];
  
  [self removeFromSuperview];
  
  [leavingMirror moveX:x
            completion:^{
              [leavingMirror removeFromSuperview];
            }];
  
  [commingMirror moveX:x
            completion:^{
              [commingMirror removeFromSuperview];
              [baseView removeFromSuperview];
              [superview addSubview:self];
              completion();
            }];
}

- (void)reloadWithY:(CGFloat)y
    reloadDataBlock:(void (^)())reloadDataBlock
         completion:(void (^)())completion
{
  UIView *superview = self.superview;
  
  UIView *baseView = [[UIView alloc] initWithFrame:self.frame];
  baseView.clipsToBounds = YES;
  baseView.backgroundColor = [UIColor clearColor];
  [superview addSubview:baseView];
  
  UIImageView *leavingMirror = [[UIImageView alloc] initWithImage:DCFDT_SnapshotView(self)];
  [baseView addSubview:leavingMirror];
  
  reloadDataBlock();
  
  UIImageView *commingMirror = [[UIImageView alloc] initWithImage:DCFDT_SnapshotView(self)];
  CGRect frame = commingMirror.frame;
  frame.origin.y -= y;
  commingMirror.frame = frame;
  [baseView addSubview:commingMirror];
  
  [self removeFromSuperview];
  
  [leavingMirror moveY:y
            completion:^{
              [leavingMirror removeFromSuperview];
            }];
  
  [commingMirror moveY:y
            completion:^{
              [commingMirror removeFromSuperview];
              [baseView removeFromSuperview];
              [superview addSubview:self];
              completion();
            }];
}

@end
