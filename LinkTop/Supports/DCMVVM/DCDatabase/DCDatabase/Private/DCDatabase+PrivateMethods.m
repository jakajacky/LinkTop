//
//  DCDatabase+PrivateMethods.m
//  DCDatabase
//
//  Created by Duke on 13-7-29.
//  Copyright (c) 2013年 Duke. All rights reserved.
//

#import "DCDatabase+PrivateMethods.h"
#import "FMDatabase.h"

#import "DCDatabaseConstants.h"

@interface DCDatabase ()
{
  NSOperationQueue * _queue;
  FMDatabase       * _db;
  NSArray          * _tables;
  NSMutableSet     * _classesAlreadyHasTable;
  
  NSString         * _identifier;
  NSString         * _path;
}

@end

@implementation DCDatabase (PrivateMethods)

- (DCDatabase *)initWithIdentifer:(NSString *)identifier
                        directory:(NSString *)directory
{
  self = [super init];
  
  if (self) {
    _identifier = identifier;
    _path       = [directory stringByAppendingPathComponent:identifier];
    
    _classesAlreadyHasTable = [NSMutableSet set];
    
    _queue = [[NSOperationQueue alloc] init];
    _queue.maxConcurrentOperationCount = 1;
    
    _db = [FMDatabase databaseWithPath:_path];
    [_db open];
  }
  
  return self;
}

- (void)close
{
  [_db close];
}

- (void)updateTables
{
  NSMutableArray *tables = [NSMutableArray array];
  NSString *sql = @"SELECT name FROM sqlite_master WHERE type = 'table'";
  
  NSArray *result = [self query:sql withArguments:nil];
  for (NSDictionary *d in result) {
    [tables addObject:d[@"name"]];
  }
  
  _tables = (NSArray *)tables;
}

- (NSArray *)tables
{
  return _tables;
}

- (BOOL)setKey:(NSString *)key
{
  return [_db setKey:key];
}

@end
