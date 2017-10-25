
#import "NSMutableAttributedString+DCFoundation.h"

#import "NSAttributedString+DCFoundation.h"

@implementation NSMutableAttributedString (DCFoundation)

- (void)appendAttributedWithString:(NSString *)string color:(UIColor *)color
{
  if (!string) {
    return;
  }
 
  NSAttributedString *att = [NSAttributedString attributedWithString:string
                                                               color:color];
  [self appendAttributedString:att];
}

- (void)appendAttributedWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color
{
  if (!string) {
    return;
  }
  NSAttributedString *att = [NSAttributedString attributedWithString:string
                                                                font:font
                                                               color:color];
  [self appendAttributedString:att];
}

@end
