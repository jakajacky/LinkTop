
/******************************************************************************
 *  @file   : DCBiz.m
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-11
 *  @brief  : 业务逻辑基类（抽象类）
 ******************************************************************************/

#import "DCBiz.h"

@interface DCBiz ()

@property (nonatomic,readonly) DCMVVMConfiguration *configuration;
@property (nonatomic,strong)   DCDatabaseManager   *databaseManager;

@end

@implementation DCBiz

+ (instancetype)biz
{
  return [[self alloc] init];
}

#pragma mark -
#pragma mark Properties

#pragma mark Configuration

- (DCMVVMConfiguration *)configuration
{
  return [DCMVVMConfiguration getInstance];
}

#pragma mark Database

- (DCDatabaseManager *)databaseManager
{
  if (!_databaseManager) {
    NSString *path = [self.configuration appGroupDocumentDirectory];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    _databaseManager = [DCDatabaseManager sharedManager];
    
    if (kNeedEncryptDatabase) {
      self.configuration.databaseShouldEncrypt = YES;
    }
    else {
      self.configuration.databaseShouldEncrypt = NO;
    }
    _databaseManager.shouldEncryptDatabase = self.configuration.databaseShouldEncrypt;
  }
  
  return _databaseManager;
}

- (DCDatabase *)database:(NSString *)identifier withKey:(NSString *)key
{
  DCDatabase *db = [self.databaseManager database:identifier withKey:key];
  
  db.allowsLogStatement = self.configuration.databaseAllowsLogStatement;
  db.allowsLogError     = self.configuration.databaseAllowsLogError;
  
  return db;
}

- (DCDatabase *)database:(NSString *)identifier
               directory:(NSString *)directory
                 withKey:(NSString *)key
{
  DCDatabase *db = [self.databaseManager database:identifier
                                        directory:directory
                                          withKey:key];
  
  db.allowsLogStatement = self.configuration.databaseAllowsLogStatement;
  db.allowsLogError     = self.configuration.databaseAllowsLogError;
  
  return db;
}

@end
