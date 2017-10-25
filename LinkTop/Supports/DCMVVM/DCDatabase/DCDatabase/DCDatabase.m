 
#import "DCDatabase.h"

#import "DCDatabaseConstants.h"
#import "DCDatabaseObject.h"
#import "DCProperty.h"
#import "DCObjectMacros.h"

#import "FMDatabase.h"

#import "DCDatabase+PrivateMethods.h"

#define DCDatabasePrintStatement(statement, arg) {                                \
                                                   if (self.allowsLogStatement) { \
                                                     NSLog(@"> %@\n  %@\n",       \
                                                     statement, arg);             \
                                                   }                              \
                                                 }

#define DCDatabasePrintErrorOfDatabase(db) {                                                     \
                                             if (self.allowsLogError && db.hadError) {           \
                                               printf("> ##### Database Error ##### <%i>, %s\n", \
                                                 (db.lastErrorCode),                             \
                                                 db.lastErrorMessage.UTF8String);                \
                                             }                                                   \
                                           }

#define DCDatabasePrintLog(log) { printf("> %s\n", [log UTF8String]); }

#define kDCDatabaseDefaultTransactionName @"DefaultTransaction"

typedef NSInvocationOperation DBOperation;

@class DCProperty;
@interface DCDatabase ()
{
  NSOperationQueue * _queue;
  FMDatabase       * _db;
  NSArray          * _tables;
  NSMutableSet     * _classesAlreadyHasTable;
}

@property (nonatomic,readonly) BOOL      inTransaction;
@property (nonatomic,copy)     NSString *transactionName;

// 根据属性类型，返回对应的数据库字段类型
- (NSString *)sqlTypeOfProperty:(DCProperty *)property;

// 更新方法
- (void)updateObject:(DCDatabaseObject *)object;

- (FMResultSet *)executeQuery:(NSString *)sql
                withArguments:(NSArray *)arguments;
- (BOOL)executeUpdate:(NSString*)sql
        withArguments:(NSArray *)arguments;

// 将 resultSet 中 NSDictionary 类型的查询结果转换为 objectClass 类型的对象
- (NSArray *)convertQueryResult:(FMResultSet *)resultSet
                        ofClass:(Class)objectClass;

// Operation 方法，将返回的 Operation 加入到 OperationQueue
- (DBOperation *)beginTransactionOperation;
- (DBOperation *)commitOperation;
- (DBOperation *)rollbackOperation;
- (DBOperation *)queryOperation:(NSString *)sql
                  withArguments:(NSArray *)arguments;
- (DBOperation *)updateOperation:(NSString *)sql
                   withArguments:(NSArray *)arguments;

// 向 operations 中添加对应 objects 的创建数据库表操作及更新数据操作
- (void)fillOperations:(NSMutableArray *)operations
           withObjects:(NSArray *)objects;

@end

@interface DCDatabase (SQLCreation)

// 返回对应objectClass类型的创建数据库表SQL语句，objectClass须为DCDatabaseObject的子类
- (NSString *)sqlForCreateTableForObjectClass:(Class)objectClass;

// 返回更新object数据的SQL语句
// 若表中存在主键冲突，则更新(update)数据；否则直接插入(insert)数据
- (NSString *)getSQLForReplaceObject:(DCDatabaseObject *)object
                        andArguments:(NSMutableArray *)arguments;

- (NSString *)sqlForDeleteObjectsByClass:(Class)objectClass;
- (NSString *)sqlForDeleteObjectsInTable:(NSString *)tableName;

@end

#pragma mark -
#pragma mark Implementation

@implementation DCDatabase

#pragma mark -
#pragma mark 事务

- (void)beginTransaction
{
  [self beginTransaction:kDCDatabaseDefaultTransactionName];
}

- (void)beginTransaction:(NSString *)name
{
  DBOperation *determineOperation = [self allowsBeginTransactionOperation];
  [_queue addOperations:@[determineOperation] waitUntilFinished:YES];
  
  BOOL allowsBeginTransaction = NO;
  [determineOperation.result getValue:&allowsBeginTransaction];
  
  if (allowsBeginTransaction) {
    DCDatabasePrintStatement(@"BEGIN TRANSACTION", name);
    
    DBOperation *namingOperation = [self setTransactionNameOperation:name];
    DBOperation *beginOperation  = [self beginTransactionOperation];
    [_queue addOperations:@[namingOperation, beginOperation] waitUntilFinished:YES];
  }
  else {
    NSString *log = [NSString stringWithFormat:
                     @"##### CANNOT BEGIN TRANSACTION [%@] #####\n  CURRENTLY IN TRANSACTION [%@] ",
                     name, self.transactionName];
    DCDatabasePrintLog(log);
  }
  
  DCDatabasePrintErrorOfDatabase(_db);
}

