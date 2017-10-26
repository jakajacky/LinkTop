//
//  MeasureNaviLeftView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/17.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "MeasureNaviLeftView.h"

@implementation MeasureNaviLeftView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *head_icon = [UIButton buttonWithType:UIButtonTypeCustom];
        [head_icon setImage:[UIImage imageNamed:@"Oval"] forState:UIControlStateNormal];
        head_icon.frame = CGRectMake(0, 4, 36, 36);
        
        _name = [[UILabel alloc] init];
        _name.frame = CGRectMake(0, 0, 102, 20);
        _name.text = @"-";
        _name.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _name.textColor = [UIColor whiteColor];
        
        
        [self addSubview:head_icon];
        [self addSubview:_name];
        
        [_name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:head_icon withOffset:8];
        [_name autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
    return self;
}

@end
