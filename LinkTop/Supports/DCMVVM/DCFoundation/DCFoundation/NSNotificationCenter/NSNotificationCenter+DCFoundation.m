
#import "NSNotificationCenter+DCFoundation.h"

@implementation NSNotificationCenter (DCFoundation)

- (id)addObserverForName:(NSString *)name usingBlock:(void (^)(NSNotification *))block
{
  return [self addObserverForName:name object:nil queue:nil usingBlock:block];
}

@end
