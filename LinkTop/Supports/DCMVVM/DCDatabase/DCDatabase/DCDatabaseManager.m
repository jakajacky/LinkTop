
#import "DCDatabaseManager.h"

#import "DCDatabase+PrivateMethods.h"
#import "DCDatabase+Upgrade.h"

@implementation DCDatabaseManager
{
  NSMutableDictionary *_dbDict;
}

- (id)init
{
  self = [super init];
  
  if (self) {
    _dbDict = [NSMutableDictionary dictionary];
    _defaultDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
  }
  
  return self;
}

- (DCDatabase *)database:(NSString *)identifier
                 withKey:(NSString *)key
{
  return [self database:identifier directory:self.defaultDirectory withKey:key];
}

- (DCDatabase *)database:(NSString *)identifier
               directory:(NSString *)directory
                 withKey:(NSString *)key
{
  NSString *dbKey = [self keyOfDatabaseIdentifier:identifier directory:directory];

  DCDatabase *db = _dbDict[dbKey];
  
  if (db == nil) {
    db = [self createDatabase:identifier directory:directory withKey:key];
    _dbDict[dbKey] = db;
  }
  
  return db;
}

- (DCDatabase *)createDatabase:(NSString *)identifier
                     directory:(NSString *)directory
                       withKey:(NSString *)key
{
  DCDatabase *db = [[DCDatabase alloc] initWithIdentifer:identifier directory:directory];
  
  if (self.shouldEncryptDatabase && key.length > 0) {
    [db setKey:key];
  }
  
  [db updateTables];
  
  return db;
}

- (void)closeDatabase:(NSString *)identifier
{
  [self closeDatabase:identifier directory:self.defaultDirectory];
}

- (void)closeDatabase:(NSString *)identifier
            directory:(NSString *)directory
{
  NSString *dbKey = [self keyOfDatabaseIdentifier:identifier directory:directory];
  
  DCDatabase *db = _dbDict[dbKey];
  [db close];
  [_dbDict removeObjectForKey:dbKey];
}

- (NSString *)keyOfDatabaseIdentifier:(NSString *)identifier
                            directory:(NSString *)directory
{
  if (identifier.length == 0) {
    return nil;
  }
  return [NSString stringWithFormat:@"%@/%@", directory, identifier];
}

- (void)upgradeDatabase:(DCDatabase *)db
{
  [db beginTransaction];
  
  NSArray *tablesCouldDrop   = [db tablesCouldDrop];
  NSArray *tablesNeedUpgrade = [db tablesNeedUpgrade];
  
  for (NSString *table in tablesCouldDrop) {
    if (_shouldDropTableBlock != nil && _shouldDropTableBlock(db, table)) {
      if (_willDropTableBlock != nil) {
        _willDropTableBlock(db, table);
      }
      
      [db dropTable:table];
      
      if (_didDropTableBlock != nil) {
        _didDropTableBlock(db, table);
      }
    }
  }
  
  for (NSString *table in tablesNeedUpgrade) {
    if (_willUpgradeTableBlock != nil) {
      _willUpgradeTableBlock(db, table);
      
      [db upgradeTable:table];
      
      if (_didUpgradeTableBlock != nil) {
        _didUpgradeTableBlock(db, table);
      }
    }
  }
  
  [db commit];
  
  [db updateTables];
}

#pragma mark -
#pragma mark Singleton Definition

static id instance = nil;

+ (instancetype)sharedManager
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
