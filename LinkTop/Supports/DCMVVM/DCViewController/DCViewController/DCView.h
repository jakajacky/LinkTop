
/******************************************************************************
 *  @file   : DCView.h
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-10
 *  @brief  : 视图基类
 ******************************************************************************/

#import <UIKit/UIKit.h>

extern NSString *kDCViewCoverDidTapNotification;
extern NSString *kDCViewCoverDidSwipeLeftNotification;
extern NSString *kDCViewCoverDidSwipeRightNotification;

/*!
 *  @brief  视图基类
 */
@interface DCView : UIView

/*!
 *  @brief  淡入灰色遮罩视图
 */
- (void)fadeInCover;

/*!
 *  @brief  淡入灰色遮罩视图
 */
- (void)fadeOutCover;

/*!
 *  @brief  淡入灰色遮罩视图
 */
- (void)fadeInCoverCompletion:(void (^)())completion;

/*!
 *  @brief  淡入灰色遮罩视图
 */
- (void)fadeOutCoverCompletion:(void (^)())completion;

/*!
 *  @brief  显示加载指示器
 */
- (void)showLoadingIndicator;

/*!
 *  @brief  隐藏加载指示器
 */
- (void)hideLoadingIndicator;

@end
