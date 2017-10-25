
#import <Foundation/Foundation.h>

@interface DCDatabase : NSObject

@property (nonatomic,readonly) NSString *identifier;
@property (nonatomic,readonly) NSString *path;

@property (nonatomic) BOOL allowsLogStatement;
@property (nonatomic) BOOL allowsLogError;

#pragma mark -
#pragma mark 事务

/*!
 *  开始默认事务
 */
- (void)beginTransaction;

/*!
 *  开始指定名称的事务
 *
 *  @param name 事务名称
 */
- (void)beginTransaction:(NSString *)name;

/*!
 *  结束默认事务
 */
- (void)commit;

/*!
 *  结束指定名称的事务
 *
 *  @param name 事务名称
 */
- (void)commit:(NSString *)name;

/*!
 *  回滚事务
 */
- (void)rollback;

#pragma mark -
#pragma mark 建表

/*!
 *  创建对应 objectClass 的数据库表，objectClass 须为 DCDatabaseObject 子类
 *
 *  @param objectClass 数据所属类
 */
- (void)createTableForObjectClass:(Class)objectClass;

#pragma mark -
#pragma mark 查询

/*!
 *  查询指定类型 Object 的全部数据
 *
 *  @param objectClass 指定的 Object 类型，须为 DCDatabaseObject 的子类
 *
 *  @return 指定类型的 Object 数组
 */
- (NSArray *)queryObjectsForClass:(Class)objectClass;

/*!
 *  查询指定类型 Object 的全部数据
 *
 *  @param objectClass 指定的 Object 类型，须为 DCDatabaseObject 的子类
 *  @param orderBy     排序的字段名称
 *  @param desc        是否降序
 *
 *  @return 指定类型的 Object 数组
 */
- (NSArray *)queryObjectsForClass:(Class)objectClass
                          orderBy:(NSString *)orderBy
                             desc:(BOOL)desc;


/*!
 *  查询指定类型 Object 的全部数据
 *
 *  @param objectClass 指定的 Object 类型，须为 DCDatabaseObject 的子类
 *  @param condiition  where字句的条件
 *
 *  @return 指定类型的 Object 数组
 */
- (NSArray *)queryObjectsForClass:(Class)objectClass
                        condition:(NSDictionary *)condiition;

/*!
 *  查询指定类型 Object 的全部数据
 *
 *  @param objectClass 指定的 Object 类型，须为 DCDatabaseObject 的子类
 *  @param condiition  where字句的条件
 *  @param orderBy     排序的字段名称
 *  @param desc        是否降序
 *
 *  @return 指定类型的 Object 数组
 */
- (NSArray *)queryObjectsForClass:(Class)objectClass
                        condition:(NSDictionary *)condiition
                          orderBy:(NSString *)orderBy
                             desc:(BOOL)desc;

/*!
 *  使用 sql 语句执行查询方法
 *
 *  @param sql 不需参数的查询语句
 *
 *  @return NSDictionary 类型的数据的数组
 */
- (NSArray *)query:(NSString *)sql;

/*!
 *  使用 sql 语句执行查询方法，并转换成指定类型的实体
 *
 *  @param sql         不需参数的查询语句
 *  @param objectClass 需要转换的实体类型，不可为空
 *
 *  @return 指定类型的实体数组
 */
- (NSArray *)query:(NSString *)sql convertTo:(Class)objectClass;

/*!
 *  使用 sql 语句及参数执行查询方法
 *
 *  @param sql       需要参数的查询语句
 *  @param arguments 参数列表，需与查询语句中的 "?" 个数顺序一致
 *
 *  @return NSDictionary 类型的数据的数组
 */
- (NSArray *)query:(NSString *)sql withArguments:(NSArray *)arguments;

/*!
 *  使用 sql 语句及参数执行查询方法，并转换成指定类型的实体
 *
 *  @param sql         需要参数的查询语句
 *  @param arguments   参数列表
 *  @param objectClass 需要转换的实体类型，不可为空
 *
 *  @return 指定类型的实体数组
 */
- (NSArray *)query:(NSString *)sql
     withArguments:(NSArray *)arguments
         convertTo:(Class)objectClass;

#pragma mark -
#pragma mark 操作

#pragma mark 通用操作
/*!
 *  使用 sql 语句执行更新方法
 *
 *  @param sql 不需参数的更新语句
 *
 *  @return 是否更新成功
 */
- (BOOL)update:(NSString *)sql;

/*!
 *  使用 sql 语句执行更新方法
 *
 *  @param sql       需要参数的更新语句
 *  @param arguments 参数列表，需与查询语句中的"?" 个数顺序一致
 *
 *  @return 是否更新成功
 */
- (BOOL)update:(NSString *)sql withArguments:(NSArray *)arguments;

#pragma mark 插入及更新

/*!
 *  更新 aKindOfObjects 对应表的数据,注意没有开事务！！！
 *
 *  @param aKindOfObjects 若干 DCDatabaseObject 实例数组，每一个数组中的 Object 须为同一类型，参数以 nil 结尾
 */
- (void)updateObjectsByClass:(NSArray *)aKindOfObjects, ... NS_REQUIRES_NIL_TERMINATION;

/*!
 *  更新 aKindOfObjects 对应表的数据,已在事务中进行
 *
 *  @param aKindOfObjects 若干 DCDatabaseObject 实例数组，每一个数组中的 Object 须为同一类型，参数以 nil 结尾
 */
- (void)updateObjectsByClassInTransaction:(NSArray *)aKindOfObjects, ... NS_REQUIRES_NIL_TERMINATION;

/*!
 *  更新 objects 中的所有对象对应表的数据,注意没有开事务！！！
 *
 *  @param objects 若干 DCDatabaseObject 实例的数组，这些实例可以为不同类型
 */
- (void)updateObjects:(NSArray *)objects;

/*!
 *  更新 objects 中的所有对象对应表的数据,已在事务中进行
 *
 *  @param objects 若干 DCDatabaseObject 实例的数组，这些实例可以为不同类型
 */
- (void)updateObjectsInTransaction:(NSArray *)objects;

#pragma mark 删除

/*!
 *  按指定类清空表（非事务）
 *
 *  @param objectClass 需要清空表的类，必须为 DCDatabaseObject 子类
 */
- (void)clearTableForClass:(Class)objectClass;

/*!
 *  在事务中按指定类清空表
 *
 *  @param objectClass 需要清空表的类，必须为 DCDatabaseObject 子类
 */
- (void)clearTableForClassInTransaction:(Class)objectClass;

/*!
 *  删除指定的表
 *
 *  @param table 指定的表名
 */
- (void)dropTable:(NSString *)table;

#pragma mark -
#pragma mark 其他

/*!
 *  检查表是否存在
 *
 *  @param tableName 需要检查的表的名称
 *
 *  @return 表是否存在
 */
- (BOOL)isTableExist:(NSString *)tableName;

/*!
 *  清空数据库
 */
- (void)cleanup;

@end
