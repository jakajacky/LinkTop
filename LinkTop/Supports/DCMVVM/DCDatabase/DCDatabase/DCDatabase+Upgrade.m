//
//  DCDatabase+Upgrade.m
//  DCDatabase
//
//  Created by Duke on 13-5-27.
//  Copyright (c) 2013年 Duke. All rights reserved.
//

#import "DCDatabase+Upgrade.h"

#import "DCDatabase+PrivateMethods.h"

#import "DCDatabaseObject.h"
#import "DCProperty.h"

@interface DCDatabase (Upgrade_PrivateMethods)

- (NSArray *)fieldsOfObjectClass:(Class)objectClass;
- (NSArray *)fieldsInTable:(NSString *)tableName;
- (void)moveDataForTable:(NSString *)table
               newFields:(NSArray *)newFields
               oldFields:(NSArray *)oldFields;

@end

@implementation DCDatabase (Upgrade)

- (NSArray *)tablesCouldDrop
{
  NSArray *tables = [self tables];
  NSMutableArray *tablesCouldDrop = [NSMutableArray array];
  
  for (NSString *table in tables) {
    Class class = [DCDatabaseObject classOfTable:table];
    
    if (class == NULL || ![class isSubclassOfClass:[DCObject class]]) {
      [tablesCouldDrop addObject:table];
    }
  }
  
  return tablesCouldDrop;
}

- (NSArray *)tablesNeedUpgrade
{
  NSArray *tables = [self tables];
  NSMutableArray *tablesNeedUpgrade = [NSMutableArray array];
  
  for (NSString *table in tables) {
    Class class = [DCDatabaseObject classOfTable:table];
    NSArray *fieldsOfClass = [self fieldsOfObjectClass:class];
    NSArray *fieldsOfTable = [self fieldsInTable:table];
    
    if (![fieldsOfClass isEqualToArray:fieldsOfTable] && fieldsOfClass.count > 0) {
      [tablesNeedUpgrade addObject:table];
    }
  }
  
  return tablesNeedUpgrade;
}

- (void)upgradeTable:(NSString *)table
{
  Class class = [DCDatabaseObject classOfTable:table];
  NSArray *fieldsOfClass = [self fieldsOfObjectClass:class];
  NSArray *fieldsOfTable = [self fieldsInTable:table];
  
  NSString *tableTmp = [table stringByAppendingString:@"_TMP"];
  NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@", table, tableTmp];
  
  [self update:sql withArguments:nil];
  [self createTableForObjectClass:class];
  [self moveDataForTable:table
               newFields:fieldsOfClass
               oldFields:fieldsOfTable];
  [self dropTable:tableTmp];
}

@end


@implementation DCDatabase (Upgrade_PrivateMethods)

- (NSArray *)fieldsOfObjectClass:(Class)objectClass
{
  NSArray * properties = [[objectClass propertyDictionary] allValues];
  
  NSMutableArray * fields = [NSMutableArray array];
  
  [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    DCProperty * property = obj;
    if (property.name != nil) {
      [fields addObject:property.name];
    }
  }];
  
  [fields sortedArrayUsingSelector:@selector(compare:)];
  
  return fields;
}

- (NSArray *)fieldsInTable:(NSString *)tableName
{
  NSString * sql = [NSString stringWithFormat:@"PRAGMA table_info(%@)", tableName];
  NSArray *result = [self query:sql withArguments:nil];
  
  NSMutableArray *fields = [NSMutableArray array];
  
  for (NSDictionary *d in result) {
    [fields addObject:d[@"name"]];
  }
  
  [fields sortedArrayUsingSelector:@selector(compare:)];
  
  return fields;
}

- (void)moveDataForTable:(NSString *)table
               newFields:(NSArray *)newFields
               oldFields:(NSArray *)oldFields
{
  NSMutableString *sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ (", table];
  
  NSMutableString *fieldsString = [NSMutableString string];
  for (NSString *field in oldFields) {
    if ([newFields containsObject:field]) {
      [fieldsString appendFormat:@"%@,", field];
    }
  }
  if (fieldsString.length > 0) {
    NSRange range = NSMakeRange(fieldsString.length - 1, 1);
    [fieldsString deleteCharactersInRange:range];
  }
  
  [sql appendFormat:@"%@) SELECT %@ FROM %@_TMP", fieldsString, fieldsString, table];
  [self update:sql withArguments:nil];
}

@end