- (void)commit
{
  [self commit:kDCDatabaseDefaultTransactionName];
}

- (void)commit:(NSString *)name
{
  DBOperation *determineOperation = [self allowsCommitOperation:name];
  [_queue addOperations:@[determineOperation] waitUntilFinished:YES];
  
  BOOL allowsCommit = NO;
  [determineOperation.result getValue:&allowsCommit];
  
  if (allowsCommit) {
    DCDatabasePrintStatement(@"COMMIT", name);
    
    DBOperation *namingOperation = [self setTransactionNameOperation:nil];
    DBOperation *commitOperation  = [self commitOperation];
    [_queue addOperations:@[namingOperation, commitOperation] waitUntilFinished:YES];
  }
  else {
    NSString *log = [NSString stringWithFormat:
                     @"##### CANNOT COMMIT TRANSACTION [%@] #####\n  CURRENTLY IN TRANSACTION [%@] ",
                     name, self.transactionName];
    DCDatabasePrintLog(log);
  }
  
  DCDatabasePrintErrorOfDatabase(_db);
}

- (void)rollback {
  DCDatabasePrintStatement(@"ROLLBACK", @"");
  DBOperation *operation = [self rollbackOperation];
  [_queue addOperations:@[operation] waitUntilFinished:YES];
  DCDatabasePrintErrorOfDatabase(_db);
}

#pragma mark -
#pragma mark 建表

- (void)createTableForObjectClass:(Class)objectClass {
  NSString *sql = [self sqlForCreateTableForObjectClass:objectClass];
  if ([sql length] > 0) {
    DBOperation *operation = [self updateOperation:sql withArguments:nil];
    [_queue addOperations:@[operation] waitUntilFinished:YES];
    DCDatabasePrintErrorOfDatabase(_db);
  }
}

#pragma mark -
#pragma mark 查询

- (NSArray *)queryObjectsForClass:(Class)objectClass
{
  return [self queryObjectsForClass:objectClass condition:nil orderBy:nil desc:NO];
}

- (NSArray *)queryObjectsForClass:(Class)objectClass orderBy:(NSString *)orderBy desc:(BOOL)desc
{
  return [self queryObjectsForClass:objectClass condition:nil orderBy:orderBy desc:desc];
}

- (NSArray *)queryObjectsForClass:(Class)objectClass condition:(NSDictionary *)condiition
{
  return [self queryObjectsForClass:objectClass condition:condiition orderBy:nil desc:NO];
}

- (NSArray *)queryObjectsForClass:(Class)objectClass
                        condition:(NSDictionary *)condiition
                          orderBy:(NSString *)orderBy
                             desc:(BOOL)desc
{
  NSMutableString *sql = [NSMutableString stringWithFormat:
                          @"SELECT * FROM [%@]", [objectClass tableName]];
  
  if (condiition.count > 0) {
    [sql appendString:@" WHERE"];
    
    NSArray *keys = [condiition allKeys];
    for (int i = 0; i < keys.count; i++) {
      NSString *key = keys[i];
      [sql appendFormat:@" %@ = ?", key];
      if (i < keys.count - 1) {
        [sql appendString:@" AND"];
      }
    }
  }
  
  if (orderBy.length > 0) {
    [sql appendFormat:@" ORDER BY %@", orderBy];
    
    if (desc) {
      [sql appendString:@" DESC"];
    }
  }
  
  DCDatabasePrintStatement(sql, @"");
  
  DBOperation *queryOperation = [self queryOperation:sql withArguments:[condiition allValues]];
  
  [_queue addOperations:@[queryOperation] waitUntilFinished:YES];
  
  DCDatabasePrintErrorOfDatabase(_db);
  
  FMResultSet *resultSet = [queryOperation result];
  
  NSArray *result = [self convertQueryResult:resultSet ofClass:objectClass];
  return result;
}

- (NSArray *)query:(NSString *)sql
{
  return [self query:sql withArguments:nil];
}

- (NSArray *)query:(NSString *)sql convertTo:(Class)objectClass
{
  return [self query:sql withArguments:nil convertTo:objectClass];
}

