
/******************************************************************************
 *  @file   : DCBizDatabaseOperation.h
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-20
 *  @brief  : 数据库业务操作基类（抽象类）
 ******************************************************************************/

#import "DCBizOperation.h"

#import "DCDatabase.h"

/*!
 *  @brief       业务层数据库操作类
 *  @discussion  一个实例只允许操作一个数据库
 */
@interface DCBizDatabaseOperation : DCBizOperation

/*!
 *  @brief  使用指定数据库实例化业务操作
 */
+ (instancetype)operationWithDatabase:(DCDatabase *)database;

/*!
 *  @brief  业务操作对应的数据库
 */
@property (nonatomic,readonly) DCDatabase *database;

@end
