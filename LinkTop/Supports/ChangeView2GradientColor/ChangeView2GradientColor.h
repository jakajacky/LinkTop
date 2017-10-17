//
//  ChangeView2GradientColor.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/16.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeView2GradientColor : NSObject

+ (void)changeControllerView:(UIView *)view withNavi:(UINavigationItem *)navigationItem setLeftView:(UIView *)leftview RightView:(UIView *)rightview Title:(UILabel *)title;

+ (void)changeView:(UIView *)view toGradientColors:(NSArray *)colors;

@end
