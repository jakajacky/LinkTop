
/******************************************************************************
 *  @file   : DCApi.h
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-13
 *  @brief  : 业务接口基类（抽象类）
 ******************************************************************************/

#import <Foundation/Foundation.h>

/*!
 *  @brief  业务接口基类
 */
@interface DCApi : NSObject

/*!
 *  @brief  事务处理队列
 */
@property (nonatomic,readonly) NSOperationQueue *operationQueue;

/*!
 *  @brief  实例化 DCApi 对象
 */
+ (instancetype)api;

@end

/*!
 *  @brief  在子线程中处理事务
 *
 *  @param api   当前使用的 DCApi 实例
 *  @param block 事务处理代码块，在子线程中执行
 *
 *  @discussion  一般在 block 参数代码块末尾添加 EXECUTE_COMPLETION 方法以通知主线程
 */
extern void EXECUTE_OPERATION(DCApi *api, dispatch_block_t block);

/*!
 *  @brief  在主线程中处理事务或完成通知
 *
 *  @param block 事务处理或通知代码块，在主线程中执行
 *
 *  @discussion  一般写在 EXECUTE_OPERATION 方法中 block 参数代码块的末尾
 */
extern void EXECUTE_COMPLETION(dispatch_block_t block);
