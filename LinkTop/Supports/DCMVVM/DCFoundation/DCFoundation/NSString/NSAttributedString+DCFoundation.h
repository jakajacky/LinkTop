
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (DCFoundation)

/*!
 *  @brief  将 NSString 转换为 NSAttributedString
 */
+ (NSAttributedString *)attributedWithString:(NSString *)string
                                   alignment:(NSTextAlignment)alignment
                                        font:(UIFont *)font
                                       color:(UIColor *)color;
/*!
 *  @brief  将 NSString 转换为 NSAttributedString
 */
+ (NSAttributedString *)attributedWithString:(NSString *)string
                                       color:(UIColor *)color;
/*!
 *  @brief  将 NSString 转换为 NSAttributedString
 */
+ (NSAttributedString *)attributedWithString:(NSString *)string
                                        font:(UIFont *)font
                                       color:(UIColor *)color;

@end
