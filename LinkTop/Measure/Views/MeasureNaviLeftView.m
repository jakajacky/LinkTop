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
        
        UILabel *name = [[UILabel alloc] init];
        name.frame = CGRectMake(0, 0, 102, 20);
        name.text = @"18515982821";
        name.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        name.textColor = [UIColor whiteColor];
        
        
        [self addSubview:head_icon];
        [self addSubview:name];
        
        [name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:head_icon withOffset:8];
        [name autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
    return self;
}

@end
