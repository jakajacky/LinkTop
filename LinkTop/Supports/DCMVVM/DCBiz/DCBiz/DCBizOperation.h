
/******************************************************************************
 *  @file   : DCBizOperation.h
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-20
 *  @brief  : 业务操作基类（抽象类）
 ******************************************************************************/

#import <Foundation/Foundation.h>

/*!
 *  @brief  业务操作基类
 */
@interface DCBizOperation : NSObject

/*!
 *  @brief  将一组字典转换为一组指定的实例
 */
- (NSArray *)convertDictionaries:(NSArray *)dictionaries toClass:(Class)objClass;

@end
