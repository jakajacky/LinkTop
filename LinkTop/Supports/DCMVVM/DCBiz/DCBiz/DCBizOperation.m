
/******************************************************************************
 *  @file   : DCBizOperation.m
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-20
 *  @brief  : 业务操作基类（抽象类）
 ******************************************************************************/

#import "DCBizOperation.h"

@implementation DCBizOperation

- (NSArray *)convertDictionaries:(NSArray *)dictionaries toClass:(Class)objClass
{
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[dictionaries count]];
  
  if (![dictionaries isKindOfClass:[NSArray class]] || [dictionaries count] == 0) {
    return result;
  }
  
  for (NSDictionary *dict in dictionaries) {
    id object = [[objClass alloc] initWithDictionary:dict];
    [result addObject:object];
  }
  
  return result;
}

@end
