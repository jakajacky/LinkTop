//
//  LoginManager.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "LoginManager.h"
#import "LoginAPI.h"

@interface LoginManager ()

@property (nonatomic, strong) LoginAPI *loginAPI;

@end

@implementation LoginManager

static LoginManager *loginM = nil;

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginM = [[self alloc] init];
    });
    return loginM;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if (!loginM) {
            loginM = [super allocWithZone:zone];
        }
        return loginM;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - properties
- (Patient *)currentPatient {
    if (!_currentPatient) {
        _currentPatient = [self.loginAPI getCurrentPatientFormMainDB];
    }
    return _currentPatient;
}

- (LoginAPI *)loginAPI {
    if (!_loginAPI) {
        _loginAPI = [LoginAPI biz];
    }
    return _loginAPI;
}



@end
