//
//  UIAlertController+Element.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/2.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "UIAlertController+Element.h"

@implementation UIAlertController (Element)


- (void)setMessageColor:(UIColor *)color Font:(UIFont *)font {
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:self.message];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.message.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.message.length)];
    [self setValue:alertControllerMessageStr forKey:@"attributedMessage"];
}

@end
