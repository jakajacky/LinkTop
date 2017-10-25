
/******************************************************************************
 *  @file   : DCMVVMConfiguration.h
 *  @author : CUI ZHENSONG
 *  @date   : 2015-03-04
 *  @brief  : DCMVVM 基础配置文件
 ******************************************************************************/

#import <Foundation/Foundation.h>

/*!
 *  @brief  DCMVVM 基础配置文件
 */
@interface DCMVVMConfiguration : NSObject

/**
 *  @brief  单例获取 DCMVVMConfiguration 实例
 */
+ (instancetype)getInstance;

#pragma mark -
#pragma mark App Group

/*!
 *  @brief  Application Group ID
 */
@property (nonatomic,copy) NSString *appGroupId;

/*!
 *  @brief  返回 appGroupId 对应的目录路径
 */
- (NSString *)appGroupDirectory;

/*!
 *  @brief  返回 appGroupId 对应目录下 Documents 文件夹的路径
 */
- (NSString *)appGroupDocumentDirectory;

/*!
 *  @brief  返回 appGroupId 对应目录下 Documents 文件夹内指定文件的路径
 *
 *  @param  file 文件名
 */
- (NSString *)appGroupDocumentsPathOfFile:(NSString *)file;

#pragma mark -
#pragma mark HttpRequest Configs

/*!
 *  @brief  是否允许在进行网络请求时打印方法名
 */
@property (nonatomic,assign) BOOL httpRquestAllowsLogMethod;

/*!
 *  @brief  是否允许在进行网络请求时打印请求头
 */
@property (nonatomic,assign) BOOL httpRquestAllowsLogHeader;

/*!
 *  @brief  是否允许在进行 GET 网络请求时打印返回值
 */
@property (nonatomic,assign) BOOL httpRquestAllowsLogResponseGET;

/*!
 *  @brief  是否允许在进行 POST 网络请求时打印返回值
 */
@property (nonatomic,assign) BOOL httpRquestAllowsLogResponsePOST;

/*!
 *  @brief  是否允许在进行网络请求时打印错误信息
 */
@property (nonatomic,assign) BOOL httpRquestAllowsLogRequestError;

#pragma mark -
#pragma mark Database Configs

/*!
 *  @brief  数据库是否需要加密
 */
@property (nonatomic,assign) BOOL databaseShouldEncrypt;

/*!
 *  @brief  是否允许在数据库操作时打印操作语句
 */
@property (nonatomic,assign) BOOL databaseAllowsLogStatement;

/*!
 *  @brief  是否允许在数据库操作时打印错误信息
 */
@property (nonatomic,assign) BOOL databaseAllowsLogError;

@end
