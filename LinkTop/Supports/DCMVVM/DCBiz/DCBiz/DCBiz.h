
/******************************************************************************
 *  @file   : DCBiz.h
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-11
 *  @brief  : 业务逻辑基类（抽象类）
 ******************************************************************************/


#import <Foundation/Foundation.h>

#import "DCDB.h"
#import "DCMVVMConfiguration.h"

/*!
 *  @brief  业务逻辑基类
 */
@interface DCBiz : NSObject

+ (instancetype)biz;

/*!
 *  @brief  根据数据库 id 获取数据库实例
 *
 *  @param identifier 数据库 id
 *  @param key        数据库密钥
 */
- (DCDatabase *)database:(NSString *)identifier withKey:(NSString *)key;

/*!
 *  在指定 directory 目录下，根据数据库 id 获取数据库实例
 *
 *  @param identifier 数据库 id
 *  @param directory  数据库文件的存储目录
 *  @param key        数据库密钥
 */
- (DCDatabase *)database:(NSString *)identifier
               directory:(NSString *)directory
                 withKey:(NSString *)key;

@end
