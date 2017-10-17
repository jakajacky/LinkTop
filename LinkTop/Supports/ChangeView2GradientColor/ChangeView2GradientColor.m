//
//  ChangeView2GradientColor.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/16.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "ChangeView2GradientColor.h"
#import <UIKit/UIKit.h>

@implementation ChangeView2GradientColor

#pragma mark - 自定义导航栏子元素
+ (void)changeControllerView:(UIView *)view withNavi:(UINavigationItem *)navigationItem setLeftView:(UIView *)leftview RightView:(UIView *)rightview Title:(UILabel *)title {
    
    UIView *navi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, 44)];
    navigationItem.titleView = navi;
    
    UIButton *head_icon = (UIButton *)leftview;
    
    
    UILabel *title_copy = title;
    
    [navi addSubview:title_copy];
    [navi addSubview:head_icon];
    
    [title_copy autoCenterInSuperview];
}

#pragma mark - 修改导航栏背景色
+ (void)changeView:(UIView *)view toGradientColors:(NSArray *)colors {
  // 添加渐变的颜色组合
  NSMutableArray *colors_ = [NSMutableArray array];
  NSMutableArray *locations = [NSMutableArray array];
  
  float l = 0;
  for (int i = 0; i < colors.count; i++) {
    UIColor *color = colors[i];
    
    [colors_ addObject:(__bridge id)color.CGColor];
    
    if (i == 0) {
      //      [locations addObject:@(0.8)];
    }
    else if (i != colors.count){
      [locations addObject:@(l=(i/(colors.count*1.0)))];
    }
  }
  [locations addObject:@(1.0)];
  
  //创建CGContextRef
  UIGraphicsBeginImageContext(view.bounds.size);
  CGContextRef gc = UIGraphicsGetCurrentContext();
  //创建CGMutablePathRef
  CGMutablePathRef path = CGPathCreateMutable();
  //绘制Path
  CGRect rect = CGRectMake(0, 0, view.width, 64);
  CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
  CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMaxY(rect));
  CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMinY(rect));
  CGPathCloseSubpath(path);
  //绘制渐变
//  [self drawLinearGradient:gc path:path Colors:colors_ locations:locations];
  [self drawLinearGradient:gc path:path startColor:UIColorHex(#1F67B6).CGColor endColor:UIColorHex(#89BDF4).CGColor];
  //注意释放CGMutablePathRef
  CGPathRelease(path);
  //从Context中获取图像，并显示在界面上
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext(); UIGraphicsEndImageContext();
  
  UINavigationBar *bar = (UINavigationBar *)view;
  [bar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
  
}

#pragma mark - 设置多种颜色
+ (void)drawLinearGradient:(CGContextRef)context path:(CGPathRef)path Colors:(NSArray *)colors locations:(NSArray *)locations {
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGFloat *locations_ = malloc(sizeof(CGFloat)*locations.count);
  for (int i = 0; i<locations.count; i++) {
    locations_[i] = [locations[i] floatValue];
  }
  CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations_);
  CGRect pathRect = CGPathGetBoundingBox(path);
  //具体方向可根据需求修改
  CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
  CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
  CGContextSaveGState(context);
  CGContextAddPath(context, path);
  CGContextClip(context);
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
  CGContextRestoreGState(context);
  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
  
}

#pragma mark - 设置首尾两种颜色即可
+ (void)drawLinearGradient:(CGContextRef)context path:(CGPathRef)path startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor {
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  CGFloat locations[] = { 0.2, 1.0 };
  NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
  CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
  CGRect pathRect = CGPathGetBoundingBox(path);
  //具体方向可根据需求修改
  CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
  CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
  CGContextSaveGState(context);
  CGContextAddPath(context, path);
  CGContextClip(context);
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
  CGContextRestoreGState(context);
  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
  
}

@end
