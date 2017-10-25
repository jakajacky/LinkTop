
/*
 需要引用的库：
 |- CoreFoundation.framework
 */

#import <Foundation/Foundation.h>

@interface NSString (DCFoundation)

/*!
 *  @brief  将字符串进行 md5 加密
 */
- (NSString *)md5;

/*!
 *  @brief  将字符串转换为拼音
 */
- (NSString *)pinyin;

/*!
 *  @brief  返回当前字符串的 range
 */
- (NSRange)range;

@end
