
#import "UIButton+DCFoundation.h"

@implementation UIButton (DCFoundation)

- (void)addTarget:(id)target action:(SEL)action
{
  [self addTarget:target
           action:action
 forControlEvents:UIControlEventTouchUpInside];
}

@end
