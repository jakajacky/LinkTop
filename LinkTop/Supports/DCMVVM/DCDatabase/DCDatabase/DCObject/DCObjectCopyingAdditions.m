
#import "DCObjectCopyingAdditions.h"

@implementation NSArray (DCObjectCopyingAdditions)

- (id)dcobj_deepCopy
{
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
  
  for (id obj in self) {
    id copy = nil;
    
    if (kClassIsCollectionType([obj class])) {
      copy = [obj dcobj_deepCopy];
    }
    else {
      copy = [obj copy];
    }
    
    [array addObject:copy];
  }
  
  return [NSArray arrayWithArray:array];
}

@end

@implementation NSDictionary (DCObjectCopyingAdditions)

- (id)dcobj_deepCopy
{
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[self count]];
  
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    id copy = nil;
    
    if (kClassIsCollectionType([obj class])) {
      copy = [obj dcobj_deepCopy];
    }
    else {
      copy = [obj copy];
    }
    
    dict[key] = copy;
  }];
  
  return [NSDictionary dictionaryWithDictionary:dict];
}

@end

@implementation NSSet (DCObjectCopyingAdditions)

- (id)dcobj_deepCopy
{
  NSMutableSet *set = [NSMutableSet setWithCapacity:[self count]];
  
  for (id obj in self) {
    id copy = nil;
    
    if (kClassIsCollectionType([obj class])) {
      copy = [obj dcobj_deepCopy];
    }
    else {
      copy = [obj copy];
    }
    
    [set addObject:copy];
  }
  
  return [NSSet setWithSet:set];
}

@end
