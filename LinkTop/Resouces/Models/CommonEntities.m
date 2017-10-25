//
//  CommonEntities.m
//  Mavic
//
//  Created by zhangxiaoqiang on 2017/4/5.
//  Copyright © 2017年 LoHas-Tech. All rights reserved.
//

#import "CommonEntities.h"

@implementation Peripheral

+ (NSArray *)primaryKeys {
    return @[@"macString", @"identifier", @"location"];
}

- (instancetype)initWithCBPeripheral:(CBPeripheral *)peripheral {
    self = [super init];
    
    if (self) {
        _name        = peripheral.name;
        _state       = peripheral.state;
        _identifier  = peripheral.identifier.UUIDString;
        _serviceUUID = @"0003CDD0-0000-1000-8000-00805F9B0131";
    }
    
    return self;
}

@end


@implementation Patient

+ (NSArray *)primaryKeys {
    return @[@"Id"];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        _name = dictionary[@"name"];
        _mobile = dictionary[@"mobile"];
        _gender = dictionary[@"gender"];
        _age    = dictionary[@"age"]==[NSNull null]?@"0":dictionary[@"age"];
        _birth  = dictionary[@"birth"];
        _height = [dictionary[@"height"] integerValue];
        _weight = [dictionary[@"weight"] integerValue];
    }
    return self;
}

//- (instancetype)initWithUser:(User *)user {
//    self = [super init];
//    if (self) {
//        _Id     = user.Id;
//        _name   = user.name;
//        _mobile = user.mobile;
//        _gender = user.gender;
//        _age    = [NSString stringWithFormat:@"%@ (%ld)", user.birth, user.age];
//        _height = user.height;
//        _weight = user.weight;
//    }
//    return self;
//}

@end

@implementation Doctor

+ (NSArray *)primaryKeys {
  return @[@"Id"];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  self = [super initWithDictionary:dictionary];
  if (self) {
    _name = dictionary[@"name"];
    _mobile = dictionary[@"mobile"];
    _gender = dictionary[@"gender"];
  }
  return self;
}

- (instancetype)initWithName:(NSString *)name Orgnization:(NSString *)org Hospital:(NSString *)hos {
  self = [super init];
  if (self) {
    _Id     = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    _name   = name;
    _orgnizationl = org;
    _hospital = hos;
    _createTime = [[NSDate date] timeIntervalSince1970];
  }
  return self;
}

@end

@implementation DiagnosticList

+ (NSArray *)primaryKeys {
  return @[@"Id"];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  self = [super initWithDictionary:dictionary];
  if (self) {
    _Id           = dictionary[@"Id"];
    _patient_id   = dictionary[@"patient_id"];
    _measure_time = [dictionary[@"measure_time"] longLongValue];
    _createTime   = [dictionary[@"createTime"] longLongValue];
    _l_pwv        = [dictionary[@"l_pwv"] floatValue];
    _r_pwv        = [dictionary[@"r_pwv"] floatValue];
    _l_ptt        = [dictionary[@"l_ptt"] floatValue];
    _r_ptt        = [dictionary[@"r_ptt"] floatValue];
    _qualified_L  = [dictionary[@"qualified_L"] integerValue];
    _qualified_R  = [dictionary[@"qualified_R"] integerValue];
    _hr_list      = dictionary[@"hr_list"];
    _pwv_list     = dictionary[@"pwv_list"];
    _la_q_list    = dictionary[@"la_q_list"];
    _la_i_list    = dictionary[@"la_i_list"];
    _ll_q_list    = dictionary[@"ll_q_list"];
    _ll_i_list    = dictionary[@"ll_i_list"];
    _ra_q_list    = dictionary[@"ra_q_list"];
    _ra_i_list    = dictionary[@"ra_i_list"];
    _rl_q_list    = dictionary[@"rl_q_list"];
    _rl_i_list    = dictionary[@"rl_i_list"];
    _isSent       = [dictionary[@"isSent"] boolValue];
  }
  return self;
}

@end
