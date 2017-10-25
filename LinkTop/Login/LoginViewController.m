//
//  LoginViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "LoginAPI.h"

@interface LoginViewController ()

@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) LoginAPI *loginApi;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    [self.loginView.pwdField addTarget:self action:@selector(textFieldDidReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.loginView.loginBtn addTarget:self action:@selector(loginBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.loginView resignAllTextField];
}

#pragma mark - functions
#pragma mark 登录服务器
- (void)login:(void(^)(BOOL success, NSString *msg))complete {
    NSString *name = self.loginView.nameField.text.stringByTrim;
    NSString *pwd  = self.loginView.pwdField.text.stringByTrim;
    if (name.length<=0) {
        [SVProgressHUD showInfoWithStatus:@"帐号不能为空"];
        return;
    }
    else if (pwd.length<=0) {
        [SVProgressHUD showInfoWithStatus:@"密码不能为空"];
        return;
    }
    [self.loginApi loginWithUserName:name pwd:pwd completion:^(BOOL success, Patient *user, NSString *msg) {
        if (success) {
            [LoginManager defaultManager].currentPatient = user;
        }
        complete(success,msg);
    }];
}

#pragma mark 登录
- (void)loginBtnDidClicked:(id)sender {
    // 登录
    NSLog(@"--------login-----------");
    [SVProgressHUD show];
    [self login:^(BOOL success,NSString *msg) {
        if (success) {
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            // tip
            [SVProgressHUD showErrorWithStatus:@"帐号或密码错误"];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}

#pragma mark return 按钮
- (void)textFieldDidReturn:(id)sender {
    // 登录
    NSLog(@"--------login-----------");
    [SVProgressHUD show];
    [self login:^(BOOL success,NSString *msg) {
        if (success) {
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            // tip
            [SVProgressHUD showErrorWithStatus:@"帐号或密码错误"];
        }
    }];
}

#pragma mark - properties
- (LoginView *)loginView {
    if (!_loginView) {
        _loginView = (LoginView *)self.view;
    }
    return _loginView;
}

- (LoginAPI *)loginApi {
    if (!_loginApi) {
        _loginApi = [LoginAPI biz];
    }
    return _loginApi;
}

@end
