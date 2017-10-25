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
@property (copy) NSString *login_name;
@property (copy) NSString *name;//" : "18515982821",
@property (copy) NSString *mobile;//" : "18515982821",

@property (copy) NSString *gender;//" : "男",
@property (copy) NSString  *age;//" : 43,
@property        NSInteger height;//" : 170,
@property        NSInteger weight;//" : 70,
@property (copy) NSString *birth;

@property (copy) NSString *APP_TOKEN;
@property        long long APP_KEY;

@property        BOOL      isLastAdd;

//- (instancetype)initWithUser:(User *)user;

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


@property (copy) NSString *Id;
@property (copy) NSString *patient_id;
@property        long long measure_time;
@property        long long createTime;
@property        CGFloat   l_pwv;
@property        CGFloat   r_pwv;
@property        CGFloat   l_ptt;
@property        CGFloat   r_ptt;
@property        NSInteger qualified_L;
@property        NSInteger qualified_R;
@property (copy) NSString *hr_list;
@property (copy) NSString *pwv_list;
@property (copy) NSString *la_q_list;
@property (copy) NSString *la_i_list;
@property (copy) NSString *ll_q_list;
@property (copy) NSString *ll_i_list;
@property (copy) NSString *ra_q_list;
@property (copy) NSString *ra_i_list;
@property (copy) NSString *rl_q_list;
@property (copy) NSString *rl_i_list;

@property        BOOL     isSent;


NS_ASSUME_NONNULL_END

@end
