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
#import "RegisterViewController.h"

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

- (void)dealloc {
    NSLog(@"LoginViewController 释放");
    [self.loginView removeAllSubviews];
    self.loginView = nil;
    
    self.loginApi = nil;
}

- (void)setupViews {
    [self.loginView.nameField addTarget:self action:@selector(textFieldDidReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.loginView.pwdField addTarget:self action:@selector(textFieldDidReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.loginView.loginBtn addTarget:self action:@selector(loginBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.registerBtn addTarget:self action:@selector(registerBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.loginView resignAllTextField];
}

#pragma mark - functions
#pragma mark 登录服务器
- (void)login {
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
    [SVProgressHUD show];
    [self.loginApi loginWithUserName:name pwd:pwd completion:^(BOOL success, Patient *user, NSString *msg) {
        if (success) {
            [LoginManager defaultManager].currentPatient = user;
            
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

#pragma mark 登录
- (void)loginBtnDidClicked:(id)sender {
    // 登录
    NSLog(@"--------login-----------");
    [self login];
}

#pragma mark 跳转注册页面
- (void)registerBtnDidClicked:(id)sender {
    // 登录
    NSLog(@"--------register-----------");
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RegisterViewController *registe = [story instantiateViewControllerWithIdentifier:@"register"];
        
    [self presentViewController:registe animated:YES completion:^{
        
    }];
}

#pragma mark return 按钮
- (void)textFieldDidReturn:(UITextField *)sender {
    if (sender.tag==111) {
        [self.loginView.pwdField becomeFirstResponder];
    }
    else {
        [self login];
    }
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
