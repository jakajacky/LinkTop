//
//  DRNavigationBar.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/18.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "DRNavigationBar.h"

@interface DRNavigationBar ()

@property (nonatomic, strong) UIImageView *icon_l;
@property (nonatomic, strong) UIImageView *icon_m;
@property (nonatomic, strong) UIImageView *icon_r;

@property (nonatomic, strong) UIView *view_l;
@property (nonatomic, strong) UIView *view_m;
@property (nonatomic, strong) UIView *view_r;

@property (nonatomic, strong) UILabel *titleL_l;
@property (nonatomic, strong) UILabel *titleL_m;
@property (nonatomic, strong) UILabel *titleL_r;

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
    _view_l = [[UIView alloc] init];
    _view_l.frame = CGRectMake(0, 20, 100, 44);
    
    _icon_l = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10.8, 18)];
    _icon_l.image = image;
    
    _titleL_l   = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 21)];
    _titleL_l.textColor = UIColorHex(#ffffff);
    _titleL_l.text = title;
    
    [_view_l addSubview:_icon_l];
    [_view_l addSubview:_titleL_l];
    [self addSubview:_view_l];
    
    // view加约束
    [_view_l autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [_view_l autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [_view_l autoSetDimensionsToSize:CGSizeMake(self.width/3.0, 44)];
    
    // icon加约束
    [_icon_l autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [_icon_l autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // titleL加约束
    [_titleL_l autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_icon_l withOffset:5];
    [_titleL_l autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (_leftViewDidClicked) {
            self.leftViewDidClicked();
        }
    }];
    [_view_l addGestureRecognizer:tap];
}

- (void)setupMiddleViewsWithImage:(UIImage *)image Title:(NSString *)title {
    _view_m = [[UIView alloc] init];
    _view_m.frame = CGRectMake(0, 20, 100, 44);
    
    _icon_m = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10.8, 18)];
    _icon_m.image = image;
    
    _titleL_m   = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 21)];
    _titleL_m.textColor = UIColorHex(#ffffff);
    _titleL_m.text = title;
    
    [_view_m addSubview:_icon_m];
    [_view_m addSubview:_titleL_m];
    [self addSubview:_view_m];
    
    CGSize size = [_titleL_m.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    CGFloat margin = 5;
    
    // view加约束
    [_view_m autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_view_m autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [_view_m autoSetDimensionsToSize:CGSizeMake(_icon_m.width+margin+size.width, 44)];
    
    // icon加约束
    [_icon_m autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [_icon_m autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // titleL加约束
    [_titleL_m autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_icon_m withOffset:margin];
    [_titleL_m autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
}

- (void)setupRightViewsWithImage:(UIImage *)image Title:(NSString *)title {
    _view_r = [[UIView alloc] init];
    _view_r.frame = CGRectMake(0, 20, 100, 44);
    
    _icon_r = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10.8, 18)];
    _icon_r.image = image;
    
    _titleL_r   = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 21)];
    _titleL_r.textColor = UIColorHex(#ffffff);
    _titleL_r.text = title;
    
    [_view_r addSubview:_icon_r];
    [_view_r addSubview:_titleL_r];
    [self addSubview:_view_r];
    
    // view加约束
    [_view_r autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [_view_r autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [_view_r autoSetDimensionsToSize:CGSizeMake(self.width/3.0, 44)];
    
    // icon加约束
    [_icon_r autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [_icon_r autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // titleL加约束
    [_titleL_r autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_icon_r withOffset:-5];
    [_titleL_r autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (_rightViewDidClicked) {
            self.rightViewDidClicked();
        }
    }];
    [_view_r addGestureRecognizer:tap];
}

- (void)dealloc {
    NSLog(@"DRNavigationBar释放");
    _icon_r.image = nil;
    _icon_m.image = nil;
    _icon_l.image = nil;
    
    _icon_l = nil;
    _icon_m = nil;
    _icon_r = nil;
    
    _view_r = nil;
    _view_m = nil;
    _view_l = nil;
    
    _titleL_l = nil;
    _titleL_m = nil;
    _titleL_r = nil;
}

@end
