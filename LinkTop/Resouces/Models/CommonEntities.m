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
        _Id         = dictionary[@"Id"];
        _user_id    = dictionary[@"user_id"];
        _login_name = dictionary[@"login_name"];
        _password   = dictionary[@"password"];
        _gender     = dictionary[@"gender"];
        _age        = [dictionary[@"age"] intValue];
        _birth      = dictionary[@"birth"];
        _height     = [dictionary[@"height"] integerValue];
        _weight     = [dictionary[@"weight"] integerValue];
        _APP_KEY    = [dictionary[@"APP_KEY"] longLongValue];
        _APP_TOKEN  = dictionary[@"APP_TOKEN"];
        _is_quest   = [dictionary[@"is_quest"] boolValue];
        _isLastAdd  = [dictionary[@"isLastAdd"] boolValue];
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
    _Id            = dictionary[@"Id"];
    _user_id       = dictionary[@"user_id"];
    _measure_time  = [dictionary[@"measure_time"] longLongValue];
    _create_date   = [dictionary[@"create_date"] longLongValue];
    _ri            = [dictionary[@"ri"] integerValue];
    _sbp           = dictionary[@"sbp"];
    _dbp           = dictionary[@"dbp"];
    _spo2h         = dictionary[@"spo2h"];
    _temp          = dictionary[@"temp"];
    _hr            = dictionary[@"hr"];
    _respiration   = dictionary[@"respiration"];
    _device_id     = dictionary[@"device_id"];
    _ecg_raw       = dictionary[@"ecg_raw"];
    _ecg_freq      = [dictionary[@"ecg_freq"] integerValue];
    _spo2h_raw     = dictionary[@"spo2h_raw"];
    _spo2h_freq    = [dictionary[@"spo2h_freq"] integerValue];
    _rr            = [dictionary[@"rr"] integerValue];
    _rr_max        = [dictionary[@"rr_max"] integerValue];
    _rr_min        = [dictionary[@"rr_min"] integerValue];
    _mood          = [dictionary[@"mood"] integerValue];
    _hrv           = [dictionary[@"hrv"] integerValue];
    _device_power  = [dictionary[@"device_power"] integerValue];
    _device_key    = dictionary[@"device_key"];
    _device_soft_ver = dictionary[@"device_soft_ver"];
    _device_hard_ver = dictionary[@"device_hard_ver"];
    _isSent          = [dictionary[@"isSent"] boolValue];
    _type            = [dictionary[@"type"] integerValue];
  }
  return self;
}

@end
