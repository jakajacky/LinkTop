
#import "DCDatabaseObject.h"

@implementation DCDatabaseObject

+ (NSString *)tableName
{
  return NSStringFromClass([self class]);
}

+ (Class)classOfTable:(NSString *)tableName
{
  return NSClassFromString(tableName);
}

+ (NSArray *)propertiesOutOfDatabase
{
  return nil;
}

+ (NSArray *)primaryKeys
{
  return nil;
}

@end
