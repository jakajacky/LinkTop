
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (DCFoundation)

/*!
 *  @brief  添加指定颜色的字符串
 */
- (void)appendAttributedWithString:(NSString *)string
                             color:(UIColor *)color;

/*!
 *  @brief  添加指定颜色及字体的字符串
 */
- (void)appendAttributedWithString:(NSString *)string
                              font:(UIFont *)font
                             color:(UIColor *)color;

@end
