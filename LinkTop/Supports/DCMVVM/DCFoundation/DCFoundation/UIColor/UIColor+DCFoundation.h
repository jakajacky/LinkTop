
#import <UIKit/UIKit.h>

@interface UIColor (DCFoundation)

/*!
 *  @brief  使用范围在 [0, 255] 的 rgb 值获取指定颜色
 *
 *  @note  alpha 为 1
 */
+ (UIColor *)colorWithRedValue:(CGFloat)r greenValue:(CGFloat)g blueValue:(CGFloat)b;

/*!
 *  @brief  使用范围在 [0, 255] 的 rgb 值，及范围在 [0, 1] 的 alpha 值获取指定颜色
 */
+ (UIColor *)colorWithRedValue:(CGFloat)r greenValue:(CGFloat)g blueValue:(CGFloat)b alphaValue:(CGFloat)a;

/*!
 *  @brief  使用范围在 [0x000000, 0xFFFFFF] 的十六进制数字获取指定颜色
 */
+ (UIColor *)colorWithHex:(NSInteger)hex;

/*!
 *  @brief  使用范围在 [0x000000, 0xFFFFFF] 的十六进制数字，及范围在 [0, 1] 的 alpha 值获取指定颜色
 */
+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

/*!
 *  @brief  使用范围在 [0, 255] 的数值获取指定的灰色
 */
+ (UIColor *)grayColorWithRGBValue:(CGFloat)rgb;

/*!
 *  @brief  使用范围在 [0, 255] 的数值，及范围在 [0, 1] 的 alpha 值获取指定的灰色
 */
+ (UIColor *)grayColorWithRGBValue:(CGFloat)rgb alpha:(CGFloat)alpha;

@end
