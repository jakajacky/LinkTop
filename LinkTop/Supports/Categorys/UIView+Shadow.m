//
//  UIView+Shadow.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/5.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)

- (void)settingShadowWithDefaultStyle {
    CGFloat radius       = 4;
    CGFloat borderwidth  = 0.5;
    UIColor *borderColor = UIColorHex(#DDDDDD);
    CGSize shadowOffset  = CGSizeMake(0, 1);
    UIColor *shadowColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3];
    
    
    self.layer.cornerRadius = radius;
    [self setLayerShadow:shadowColor offset:shadowOffset radius:radius];
    self.layer.borderWidth = borderwidth;
    self.layer.borderColor = borderColor.CGColor;
}

@end
