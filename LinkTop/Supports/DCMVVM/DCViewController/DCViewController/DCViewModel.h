
/******************************************************************************
 *  @file   : DCViewModel.h
 *  @author : CUI ZHENSONG
 *  @date   : 2014-12-05
 *  @brief  : 视图模型（ViewModel）基类
 ******************************************************************************/

#import <Foundation/Foundation.h>

/*!
 *  @brief  视图模型基类
 */
@interface DCViewModel : NSObject

/*!
 *  @brief  异步加载数据
 */
- (void)loadData:(void (^)())completion;

/*!
 *  @brief  同步加载数据
 */
- (void)loadData;

@end
