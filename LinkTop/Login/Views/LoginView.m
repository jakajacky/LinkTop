//
//  LoginView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self reloadViews];
}

- (void)reloadViews {
    CGSize shadowOffset  = CGSizeMake(0, 1);
    UIColor *shadowColor = UIColorHex(#333333);
    
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
    
    self.pwdField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd_icon"]];
    self.nameField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tel_icon"]];
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdField.secureTextEntry = YES;
    

    shadowColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.3];
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.layer.borderWidth = 0.5;
    self.loginBtn.layer.borderColor = (__bridge CGColorRef)([UIColor colorWithWhite:1 alpha:0.6]);
    [self.loginBtn.layer setLayerShadow:shadowColor offset:shadowOffset radius:4];
    
}

@end
