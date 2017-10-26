//
//  LoginView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "LoginView.h"
#import "UITextField+YYAdd.h"
#import "UIImage+memory.h"
@interface LoginView ()<UITextFieldDelegate>
{
    BOOL _isLoginBtnSelected;
    BOOL _isKboradAppear;
    CGRect _oldFrame;
    CGRect _newFrame;
    
}
@end

@implementation LoginView

- (void)awakeFromNib {
    [super awakeFromNib];
    _isLoginBtnSelected = YES;
    [self reloadViews];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboradWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboradWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(keyboradDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(registerSuccess:) name:RegisterSuccessNotification object:nil];
}

- (void)dealloc {
    NSLog(@"LoginView 释放");
    ((UIImageView *)self.nameField.leftView).image = nil;
    [self.nameField removeAllSubviews];
    self.nameField = nil;
    
    ((UIImageView *)self.pwdField.leftView).image = nil;
    [self.pwdField removeAllSubviews];
    self.pwdField = nil;
    
    self.loginBtn = nil;
    self.forgetPwdBtn = nil;
    self.registerBtn = nil;
    self.bgView.image = nil;
    self.bgView = nil;
    self.logoView.image = nil;
    self.logoView = nil;
}

- (void)reloadViews {
    CGSize shadowOffset  = CGSizeMake(0, 1);
    UIColor *shadowColor = UIColorHex(#333333);
    
    self.bgView.image = [UIImage imageWithMName:@"bg.png"];
    self.logoView.image = [UIImage imageWithMName:@"corp_img.png"];
    
    // 登录表单
    self.nameField.layer.cornerRadius = 4;
    self.nameField.borderStyle = 0;
    self.nameField.tag = 111;
    self.nameField.layer.borderWidth = 0.5;
    self.nameField.layer.borderColor = (__bridge CGColorRef)([UIColor colorWithWhite:1 alpha:0.6]);
    self.nameField.backgroundColor = UIColorHex(#ffffff);
    [self.nameField.layer setLayerShadow:shadowColor offset:shadowOffset radius:4];
    
    self.pwdField.layer.cornerRadius = 4;
    self.pwdField.borderStyle = 0;
    self.pwdField.tag = 112;
    self.pwdField.layer.borderWidth = 0.5;
    self.pwdField.layer.borderColor = (__bridge CGColorRef)([UIColor cyanColor]);
    self.pwdField.backgroundColor = UIColorHex(#ffffff);
    [self.pwdField.layer setLayerShadow:shadowColor offset:shadowOffset radius:4];
    
    self.pwdField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageWithMName:@"pwd_icon"]];
    self.nameField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageWithMName:@"tel_icon"]];
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdField.secureTextEntry = YES;
    

    shadowColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.3];
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.layer.borderWidth = 0.5;
    self.loginBtn.layer.borderColor = (__bridge CGColorRef)([UIColor colorWithWhite:1 alpha:0.6]);
    [self.loginBtn.layer setLayerShadow:shadowColor offset:shadowOffset radius:4];
    
}

#pragma mark - 监听键盘事件
- (void)keyboradWillAppear:(NSNotification *)notifi {
    
    if (_isKboradAppear) {
        
        return;
    }
    _isKboradAppear = YES;
    
    CGRect kb_frame   = [notifi.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    _oldFrame = self.frame;
    
    self.transform = CGAffineTransformMakeTranslation(0, -90);
}

- (void)keyboradWillDisappear:(NSNotification *)notifi {
    _isKboradAppear = NO;
    self.transform = CGAffineTransformMakeTranslation(0, 0);
    
}

- (void)keyboradDidAppear:(NSNotification *)notifi {
    if (_nameField.editing) {
        [_nameField selectAll:self];
    }
    if (self.nameField.editing) {
        [self.nameField selectAllText];
    }
}

- (void)resignAllTextField {
    [self.nameField resignFirstResponder];
    [self.pwdField resignFirstResponder];
}

@end
