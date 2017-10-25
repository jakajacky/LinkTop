#import "NSString+HttpRequestAdditions.h"

@implementation NSString (HttpRequestAdditions)

- (NSString*)dchr_urlEncode {
  //  !   @   $   &   (   )   =   +   ~   `   ;   '   :   ,   /   ?   *
  // %21 %40 %24 %26 %28 %29 %3D %2B %7E %60 %3B %27 %3A %2C %2F %3F %2A
  
  NSDictionary *chars = @{@"!" : @"%21", @"@" : @"%40", @"$" : @"%24", @"&" : @"%26", @"(" : @"%28",
                          @")" : @"%29", @"=" : @"%3D", @"+" : @"%2B", @"~" : @"%7E", @"`" : @"%60",
                          @";" : @"%3B", @"'" : @"%27", @":" : @"%3A", @"," : @"%2C", @"/" : @"%2F",
                          @"?" : @"%3F", @"*" : @"%2A"
                          };
  
  NSString *defaultEncodingString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  NSMutableString *temp = [NSMutableString stringWithString:defaultEncodingString];
  
  [chars enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    [temp replaceOccurrencesOfString:key
                          withString:obj
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [temp length])];
  }];
  
  NSString *outStr = [NSString stringWithString:temp];
  
  return outStr;
}

- (NSString *)dchr_urlCombineWithParams:(id)params {
  NSMutableString *paramStr = [NSMutableString stringWithString:@"?"];

  if ([params isKindOfClass:[NSDictionary class]]) {
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
      [paramStr appendFormat:@"%@=%@&",
       key, [obj isKindOfClass:[NSString class]] ? [obj dchr_urlEncode] : obj];
    }];
  }

  if (paramStr.length > 0) {
    [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length - 1, 1)];
  }

  NSString *outurl = [self stringByAppendingString:paramStr];

  return outurl;
}

@end
