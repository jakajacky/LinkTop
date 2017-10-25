
/******************************************************************************
 *  @file   : DCCache.h
 *  @author : CUI ZHENSONG
 *  @date   : 2014-12-18
 *  @brief  : 数据缓存基类（抽象类）
 ******************************************************************************/

#import <Foundation/Foundation.h>

#import "DCResult.h"

/*!
 *  @brief  数据缓存基类
 */
@interface DCCache : NSObject

/*!
 *  @brief  临时操作结果
 */
@property (nonatomic,strong) DCResult *result;

@end
