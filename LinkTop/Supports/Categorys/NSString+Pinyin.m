//
//  NSString+Pinyin.m
//  WorkingCenter
//
//  Created by Duke on 13-12-26.
//  Copyright (c) 2013年 Duke. All rights reserved.
//

#import "NSString+Pinyin.h"

@implementation NSString (Pinyin)

- (NSString *)pinyin
{
  CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (__bridge CFStringRef)(self));
  CFStringTransform(string, NULL, kCFStringTransformToLatin, NO);
  CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
  NSString *pinyin = [(__bridge NSString *)(string) lowercaseString];
  CFRelease(string);
  return pinyin;
}

@end

@implementation NSString (Pinyin_Deprecated)

static NSString *g_sPinyinFileName = @"pinyin.plist";
static NSDictionary *PINYIN_DICTIONARY = nil;

- (NSString *)pinyin_deprecated
{
  if (!PINYIN_DICTIONARY) {
    NSString *pinyinFile = [[NSBundle mainBundle] pathForResource:g_sPinyinFileName
                                                           ofType:nil];
    PINYIN_DICTIONARY = [NSDictionary dictionaryWithContentsOfFile:pinyinFile];
  }
  
  NSMutableString *pinyin = [NSMutableString string];
  
  for (int i=0; i<self.length; i++) {
    NSString *s = [[self substringWithRange:NSMakeRange(i, 1)] lowercaseString];
    NSString *py = PINYIN_DICTIONARY[s];
    [pinyin appendString:py ? py : s];
  }
  
  return pinyin;
}


@end
