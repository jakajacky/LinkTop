
#import "UIView+Shaking.h"

#define kUIViewShakingOffset   7.0
#define kUIViewShakingDuration 0.1
#define kUIViewShakingCount    5

@implementation UIView (Shaking)

- (void)shake {
  static int cnt = 0;
  if (cnt < kUIViewShakingCount) {
    if (cnt % 2 == 0) {
      [self shakeLeft:^{
        [self shake];
      }];
    }
    else {
      [self shakeRight:^{
        [self shake];
      }];
    }
    
    ++cnt;
  }
  else {
    [self shakeRestore];
    cnt = 0;
  }
}

- (void)shakeLeft:(void (^)())completion {
  CGAffineTransform transform = [self shakeTransform:-kUIViewShakingOffset];
  [UIView animateWithDuration:kUIViewShakingDuration
                   animations:^{
                     self.transform = transform;
                   }
                   completion:^(BOOL finished) {
                     completion();
                   }];
}

- (void)shakeRight:(void (^)())completion {
  CGAffineTransform transform = [self shakeTransform:kUIViewShakingOffset];
  [UIView animateWithDuration:kUIViewShakingDuration
                   animations:^{
                     self.transform = transform;
                   }
                   completion:^(BOOL finished) {
                     completion();
                   }];
}

- (void)shakeRestore {
  CGAffineTransform transform = [self shakeTransform:0];
  [UIView animateWithDuration:kUIViewShakingDuration
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     self.transform = transform;
                   }
                   completion:^(BOOL finished) {
                     
                   }];
}

- (CGAffineTransform)shakeTransform:(CGFloat)offset {
  return CGAffineTransformTranslate(CGAffineTransformIdentity, offset, 0);
}

@end
