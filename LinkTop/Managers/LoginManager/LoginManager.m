//
//  LoginManager.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "LoginManager.h"
#import "LoginAPI.h"
#import "LoginViewController.h"
@interface LoginManager ()
{
    Patient *_currentPatient;
}
@property (nonatomic, strong) LoginAPI *loginAPI;

@end

@implementation LoginManager

//@synthesize currentPatient = _currentPatient;

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

#pragma mark - functions
- (void)shouldShowLoginViewControllerIn:(UIViewController *)viewcontroller {
    // 如果未登录
    if (!self.currentPatient || self.currentPatient.isLastAdd==NO) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        LoginViewController *login = [story instantiateViewControllerWithIdentifier:@"login"];
        
        [viewcontroller presentViewController:login animated:YES completion:^{
            
        }];
    }
}

#pragma mark - properties
- (void)setCurrentPatient:(Patient *)currentPatient {
    
    if (currentPatient==nil) {
        [self.loginAPI deleteCurrentPatientFromMainDB:_currentPatient];
    }
    else {
        _currentPatient = currentPatient;
    }
}

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
