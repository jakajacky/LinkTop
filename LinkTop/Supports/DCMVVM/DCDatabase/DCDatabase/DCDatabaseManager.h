
#import <Foundation/Foundation.h>

#import "DCDatabase.h"

typedef void(^DCDatabaseBlock)(DCDatabase *database, NSString *tableName);
typedef BOOL(^DCDatabaseShouldDropTableBlock)(DCDatabase *database, NSString *tableName);

@interface DCDatabaseManager : NSObject

/*!
 *  单例模式获取 DCDatabaseManager 实例
 */
+ (instancetype)sharedManager;


/*!
 *  获取默认目录下，指定 identifier 的数据库对象。
 *  若调用此方法时尚未创建相应的 database，则自动创建并打开
 *
 *  @param identifier 数据库的标识名称
 *  @param key        加密密码，在 shouldEncryptDatabase 为 YES 时，使用 key 对数据库进行加密
 *
 *  @return 数据库的 DCDatabase 实例
 */
- (DCDatabase *)database:(NSString *)identifier
                 withKey:(NSString *)key;

/*!
 *  获取指定 directory 目录下，指定 identifier 的数据库对象。
 *  若调用此方法时尚未创建相应的 database，则自动创建并打开
 *
 *  @param identifier 数据库的标识名称
 *  @param directory  数据库文件的存储目录
 *  @param key        加密密码，在 shouldEncryptDatabase 为 YES 时，使用 key 对数据库进行加密
 *
 *  @return 数据库的 DCDatabase 实例
 */
- (DCDatabase *)database:(NSString *)identifier
               directory:(NSString *)directory
                 withKey:(NSString *)key;


/*!
 *  关闭默认目录下，指定 identifier 的 数据库对象
 *
 *  @param identifier 数据库的标识名称
 */
- (void)closeDatabase:(NSString *)identifier;

/*!
 *  关闭指定 directory 目录下，指定 identifier 的 数据库对象
 *
 *  @param identifier 数据库的标识名称
 *  @param directory  数据库文件的存储目录
 */
- (void)closeDatabase:(NSString *)identifier directory:(NSString *)directory;


/*!
 *  升级指定的DCDatabase，当表需要升级或删除时调用相应的block方法
 *
 *  @param db 指定的数据库对象
 */
- (void)upgradeDatabase:(DCDatabase *)db;


/*!
 *  数据库文件保存的默认目录，默认是 App 对应的 Documents 目录
 */
@property (nonatomic,copy) NSString *defaultDirectory;

/**
 *  @brief  是否加密数据库
 */
@property (nonatomic,assign) BOOL shouldEncryptDatabase;

@property (nonatomic,strong) DCDatabaseShouldDropTableBlock shouldDropTableBlock;
@property (nonatomic,strong) DCDatabaseBlock willDropTableBlock;
@property (nonatomic,strong) DCDatabaseBlock didDropTableBlock;
@property (nonatomic,strong) DCDatabaseBlock willUpgradeTableBlock;
@property (nonatomic,strong) DCDatabaseBlock didUpgradeTableBlock;

@end
