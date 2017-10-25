
#import <Foundation/Foundation.h>

@interface DCObject : NSObject <NSCopying>

- (instancetype)init;

/**
 *  @brief  使用指定的字典初始化 DCObject 实例
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  @brief  将实例中的属性转换为字典
 */
- (NSDictionary *)dictionary;

/**
 *  @brief  返回使用字典初始化实例后，无法识别的值的集合
 */
- (NSDictionary *)undefinedProperties;

/**
 *  @brief  返回该类的全部属性的字典，属性名为 key
 */
+ (NSDictionary *)propertyDictionary;

@end

