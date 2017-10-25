
#import <UIKit/UIKit.h>

@interface UIView ()

@property (nonatomic,assign,getter=isVisible) BOOL visible;

@end

@interface UIView (DCFoundation)

/*!
 *  @brief  移除所有子视图
 */
- (void)removeSubviews;

@end
