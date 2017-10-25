
#import <UIKit/UIKit.h>

@interface UIButton (DCFoundation)

/*!
 *  @brief  使用 UIControlEventTouchUpInside 事件注册 target 及 action
 */
- (void)addTarget:(id)target action:(SEL)action;

@end