- (NSArray *)query:(NSString *)sql withArguments:(NSArray *)arguments
{
  DCDatabasePrintStatement(sql, arguments);
  
  NSMutableArray *result = [NSMutableArray array];
  
  DBOperation *operation = [self queryOperation:sql withArguments:arguments];
  [_queue addOperations:@[operation] waitUntilFinished:YES];
  DCDatabasePrintErrorOfDatabase(_db);
  
  FMResultSet *rs = [operation result];
  while ([rs next]) {
    [result addObject:[rs resultDictionary]];
  }
  
  return result;
}

- (NSArray *)query:(NSString *)sql withArguments:(NSArray *)arguments convertTo:(Class)objectClass
{
  DCDatabasePrintStatement(sql, arguments);
  
  NSMutableArray *queryResult  = [NSMutableArray array];
  NSMutableArray *entityResult = [NSMutableArray array];
  
  DBOperation *operation = [self queryOperation:sql withArguments:arguments];
  [_queue addOperations:@[operation] waitUntilFinished:YES];
  DCDatabasePrintErrorOfDatabase(_db);
  
  FMResultSet *rs = [operation result];
  while ([rs next]) {
    [queryResult addObject:[rs resultDictionary]];
  }
  
  for (NSDictionary *dict in queryResult) {
    id object = [[objectClass alloc] initWithDictionary:dict];
    [entityResult addObject:object];
  }
  
  return entityResult;
}

#pragma mark -
#pragma mark 操作

#pragma mark 通用操作

- (BOOL)update:(NSString *)sql
{
  return [self update:sql withArguments:nil];
}

- (BOOL)update:(NSString *)sql withArguments:(NSArray *)arguments
{
  BOOL b = NO;
  
  DBOperation *operation = [self updateOperation:sql withArguments:arguments];
  [_queue addOperations:@[operation] waitUntilFinished:YES];
  DCDatabasePrintErrorOfDatabase(_db);
  
  NSValue *value = [operation result];
  [value getValue:&b];
  
  return b;
}

#pragma mark 插入及更新

- (void)updateObjectsByClass:(NSArray *)aKindOfObjects, ...
{
  NSMutableArray *operations = [NSMutableArray array];

  NSArray * objects;
  va_list args;
  if (aKindOfObjects != nil) {
    [self fillOperations:operations withObjects:aKindOfObjects];
    va_start(args, aKindOfObjects);
    while ((objects = va_arg(args, NSArray *))) {
      [self fillOperations:operations withObjects:objects];
      va_end(args);
    }
  }

  [_queue addOperations:operations waitUntilFinished:YES];
  DCDatabasePrintErrorOfDatabase(_db);
}

- (void)updateObjectsByClassInTransaction:(NSArray *)aKindOfObjects, ...
{
  NSMutableArray *operations = [NSMutableArray array];

  [operations addObject:[self beginTransactionOperation]];
  
  NSArray * objects;
  va_list args;
  if (aKindOfObjects != nil) {
    [self fillOperations:operations withObjects:aKindOfObjects];
    va_start(args, aKindOfObjects);
    while ((objects = va_arg(args, NSArray *))) {
      [self fillOperations:operations withObjects:objects];
      va_end(args);
    }
  }
  
  [operations addObject:[self commitOperation]];
  
  [_queue addOperations:operations waitUntilFinished:YES];
  DCDatabasePrintErrorOfDatabase(_db);
}

- (void)updateObjects:(NSArray *)objects
{
  for (DCDatabaseObject *obj in objects) {
    Class class = [obj class];
    if (![_classesAlreadyHasTable containsObject:class]) {
      NSString *sql = [self sqlForCreateTableForObjectClass:class];
      DCDatabasePrintStatement(sql, @"");
      [_queue addOperations:@[[self updateOperation:sql withArguments:nil]]
          waitUntilFinished:YES];
      [_classesAlreadyHasTable addObject:class];
    }
    
    NSMutableArray *args = [NSMutableArray array];
    NSString *sql = [self getSQLForReplaceObject:obj andArguments:args];
    DCDatabasePrintStatement(sql, args);
    [_queue addOperations:@[[self updateOperation:sql withArguments:args]]
        waitUntilFinished:YES];
  }
  
  DCDatabasePrintErrorOfDatabase(_db);
}

