
#import <Foundation/Foundation.h>

@interface NSNull (DCFoundation)

- (BOOL)boolValue;
- (char)charValue;
- (NSInteger)integerValue;
- (long long)longLongValue;
- (float)floatValue;
- (double)doubleValue;

- (NSUInteger)length;
- (NSUInteger)count;

- (BOOL)isEqualToString:(id)otherString;

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts
                         usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (void)enumerateObjectsAtIndexes:(NSIndexSet *)s
                          options:(NSEnumerationOptions)opts
                       usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;


- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block;
- (void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts
                                usingBlock:(void (^)(id key, id obj, BOOL *stop))block;

- (id)objectForKeyedSubscript:(id)key;

@end
