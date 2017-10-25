
/******************************************************************************
 *  @file   : DCResult.h
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-21
 *  @brief  : 业务操作结果基类
 ******************************************************************************/

#import <Foundation/Foundation.h>

/*!
 *  @brief  业务操作结果基类
 */
@interface DCResult : NSObject

/*!
 *  @brief  成功或失败
 */
@property (nonatomic,readonly) BOOL          success;

/*!
 *  @brief  错误码
 */
@property (nonatomic,readonly) NSInteger     errorCode;

/*!
 *  @brief  错误信息
 */
@property (nonatomic,readonly) NSString     *errorMessage;

/*!
 *  @brief  自定义信息
 */
@property (nonatomic,readonly) NSDictionary *userInfo;

/*!
 *  @brief  实例化默认成功的实例
 */
+ (instancetype)successResult;

/*!
 *  @brief  实例化指定错误码及错误信息的错误操作结果实例
 */
+ (instancetype)errorResultWithCode:(NSInteger)code
                            message:(NSString *)message;

/*!
 *  @brief  实例化包含自定义信息的指定错误码及错误信息的错误操作结果实例
 */
+ (instancetype)errorResultWithCode:(NSInteger)code
                            message:(NSString *)message
                           userInfo:(NSDictionary *)userInfo;

@end