- (void)updateObjectsInTransaction:(NSArray *)objects
{
  NSMutableArray *operations = [NSMutableArray array];
  
  [operations addObject:[self beginTransactionOperation]];
  
  for (DCDatabaseObject *obj in objects) {
    Class class = [obj class];
    if (![_classesAlreadyHasTable containsObject:class]) {
      NSString *sql = [self sqlForCreateTableForObjectClass:class];
      DCDatabasePrintStatement(sql, @"");
      [operations addObject:[self updateOperation:sql withArguments:nil]];
      [_classesAlreadyHasTable addObject:class];
    }
    
    NSMutableArray *args = [NSMutableArray array];
    NSString *sql = [self getSQLForReplaceObject:obj andArguments:args];
    DCDatabasePrintStatement(sql, args);
    [operations addObject:[self updateOperation:sql withArguments:args]];
  }
  
  [operations addObject:[self commitOperation]];
  
  [_queue addOperations:operations waitUntilFinished:YES];
  DCDatabasePrintErrorOfDatabase(_db);
}

#pragma mark 删除

- (void)clearTableForClass:(Class)objectClass
{
  NSMutableArray *operations = [NSMutableArray array];
  
  NSString *sql = [self sqlForDeleteObjectsByClass:objectClass];
  DCDatabasePrintStatement(sql, @"");
  [operations addObject:[self updateOperation:sql withArguments:nil]];
  
  [_queue addOperations:operations waitUntilFinished:YES];
  DCDatabasePrintErrorOfDatabase(_db);
}

- (void)clearTableForClassInTransaction:(Class)objectClass
{
  NSMutableArray *operations = [NSMutableArray array];
  
  [operations addObject:[self beginTransactionOperation]];
  
  NSString *sql = [self sqlForDeleteObjectsByClass:objectClass];
  DCDatabasePrintStatement(sql, @"");
  [operations addObject:[self updateOperation:sql withArguments:nil]];
  
  [operations addObject:[self commitOperation]];
  
  [_queue addOperations:operations waitUntilFinished:YES];
  DCDatabasePrintErrorOfDatabase(_db);
}

- (void)clearTable:(NSString *)table
{
  NSMutableArray *operations = [NSMutableArray array];
  
  NSString *sql = [self sqlForDeleteObjectsInTable:table];
  DCDatabasePrintStatement(sql, @"");
  [operations addObject:[self updateOperation:sql withArguments:nil]];
  
  [_queue addOperations:operations waitUntilFinished:YES];
  DCDatabasePrintErrorOfDatabase(_db);
}

- (void)clearTableInTransaction:(NSString *)table
{
  NSMutableArray *operations = [NSMutableArray array];
  
  [operations addObject:[self beginTransactionOperation]];
  
  NSString *sql = [self sqlForDeleteObjectsInTable:table];
  DCDatabasePrintStatement(sql, @"");
  [operations addObject:[self updateOperation:sql withArguments:nil]];
  
  [operations addObject:[self commitOperation]];
  
  [_queue addOperations:operations waitUntilFinished:YES];
  DCDatabasePrintErrorOfDatabase(_db);
}

- (void)dropTable:(NSString *)table
{
  NSMutableArray *operations = [NSMutableArray array];
  
  NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@", table];
  DCDatabasePrintStatement(sql, @"");
  [operations addObject:[self updateOperation:sql withArguments:nil]];
  
  [_queue addOperations:operations waitUntilFinished:YES];
  DCDatabasePrintErrorOfDatabase(_db);
}

#pragma mark -
#pragma mark 其他

- (BOOL)isTableExist:(NSString *)tableName
{
  NSString *sql = @"SELECT * FROM sqlite_master \
                    WHERE type = 'table' AND name = ?";
  NSArray *result = [self query:sql withArguments:@[tableName]];
  return [result count] > 0;
}

- (void)cleanup
{
  NSString *sql = @"SELECT name FROM sqlite_master WHERE type = 'table'";
  NSArray *result = [self query:sql];
  
  [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSString * tableName = obj[@"name"];
    [self dropTable:tableName];
  }];
  
  [self updateTables];
  
  [_classesAlreadyHasTable removeAllObjects];
}

#pragma mark -
#pragma mark Private Methods

