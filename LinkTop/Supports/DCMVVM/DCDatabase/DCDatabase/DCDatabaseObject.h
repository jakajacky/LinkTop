
#import "DCObject.h"

@interface DCDatabaseObject : DCObject

/**
 *  @brief  该类型对应的数据库表名称
 */
+ (NSString *)tableName;

/**
 *  @brief  该数据库表名对应的类型
 */
+ (Class)classOfTable:(NSString *)tableName;

/**
 *  @brief  该类型中不会保存在数据库中的属性列表
 */
+ (NSArray *)propertiesOutOfDatabase;

/**
 *  @brief  该类型中作为数据库表主键的属性列表
 */
+ (NSArray *)primaryKeys;

@end
