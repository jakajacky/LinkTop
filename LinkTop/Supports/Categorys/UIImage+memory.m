//
//  UIImage+memory.m
//  Mavic
//
//  Created by XiaoQiang on 2017/4/25.
//  Copyright © 2017年 LoHas-Tech. All rights reserved.
//

#import "UIImage+memory.h"

#define recourcesPath [[NSBundle mainBundle] resourcePath]

@implementation UIImage (memory)

+ (UIImage *)imageWithMName:(NSString *)name {
    NSString * imageFile
    = [[NSString alloc] initWithFormat:@"%@/%@",recourcesPath, name];
    
    UIImage
    * tempImage = nil;
    
    tempImage = [[UIImage alloc] initWithContentsOfFile:imageFile];
    
    imageFile = nil;
    
    return tempImage;
}

@end