- (NSString *)sqlTypeOfProperty:(DCProperty *)property
{
  static NSDictionary *propertySqlTypeDictionary = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    propertySqlTypeDictionary = @{
                                  kDCPropertyTypeBOOL     : kDCSQLTypeInteger,
                                  kDCPropertyTypeChar     : kDCSQLTypeInteger,
                                  kDCPropertyTypeInt      : kDCSQLTypeInteger,
                                  kDCPropertyTypeLong     : kDCSQLTypeInteger,
                                  kDCPropertyTypeLongLong : kDCSQLTypeInteger,
                                  kDCPropertyTypeShort    : kDCSQLTypeInteger,
                                  kDCPropertyTypeUInt     : kDCSQLTypeInteger,
                                  kDCPropertyTypeDouble   : kDCSQLTypeDouble,
                                  kDCPropertyTypeFloat    : kDCSQLTypeFloat,
                                  kDCPropertyTypeString   : kDCSQLTypeText
                                  };
  });
  
  NSString *sqlType = propertySqlTypeDictionary[property.type];
  
  NSAssert(sqlType != nil, @"Cannot verify column type for property : %@", property);
  
  return sqlType;
}

- (void)updateObject:(DCDatabaseObject *)object
{
  NSMutableArray *args = [NSMutableArray array];
  NSString *sql = [self getSQLForReplaceObject:object andArguments:args];
  if (sql != nil)
    [self executeUpdate:sql withArguments:args];
}

- (FMResultSet *)executeQuery:(NSString *)sql withArguments:(NSArray *)arguments
{
  DCDatabasePrintStatement(sql, arguments);
  
  FMResultSet *result = [_db executeQuery:sql withArgumentsInArray:arguments];
  DCDatabasePrintErrorOfDatabase(_db);
  
  return result;
}

- (BOOL)executeUpdate:(NSString*)sql withArguments:(NSArray *)arguments
{
  DCDatabasePrintStatement(sql, arguments);
  
  BOOL b;
  if ([arguments count] > 0) {
    b = [_db executeUpdate:sql withArgumentsInArray:arguments];
  }
  else {
    b = [_db executeUpdate:sql];
  }
  DCDatabasePrintErrorOfDatabase(_db);
  
  return b;
}

- (NSArray *)convertQueryResult:(FMResultSet *)resultSet
                        ofClass:(Class)objectClass
{
  NSMutableArray *results = [NSMutableArray array];
  
  while ([resultSet next]) {
    NSDictionary *dictionary = [resultSet resultDictionary];
    id object = [[objectClass alloc] initWithDictionary:dictionary];
    [results addObject:object];
  }
  
  return results;
}

- (BOOL)allowsBeginTransaction
{
  return !self.inTransaction;
}

- (BOOL)allowsCommit:(NSString *)name
{
  return self.inTransaction && [name isEqualToString:self.transactionName];
}

#pragma mark -
#pragma mark Operations

- (DBOperation *)allowsBeginTransactionOperation
{
  DBOperation *op = [[DBOperation alloc] initWithTarget:self
                                               selector:@selector(allowsBeginTransaction)
                                                 object:nil];
  return op;
}

- (DBOperation *)setTransactionNameOperation:(NSString *)name
{
  DBOperation *op = [[DBOperation alloc] initWithTarget:self
                                               selector:@selector(setTransactionName:)
                                                 object:name];
  return op;
}

- (DBOperation *)beginTransactionOperation
{
  DBOperation *op = [[DBOperation alloc] initWithTarget:_db
                                               selector:@selector(beginTransaction)
                                                 object:nil];
  return op;
}

- (DBOperation *)allowsCommitOperation:(NSString *)name
{
  DBOperation *op = [[DBOperation alloc] initWithTarget:self
                                               selector:@selector(allowsCommit:)
                                                 object:name];
  return op;
}

- (DBOperation *)commitOperation
{
  DBOperation *op = [[DBOperation alloc] initWithTarget:_db
                                               selector:@selector(commit)
                                                 object:nil];
  return op;
}

- (DBOperation *)rollbackOperation
{
  DBOperation *op = [[DBOperation alloc] initWithTarget:_db
                                               selector:@selector(rollback)
                                                 object:nil];
  return op;
}

- (DBOperation *)queryOperation:(NSString *)sql
                  withArguments:(NSArray *)arguments
{
  SEL selector = @selector(executeQuery:withArgumentsInArray:);
  NSMethodSignature *sig = [_db methodSignatureForSelector:selector];
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
  [invocation setTarget:_db];
  [invocation setSelector:selector];
  [invocation setArgument:&sql atIndex:2];
  [invocation setArgument:&arguments atIndex:3];
  
  DBOperation *op = [[DBOperation alloc] initWithInvocation:invocation];
  return op;
}

