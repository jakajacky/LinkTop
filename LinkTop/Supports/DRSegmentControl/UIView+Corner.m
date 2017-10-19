//
//  UIView+Corner.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/19.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "UIView+Corner.h"

@implementation UIView (Corner)

#pragma mark - 灵活设置view的圆角
- (void)setViewCorner:(CGFloat)radius byRoundingCorners:(UIRectCorner)corner {
    UIBezierPath *maskPath  = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                    byRoundingCorners:corner
                                                          cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
}

@end
