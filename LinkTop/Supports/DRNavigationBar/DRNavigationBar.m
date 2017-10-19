//
//  DRNavigationBar.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/18.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "DRNavigationBar.h"

@interface DRNavigationBar ()

@end

@implementation DRNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
                    LeftImage:(UIImage *)l_img
                    LeftTitle:(NSString *)l_title
                  MiddleImage:(UIImage *)m_img
                  MiddleTitle:(NSString *)m_title
                   RightImage:(UIImage *)r_img
                   RightTitle:(NSString *)r_title {
    self = [super initWithFrame:frame];
    if (self) {
        // iOS7之后，设置状态栏和导航栏统一背景色，是很简单的，但是渐变颜色又是特殊的一种
        [ChangeView2GradientColor changeView:self toGradientColors:@[UIColorHex(#1F67B6),UIColorHex(#51A8F2),UIColorHex(#89BDF4),UIColorHex(#C1E4FE)]];
        
        [self setupLeftViewsWithImage:l_img Title:l_title];
        [self setupMiddleViewsWithImage:m_img Title:m_title];
        [self setupRightViewsWithImage:r_img Title:r_title];
        
    }
    return self;
}

- (void)setupLeftViewsWithImage:(UIImage *)image Title:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 20, 100, 44);
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10.8, 18)];
    icon.image = image;
    
    UILabel *titleL   = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 21)];
    titleL.textColor = UIColorHex(#ffffff);
    titleL.text = title;
    
    [view addSubview:icon];
    [view addSubview:titleL];
    [self addSubview:view];
    
    // view加约束
    [view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [view autoSetDimensionsToSize:CGSizeMake(self.width/3.0, 44)];
    
    // icon加约束
    [icon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [icon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // titleL加约束
    [titleL autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:icon withOffset:5];
    [titleL autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (_leftViewDidClicked) {
            self.leftViewDidClicked();
        }
    }];
    [view addGestureRecognizer:tap];
}

- (void)setupMiddleViewsWithImage:(UIImage *)image Title:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 20, 100, 44);
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10.8, 18)];
    icon.image = image;
    
    UILabel *titleL   = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 21)];
    titleL.textColor = UIColorHex(#ffffff);
    titleL.text = title;
    
    [view addSubview:icon];
    [view addSubview:titleL];
    [self addSubview:view];
    
    CGSize size = [titleL.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    CGFloat margin = 5;
    
    // view加约束
    [view autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [view autoSetDimensionsToSize:CGSizeMake(icon.width+margin+size.width, 44)];
    
    // icon加约束
    [icon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [icon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // titleL加约束
    [titleL autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:icon withOffset:margin];
    [titleL autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
}

- (void)setupRightViewsWithImage:(UIImage *)image Title:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 20, 100, 44);
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10.8, 18)];
    icon.image = image;
    
    UILabel *titleL   = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 21)];
    titleL.textColor = UIColorHex(#ffffff);
    titleL.text = title;
    
    [view addSubview:icon];
    [view addSubview:titleL];
    [self addSubview:view];
    
    // view加约束
    [view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [view autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [view autoSetDimensionsToSize:CGSizeMake(self.width/3.0, 44)];
    
    // icon加约束
    [icon autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [icon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // titleL加约束
    [titleL autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:icon withOffset:-5];
    [titleL autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (_rightViewDidClicked) {
            self.rightViewDidClicked();
        }
    }];
    [view addGestureRecognizer:tap];
}

- (void)dealloc {
    NSLog(@"DRNavigationBar释放");
}

@end