- (DBOperation *)updateOperation:(NSString *)sql
                   withArguments:(NSArray *)arguments
{
  SEL selector = @selector(executeUpdate:withArgumentsInArray:);
  NSMethodSignature *sig = [_db methodSignatureForSelector:selector];
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
  [invocation setTarget:_db];
  [invocation setSelector:selector];
  [invocation setArgument:&sql atIndex:2];
  [invocation setArgument:&arguments atIndex:3];
  
  DBOperation *op = [[DBOperation alloc] initWithInvocation:invocation];
  return op;
}

- (void)fillOperations:(NSMutableArray *)operations
           withObjects:(NSArray *)objects
{
  if (objects.count > 0) {
    Class class = [objects[0] class];
    if (![_classesAlreadyHasTable containsObject:class]) {
      NSString *sql = [self sqlForCreateTableForObjectClass:class];
      [operations addObject:[self updateOperation:sql withArguments:nil]];
      [_classesAlreadyHasTable addObject:class];
    }
    
    for (DCDatabaseObject *obj in objects) {
      NSMutableArray *args = [NSMutableArray array];
      NSString *sql = [self getSQLForReplaceObject:obj andArguments:args];
      [operations addObject:[self updateOperation:sql withArguments:args]];
    }
  }
}

#pragma mark -
#pragma mark Properties

- (BOOL)inTransaction
{
  return [_db inTransaction];
}

@end

#pragma mark -
#pragma mark SQL Creation

@implementation DCDatabase (SQLCreation)

- (NSString *)sqlForCreateTableForObjectClass:(Class)objectClass
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (name IN %@)",
                            [objectClass propertiesOutOfDatabase]];

  NSArray *properties = [[[objectClass propertyDictionary] allValues] filteredArrayUsingPredicate:predicate];
  
  if (properties.count == 0) {
    return nil;
  }
  
  NSMutableString *sql = [NSMutableString stringWithFormat:
                          @"CREATE TABLE IF NOT EXISTS [%@] (",
                          [objectClass tableName]];
  
  for (DCProperty *p in properties) {
    NSString *sqlType = [self sqlTypeOfProperty:p];
    [sql appendFormat:@"[%@] %@,", p.name, sqlType];
  }

  NSArray *pkList = [objectClass primaryKeys];
  if (pkList.count > 0) {
    [sql appendFormat:@"PRIMARY KEY ("];
    for (int i =0; i < [pkList count]; i++) {
      [sql appendFormat:@"[%@],", pkList[i]];
    }
    [sql deleteCharactersInRange:NSMakeRange(sql.length - 1, 1)];
    [sql appendString:@")"];
  }
  else {
    [sql deleteCharactersInRange:NSMakeRange(sql.length - 1, 1)];
  }
  
  [sql appendString:@")"];
  
  return (NSString *)sql;
}

- (NSString *)getSQLForReplaceObject:(DCDatabaseObject *)object
                        andArguments:(NSMutableArray *)arguments
{
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:object.dictionary];
  
  for (NSString *key in [[object class] propertiesOutOfDatabase]) {
    [dictionary removeObjectForKey:key];
  }
  
  if (dictionary.count == 0) {
    return nil;
  }
  
  NSMutableString *sql = [NSMutableString stringWithFormat:
                          @"REPLACE INTO [%@] (", [[object class] tableName]];
  
  NSMutableString *rows   = [NSMutableString string];
  NSMutableString *values = [NSMutableString string];
  
  [dictionary enumerateKeysAndObjectsUsingBlock:
   ^(id key, id obj, BOOL *stop) {
     [rows appendFormat:@" [%@],", key];
     [values appendString:@" ?,"];
     [arguments addObject:obj];
   }];
  
  [rows deleteCharactersInRange:NSMakeRange(rows.length - 1, 1)];
  [values deleteCharactersInRange:NSMakeRange(values.length - 1, 1)];
  
  [sql appendFormat:@"%@) VALUES (%@)", rows, values];
  
  return (NSString *)sql;
}

- (NSString *)sqlForDeleteObjectsByClass:(Class)objectClass
{
  return [NSString stringWithFormat:@"DELETE FROM [%@]", [objectClass tableName]];
}

- (NSString *)sqlForDeleteObjectsInTable:(NSString *)tableName
{
  return [NSString stringWithFormat:@"DELETE FROM [%@]", tableName];
}

@end
