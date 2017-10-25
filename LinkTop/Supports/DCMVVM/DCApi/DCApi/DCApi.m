
/******************************************************************************
 *  @file   : DCApi.m
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-13
 *  @brief  : 业务接口基类（抽象类）
 ******************************************************************************/

#import "DCApi.h"

void EXECUTE_OPERATION(DCApi *api, dispatch_block_t block)
{
  [api.operationQueue addOperationWithBlock:block];
}

void EXECUTE_COMPLETION(dispatch_block_t block)
{
  dispatch_async(dispatch_get_main_queue(), block);
}

@interface DCApi ()

@property (nonatomic,strong,readwrite) NSOperationQueue *operationQueue;

@end

@implementation DCApi

- (instancetype)init
{
  self = [super init];
  if (self) {
    _operationQueue = [[NSOperationQueue alloc] init];
    _operationQueue.maxConcurrentOperationCount = 1;
  }
  return self;
}

+ (instancetype)api
{
  return [[self alloc] init];
}

@end
