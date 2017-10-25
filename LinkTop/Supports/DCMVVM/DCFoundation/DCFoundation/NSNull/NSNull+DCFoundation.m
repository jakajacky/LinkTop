
#import "NSNull+DCFoundation.h"

@implementation NSNull (DCFoundation)

- (BOOL)boolValue {
  return NO;
}

- (char)charValue
{
  return 0;
}

- (NSInteger)integerValue{
  return 0;
}

- (long long)longLongValue{
  return 0;
}

- (double)doubleValue{
  return 0;
}

- (float)floatValue {
  return 0;
}

- (NSUInteger)length {
  return 0;
}

- (NSUInteger)count {
  return 0;
}

- (BOOL)isEqualToString:(id)otherString
{
  if ([otherString length] == 0) {
    return YES;
  }
  
  return NO;
}

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {}
- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts
                         usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {}
- (void)enumerateObjectsAtIndexes:(NSIndexSet *)s
                          options:(NSEnumerationOptions)opts
                       usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block {}
- (void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts
                                usingBlock:(void (^)(id key, id obj, BOOL *stop))block {}

- (id)objectForKeyedSubscript:(id)key {
  return [NSNull null];
}

@end
