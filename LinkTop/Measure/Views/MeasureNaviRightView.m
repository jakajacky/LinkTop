//
//  MeasureNaviRightView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/17.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "MeasureNaviRightView.h"

@implementation MeasureNaviRightView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *battery = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 33, 20)];
        battery.text = @"100%";
        battery.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        battery.textColor = [UIColor whiteColor];
        UIButton *connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        connectBtn.frame = CGRectMake(40, 0, 15, 20);
        [connectBtn setImage:[UIImage imageNamed:@"ble_icon"] forState:UIControlStateNormal];
        
        [self addSubview:connectBtn];
        [self addSubview:battery];
        
        [connectBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [connectBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [battery autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:connectBtn withOffset:-2];
        [battery autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
    return self;
}

@end
