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
        if (!_isPeriperalConnected) {
            [self removeAllSubviews];
            UIButton *unconnectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [unconnectBtn setUserInteractionEnabled:NO];
            unconnectBtn.frame = CGRectMake(0, 0, 60, 20);
            [unconnectBtn setTitle:@"点击连接" forState:UIControlStateNormal];
            [unconnectBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            unconnectBtn.backgroundColor = UIColorHex(#ffffff);
            [unconnectBtn setTintColor:UIColorHex(#4A90E2)];
            unconnectBtn.layer.cornerRadius = 4;
            
            [self addSubview:unconnectBtn];
            
            [unconnectBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
            [unconnectBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [unconnectBtn autoSetDimensionsToSize:CGSizeMake(60, 24)];
        }
        else {
            [self removeAllSubviews];
            UILabel *battery = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 33, 20)];
            battery.text = @"100%";
            battery.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
            battery.textColor = [UIColor whiteColor];
            UIButton *connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [connectBtn setUserInteractionEnabled:NO];
            connectBtn.frame = CGRectMake(40, 0, 15, 20);
            [connectBtn setImage:[UIImage imageNamed:@"ble_icon"] forState:UIControlStateNormal];
            
            [self addSubview:connectBtn];
            [self addSubview:battery];
            
            [connectBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
            [connectBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [battery autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:connectBtn withOffset:-2];
            [battery autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        }
        
        __weak typeof(self) myself = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            if (_connectBlock) {
                self.connectBlock(myself.isPeriperalConnected);
            }
        }];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setIsPeriperalConnected:(BOOL)isPeriperalConnected {
    _isPeriperalConnected = isPeriperalConnected;
    if (!_isPeriperalConnected) {
        [self removeAllSubviews];
        UIButton *unconnectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [unconnectBtn setUserInteractionEnabled:NO];
        unconnectBtn.frame = CGRectMake(0, 0, 60, 20);
        [unconnectBtn setTitle:@"点击连接" forState:UIControlStateNormal];
        [unconnectBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        unconnectBtn.backgroundColor = UIColorHex(#ffffff);
        [unconnectBtn setTintColor:UIColorHex(#4A90E2)];
        unconnectBtn.layer.cornerRadius = 4;
        
        [self addSubview:unconnectBtn];
        
        [unconnectBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [unconnectBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [unconnectBtn autoSetDimensionsToSize:CGSizeMake(60, 24)];
    }
    else {
        [self removeAllSubviews];
        UILabel *battery = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 33, 20)];
        battery.text = @"100%";
        battery.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        battery.textColor = [UIColor whiteColor];
        UIButton *connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [connectBtn setUserInteractionEnabled:NO];
        connectBtn.frame = CGRectMake(40, 0, 15, 20);
        [connectBtn setImage:[UIImage imageNamed:@"ble_icon"] forState:UIControlStateNormal];
        
        [self addSubview:connectBtn];
        [self addSubview:battery];
        
        [connectBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [connectBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [battery autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:connectBtn withOffset:-2];
        [battery autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
    
}

@end
