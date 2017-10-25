
#import "UIImage+DCFoundation.h"

@implementation UIImage (DCFoundation)

+ (UIImage *)imageWithBase64String:(NSString *)base64String
{
  NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String
                                                     options:NSDataBase64DecodingIgnoreUnknownCharacters];
  
  return [UIImage imageWithData:data];
}

+ (UIImage *)imageWithName:(NSString *)name
{
  return [self imageWithName:name type:nil];
}

+ (UIImage *)imageWithName:(NSString *)name type:(NSString *)type
{
  NSString *file = [[NSBundle mainBundle] pathForResource:name ofType:type];
  return [UIImage imageWithContentsOfFile:file];
}

@end
