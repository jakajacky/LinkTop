
/******************************************************************************
 *  @file   : DCMVVMConfiguration.m
 *  @author : CUI ZHENSONG
 *  @date   : 2015-03-04
 *  @brief  : DCMVVM 基础配置文件
 ******************************************************************************/

#import "DCMVVMConfiguration.h"

@implementation DCMVVMConfiguration

- (NSString *)appGroupDirectory
{
  NSFileManager *fileMgr = [NSFileManager defaultManager];
  NSURL *url = [fileMgr containerURLForSecurityApplicationGroupIdentifier:self.appGroupId];
  return [url path];
}

- (NSString *)appGroupDocumentDirectory
{
  return [[self appGroupDirectory] stringByAppendingPathComponent:@"Documents"];
}

- (NSString *)appGroupDocumentsPathOfFile:(NSString *)file
{
  return [[self appGroupDocumentDirectory] stringByAppendingPathComponent:file];
}

#pragma mark -
#pragma mark Singleton Definition

static id instance = nil;

+ (instancetype)getInstance
{
  @synchronized(self){
    if (!instance) {
      instance = [[self alloc] init];
    }
  }
  
  return instance;
}

+ (instancetype)allocWithZone:(NSZone *)zone
{
  @synchronized(self){
    if (!instance) {
      instance = [super allocWithZone:zone];
    }
  }
  
  return instance;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
  return self;
}

@end
