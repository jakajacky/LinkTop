
/******************************************************************************
 *  @file   : DCViewController.h
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-10
 *  @brief  : 视图控制器基类
 ******************************************************************************/

#import <Foundation/Foundation.h>

#import "DCView.h"

#define AddView(instance, class, frame)  ({                                                       \
                                            (instance) = [[(class) alloc] initWithFrame:(frame)]; \
                                            [self.view addSubview:(instance)];                    \
                                          })

/*!
 *  @class      DCViewController
 *  @superclass UIViewController
 *
 *  @brief  视图控制器基类
 */
@interface DCViewController : UIViewController

@property (nonatomic,strong) DCView *view;;

@end

/*!
 *  @brief  用于子类重载的方法
 */
@interface DCViewController (Override)

/*!
 *  @brief    返回主视图的类型
 *
 *  @return   必须是 DCView 的子类
 *
 *  @warning  仅用于子类重载，不可以直接调用
 */
- (Class)viewClass;

/*!
 *  @brief    返回主视图的 frame
 *
 *  @return   默认 {0, 0, 1024, 768}
 *
 *  @warning  仅用于子类重载，不可以直接调用
 */
- (CGRect)viewFrame;

/*!
 *  @brief    返回子控制器的视图的 frame
 *
 *  @param    child 子控制器
 *
 *  @return   默认 {0, 0, 1024, 768}
 *
 *  @warning  仅用于子类重载，不可以直接调用
 */
- (CGRect)viewFrameForChildViewController:(DCViewController *)child;


@end

/*!
 *  @brief  手势事件扩展
 */
@interface DCViewController (BaseViewGestureAdditions)

/*!
 *  @brief  返回当前的控制器是否允许使用手势触发 pop
 */
- (BOOL)allowsPop;

@end

/*!
 *  @brief  加载指示器扩展
 */
@interface DCViewController (LoadingIndicator)

/*!
 *  @brief  在主视图中显示加载指示器
 */
- (void)showLoadingIndicator;

/*!
 *  @brief  在主视图中隐藏加载指示器
 */
- (void)hideLoadingIndicator;

@end

/*!
 *  @brief  推出视图（向左）扩展
 */
@interface DCViewController (PushAdditions)

/*!
 *  @brief  用于子类重载，当控制器被 pop 到最上层控制器时回调
 */
- (void)didPopBack;

@end

/*!
 *  @brief  弹出视图（向上）扩展
 */
@interface DCViewController (PresentAdditions)

/*!
 *  @brief  用于子类重载，当控制器被 dismiss 到最上层控制器时回调
 */
- (void)didDismissBack;

@end
