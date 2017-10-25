
/******************************************************************************
 *  @file   : DCBizDatabaseOperation.m
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-20
 *  @brief  : 数据库业务操作基类（抽象类）
 ******************************************************************************/

#import "DCBizDatabaseOperation.h"

#import "DCDatabase.h"

@interface DCBizDatabaseOperation ()

@property (nonatomic,strong) DCDatabase *database;

@end

@implementation DCBizDatabaseOperation

+ (instancetype)operationWithDatabase:(DCDatabase *)database
{
  DCBizDatabaseOperation *operation = [[self alloc] init];
  operation.database = database;
  return operation;
}

@end
