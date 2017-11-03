//
//  CommonEntities.h
//  Mavic
//
//  Created by zhangxiaoqiang on 2017/4/5.
//  Copyright © 2017年 LoHas-Tech. All rights reserved.
//

#import "DCObject.h"
#import "DCDatabaseObject.h"

typedef enum : NSUInteger {
    UnKnown,
    L_T_Aid,
    L_B_Aid,
    R_T_Aid,
    R_B_Aid,
} Location;

typedef enum : NSUInteger {
    MTBloodPresure,
    MTTemperature,
    MTSpo2h,
    MTHeartRate,
    MTECG,
    MTRothmanIndex,
} MeasureType;

@interface Peripheral : DCDatabaseObject

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong) NSString *macString;
@property (nonatomic)         Location location;
@property (nonatomic, strong) NSString *identifier NS_AVAILABLE(NA, 7_0);
@property (nonatomic, strong) NSString *name;
@property (nonatomic)         CBPeripheralState   state;
@property (nonatomic, strong) NSString *serviceUUID;

@property (nonatomic)         NSInteger battery;

- (instancetype)initWithCBPeripheral:(CBPeripheral *)peripheral;

NS_ASSUME_NONNULL_END

@end

@interface Patient : DCDatabaseObject

NS_ASSUME_NONNULL_BEGIN


@property (copy) NSString *Id;
@property (copy) NSString *user_id;
@property (copy) NSString *login_name;
@property (copy) NSString *password;

@property (copy) NSString *gender;//" : "男",
@property        NSInteger age;//" : 43,
@property        NSInteger height;//" : 170,
@property        NSInteger weight;//" : 70,
@property (copy) NSString *birth;

@property (copy) NSString *APP_TOKEN;
@property        long long APP_KEY;

@property        BOOL      isLastAdd;
@property        BOOL      is_quest;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

NS_ASSUME_NONNULL_END

@end

@interface Doctor : DCDatabaseObject

NS_ASSUME_NONNULL_BEGIN


@property (copy) NSString *Id;
@property (copy) NSString *name;//" : "",
@property (copy) NSString *orgnizationl;
@property (copy) NSString *hospital;

@property        long long createTime;

@property (copy) NSString *mobile;//" : "18515982821",

@property (copy) NSString *gender;//" : "男",

- (instancetype)initWithName:(NSString *)name Orgnization:(NSString *)org Hospital:(NSString *)hos;

NS_ASSUME_NONNULL_END

@end

@interface DiagnosticList : DCDatabaseObject

NS_ASSUME_NONNULL_BEGIN


@property (copy) NSString *Id;           // 数据标识
@property (copy) NSString *user_id;      // 用户标识
@property        long long measure_time; // 测量时间
@property        long long create_date;  // 服务器返回
@property        NSInteger ri;
@property (copy) NSString *sbp;
@property (copy) NSString *dbp;
@property (copy) NSString *spo2h;
@property (copy) NSString *temp;
@property (copy) NSString *hr;
@property (copy) NSString *respiration;
@property (copy) NSString *device_id;
@property (copy) NSString *ecg_raw;
@property        NSInteger ecg_freq;
@property (copy) NSString  *spo2h_raw    ;
@property        NSInteger spo2h_freq;
@property        NSInteger rr;
@property        NSInteger rr_max;
@property        NSInteger rr_min;
@property        NSInteger mood;
@property        NSInteger hrv;
@property        NSInteger device_power;

@property (copy) NSString *device_key;
@property (copy) NSString *device_soft_ver;
@property (copy) NSString *device_hard_ver;

@property        MeasureType type;

@property        BOOL     isSent;


NS_ASSUME_NONNULL_END

@end
