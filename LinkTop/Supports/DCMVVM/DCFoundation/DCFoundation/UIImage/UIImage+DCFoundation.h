
#import <UIKit/UIKit.h>

@interface UIImage (DCFoundation)

/*!
 *  @brief  将 base64 字符串转换为图片
 */
+ (UIImage *)imageWithBase64String:(NSString *)base64String;

/*!
 *  @brief  使用加载文件路径的方式加载指定图片
 *
 *  @param name 图片名称，必须有后缀（例如：@"image.png"）
 */
+ (UIImage *)imageWithName:(NSString *)name;

/*!
 *  @brief  使用加载文件路径的方式加载指定图片
 *
 *  @param name 图片名称，不能有后缀
 *  @param type 图片类型（@"png", @"jpg" 等）
 */
+ (UIImage *)imageWithName:(NSString *)name type:(NSString *)type;

@end
