//
//  RegisterViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/26.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"
#import "RegisterAPI.h"

@interface RegisterViewController ()

@property (nonatomic, strong) RegisterView *registerView;
@property (nonatomic, strong) RegisterAPI *registerAPI;

@end

@implementation RegisterViewController

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
    NSLog(@"RegisterViewController 释放");
    [self.registerView removeAllSubviews];
    self.registerView = nil;
}

- (void)setupViews {
    [self.registerView.loginBtn addTarget:self action:@selector(loginBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.registerView.registerBtn addTarget:self action:@selector(registerBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.registerView.nameField addTarget:self action:@selector(textFieldDidReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.registerView.pwdField addTarget:self action:@selector(textFieldDidReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.registerView.pwdTField addTarget:self action:@selector(textFieldDidReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

#pragma mark - 注册逻辑
- (void)registers {
    NSString *name = self.registerView.nameField.text.stringByTrim;
    NSString *pwd  = self.registerView.pwdField.text.stringByTrim;
    NSString *pwdT = self.registerView.pwdTField.text.stringByTrim;
    if (![pwd isEqualToString:pwdT]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
        return;
    }
    [SVProgressHUD show];
    [self.registerAPI registerWithPhone:name pwd:pwd compeletion:^(BOOL success, id result) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [SVProgressHUD dismissWithDelay:1.5];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"注册失败"];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}

#pragma mark - 按钮事件
#pragma mark  跳转登录
- (void)loginBtnDidClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark  点击注册
- (void)registerBtnDidClicked:(id)sender {
    [self registers];
}

#pragma mark return 按钮
- (void)textFieldDidReturn:(UITextField *)sender {
    if (sender.tag==111) {
        [self.registerView.pwdField becomeFirstResponder];
    }
    else if (sender.tag==112) {
        [self.registerView.pwdTField becomeFirstResponder];
    }
    else {
        // 注册
        NSLog(@"---------register---------");
        [self registers];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.registerView resignAllTextField];
}

#pragma mark - properties
- (RegisterView *)registerView {
    if (!_registerView) {
        _registerView = (RegisterView *)self.view;
    }
    return _registerView;
}

- (RegisterAPI *)registerAPI {
    if (!_registerAPI) {
        _registerAPI = [RegisterAPI biz];
    }
    return _registerAPI;
}

@end
