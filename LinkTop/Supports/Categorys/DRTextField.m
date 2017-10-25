//
//  DRTextField.m
//  Mavic
//
//  Created by XiaoQiang on 2017/7/18.
//  Copyright © 2017年 LoHas-Tech. All rights reserved.
//

#import "DRTextField.h"

@implementation DRTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
  CGRect iconRect = [super leftViewRectForBounds:bounds];
  iconRect.origin.x += 15; //像右边偏15
  return iconRect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
  
  return CGRectInset(bounds, 20, 0);
  
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
  CGRect iconRect = [super rightViewRectForBounds:bounds];
  iconRect.origin.x -= 15; //像右边偏15
  return iconRect;
}

//输入时控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
  
  return CGRectInset(bounds, 20, 0);
}

@end
