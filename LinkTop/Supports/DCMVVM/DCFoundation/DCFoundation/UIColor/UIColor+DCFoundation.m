
#import "UIColor+DCFoundation.h"

@implementation UIColor (DCFoundation)

+ (UIColor *)colorWithRedValue:(CGFloat)r
                    greenValue:(CGFloat)g
                     blueValue:(CGFloat)b
{
  return [self colorWithRedValue:r greenValue:g blueValue:b alphaValue:1.0];
}

+ (UIColor *)colorWithRedValue:(CGFloat)r greenValue:(CGFloat)g blueValue:(CGFloat)b alphaValue:(CGFloat)a
{
  return [self colorWithRed:r / 255.0
                      green:g / 255.0
                       blue:b / 255.0
                      alpha:a];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue
{
  return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor*)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha
{
  return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                         green:((float)((hex & 0xFF00) >> 8)) / 255.0
                          blue:((float)(hex & 0xFF)) / 255.0
                         alpha:alpha];
}

+ (UIColor *)grayColorWithRGBValue:(CGFloat)rgb
{
  return [self colorWithRedValue:rgb greenValue:rgb blueValue:rgb alphaValue:1.0];
}

+ (UIColor *)grayColorWithRGBValue:(CGFloat)rgb alpha:(CGFloat)alpha
{
  return [self colorWithRedValue:rgb greenValue:rgb blueValue:rgb alphaValue:alpha];
}

@end
