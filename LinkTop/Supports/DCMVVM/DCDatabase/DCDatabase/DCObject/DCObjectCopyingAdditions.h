
#define kClassIsCollectionType(c)  (c == [NSArray      class] || \
                                    c == [NSDictionary class] || \
                                    c == [NSSet        class])   \

#import <Foundation/Foundation.h>

@interface NSArray (DCObjectCopyingAdditions)

- (id)dcobj_deepCopy;

@end

@interface NSDictionary (DCObjectCopyingAdditions)

- (id)dcobj_deepCopy;

@end

@interface NSSet (DCObjectCopyingAdditions)

- (id)dcobj_deepCopy;

@end

