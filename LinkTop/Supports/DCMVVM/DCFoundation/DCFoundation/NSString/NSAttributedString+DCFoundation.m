
#import "NSAttributedString+DCFoundation.h"

@implementation NSAttributedString (DCFoundation)

+ (NSAttributedString *)attributedWithString:(NSString *)string
                                   alignment:(NSTextAlignment)alignment
                                        font:(UIFont *)font
                                       color:(UIColor *)color
{
  if (!string) {
    return nil;
  }
  
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = alignment;
  
  return [[NSAttributedString alloc] initWithString:string
                                         attributes:@{NSParagraphStyleAttributeName  : paragraphStyle,
                                                      NSFontAttributeName            : font,
                                                      NSForegroundColorAttributeName : color}];
}

+ (NSAttributedString *)attributedWithString:(NSString *)string
                                       color:(UIColor *)color
{
  return [NSAttributedString attributedWithString:string
                                        alignment:NSTextAlignmentLeft
                                             font:[UIFont systemFontOfSize:14]
                                            color:color];
}

+ (NSAttributedString *)attributedWithString:(NSString *)string
                                        font:(UIFont *)font
                                       color:(UIColor *)color
{
  return [NSAttributedString attributedWithString:string
                                        alignment:NSTextAlignmentLeft
                                             font:font
                                            color:color];
}

@end
