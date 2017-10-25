//
//  DebugConfig.h
//  Mavic
//
//  Created by zhangxiaoqiang on 2017/3/30.
//  Copyright © 2017年 LoHas-Tech. All rights reserved.
//

#ifndef DebugConfig_h
#define DebugConfig_h

#ifdef DEBUG
// NSLog(__VA_ARGS__)
#define EZLog(...) NSLog(__VA_ARGS__)
#else
#define EZLog(...)
#endif


#define kLogEnabled      1
#define kIConsoleEnabled 0

#define kRecordResult    1    // 保存原始数据和补包后的文件
#define kRecordLogs      0    // 保存16进制原始数据txt日志开关
#define kRecordCSVLogs   0     // 保存csv文件 不推出结果页面 开关

#define kNotAllowSingleD    1  // 不允许单个设备开始

#define kFilterPeripheral   0  // 选择模块时 过滤设备

#define kNeedCheckAsyn      0  // 需要检查模块同步是否成功

#define kSmoothDrawing      0  // 开启平滑画波 代价是波形延迟

#define kRecordTimestamp    0  // 杨姐需要记录同步时间戳、

#define kResultNeedLogs     0  // 正常流程，出结果页的时候，是否需要记录日志到本地

#define kNeedEncryptDatabase 0 // 数据库是否加密

#if kLogEnabled
#if kIConsoleEnabled
#import "iConsole.h"
#define NSLog(fmt, ...) [iConsole log:(fmt),##__VA_ARGS__]
#endif
#else
#define NSLog(fmt, ...)
#endif

/**
 *  HttpRequest Configs
 */
#define kHttpRequestAllowsLogMethod       YES
#define kHttpRequestAllowsLogHeader       YES

#define kHttpRequestAllowsLogResponseGET  YES
#define kHttpRequestAllowsLogResponsePOST YES
#define kHttpRequestAllowsLogResponseHEAD YES

#define kHttpRequestAllowsLogRequestError YES

/**
 *  Database Configs
 */
#define kDatabaseShouldEncrypt            NO
#define kDatabaseAllowsLogStatement       YES
#define kDatabaseAllowsLogError           YES

#define kAppGroupIdentifier @"group.lohas.LinkTop"

#endif /* DebugConfig_h */
