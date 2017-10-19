//
//  DRNavigationBar.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/18.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LeftViewBlock)(void);
typedef void(^RightViewBlock)(void);

@interface DRNavigationBar : UIView

@property (nonatomic, copy) LeftViewBlock leftViewDidClicked;
@property (nonatomic, copy) RightViewBlock rightViewDidClicked;

- (instancetype)initWithFrame:(CGRect)frame
                    LeftImage:(UIImage *)l_img
                    LeftTitle:(NSString *)l_title
                  MiddleImage:(UIImage *)m_img
                  MiddleTitle:(NSString *)m_title
                   RightImage:(UIImage *)r_img
                   RightTitle:(NSString *)r_title;

@end
