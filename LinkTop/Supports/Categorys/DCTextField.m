//
//  DCTextField.m
//  Mavic
//
//  Created by zhangxiaoqiang on 2017/3/30.
//  Copyright © 2017年 LoHas-Tech. All rights reserved.
//

#import "DCTextField.h"

@implementation DCTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 12; //像右边偏15
    return iconRect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 40, 0);
    
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super rightViewRectForBounds:bounds];
    iconRect.origin.x -= 15; //像右边偏15
    return iconRect;
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 40, 0);
}

@end
