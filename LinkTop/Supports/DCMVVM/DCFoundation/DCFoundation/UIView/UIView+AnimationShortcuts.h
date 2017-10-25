
#import <UIKit/UIKit.h>

/**
 *  @brief  重新加载视图时的动画方向
 */
typedef NS_ENUM(NSInteger, UIViewReloadAnimationDirection) {
  /**
   *  @brief  不滚动
   */
  UIViewReloadAnimationDirectionNone = 0,
  /**
   *  @brief  向上滚动
   */
  UIViewReloadAnimationDirectionTop,
  /**
   *  @brief  向下滚动
   */
  UIViewReloadAnimationDirectionBottom,
  /**
   *  @brief  向左滚动
   */
  UIViewReloadAnimationDirectionLeft,
  /**
   *  @brief  向右滚动
   */
  UIViewReloadAnimationDirectionRight
};

@interface UIView (AnimationShortcuts)

/*!
 *  @brief      横向移动 x
 *  @discussion 动画时间 0.4 秒
 */
- (void)moveX:(CGFloat)x completion:(void (^)())completion;

/*!
 *  @brief      纵向移动 y
 *  @discussion 动画时间 0.4 秒
 */
- (void)moveY:(CGFloat)y completion:(void (^)())completion;

/*!
 *  @brief      将横坐标置为 x
 *  @discussion 动画时间 0.4 秒
 */
- (void)setX:(CGFloat)x completion:(void (^)())completion;

/*!
 *  @brief      将纵坐标置为 y
 *  @discussion 动画时间 0.4 秒
 */
- (void)setY:(CGFloat)y completion:(void (^)())completion;

/*!
 *  @brief      淡出
 *  @discussion 动画时间 0.5 秒
 */
- (void)fadeout:(void (^)())completion;

/*!
 *  @brief      淡入
 *  @discussion 动画时间 0.5 秒
 */
- (void)fadein:(void (^)())completion;

/*!
 *  @brief      修改坐标及尺寸
 *  @discussion 动画时间 0.4 秒
 */
- (void)changeFrameTo:(CGRect)frame completion:(void (^)())completion;

/*!
 *  @brief  使用指定方向的滚动动画重新加载视图
 *
 *  @param  animationDirection 动画方向
 *  @param  reloadDataBlock    重新加载视图代码块（例如：[tableView reloadData]）
 *  @param  completion         加载完成代码块
 *
 *  @see    UIViewReloadAnimationDirection
 */
- (void)reloadWithAnimationDirection:(UIViewReloadAnimationDirection)animationDirection
                     reloadDataBlock:(void (^)())reloadDataBlock
                          completion:(void (^)())completion;
/*!
 *  @brief  使用指定方向的滚动动画重新加载视图，动画中预留指定的宽度或高度
 *
 *  @param  animationDirection 动画方向
 *  @param  offset             预留的宽度或高度（取决于动画方向）
 *  @param  reloadDataBlock    重新加载视图代码块（例如：[tableView reloadData]）
 *  @param  completion         加载完成代码块
 *
 *  @see    UIViewReloadAnimationDirection
 */
- (void)reloadWithAnimationDirection:(UIViewReloadAnimationDirection)animationDirection
                              offset:(CGFloat)offset
                     reloadDataBlock:(void (^)())reloadDataBlock
                          completion:(void (^)())completion;

@end
