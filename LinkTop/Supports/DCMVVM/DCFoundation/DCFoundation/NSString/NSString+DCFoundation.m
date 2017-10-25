
#import "NSString+DCFoundation.h"

#import <CommonCrypto/CommonDigest.h>
#import <CoreFoundation/CoreFoundation.h>

@implementation NSString (DCFoundation)

- (NSString *)md5
{
  if(self == nil || [self length] == 0)
    return nil;
  
  const char *value = [self UTF8String];
  
  unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
  CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
  
  NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
    [outputString appendFormat:@"%02x",outputBuffer[count]];
  }
  
  return outputString;
}

- (NSString *)pinyin
{
  NSMutableString *pinyin = [NSMutableString string];
  
  [self enumerateSubstringsInRange:self.range
                           options:NSStringEnumerationByComposedCharacterSequences
                        usingBlock:
   ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
     
     NSArray *components = [substring.latin componentsSeparatedByString:@" "];
     
     for (NSString *word in components) {
       if (word.length > 0) {
         [pinyin appendFormat:@"%@ ", word];
       }
     };
     
   }];
  
  if (pinyin.length > 0) {
    [pinyin deleteCharactersInRange:NSMakeRange(pinyin.length - 1, 1)];
  }
  
  return [NSString stringWithString:pinyin];
}

- (NSRange)range
{
  return NSMakeRange(0, self.length);
}

#pragma mark -
#pragma mark Private

- (NSString *)latin
{
  CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (__bridge CFStringRef)(self));
  CFStringTransform(string, NULL, kCFStringTransformToLatin, NO);
  CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
  NSString *latin = [(__bridge NSString *)(string) lowercaseString];
  CFRelease(string);
  return latin;
}

@end
