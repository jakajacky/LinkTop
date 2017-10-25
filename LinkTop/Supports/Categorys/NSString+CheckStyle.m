//
//  NSString+CheckStyle.m
//  Mavic
//
//  Created by zhangxiaoqiang on 2017/3/31.
//  Copyright © 2017年 LoHas-Tech. All rights reserved.
//

#import "NSString+CheckStyle.h"

@implementation NSString (CheckStyle)

- (BOOL)isValidPhoneNumber
{
    NSString *regex = @"^((\\+86)|(86))?((13|15|18|14|17)[0-9]{9})$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isNumberString {
  const char *string = [self UTF8String];
  for (int i = 0; i<self.length; i++) {
    char sub = string[i];
    if (sub>=48 && sub<=57) {
      
    }
    else {
      return NO;
    }
  }
  return YES;
}

@end
