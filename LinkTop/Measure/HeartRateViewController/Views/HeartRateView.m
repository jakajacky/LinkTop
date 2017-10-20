//
//  HeartRateView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/20.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "HeartRateView.h"

@implementation HeartRateView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat naviHeight = 64;
    if (iPhoneX) {
        naviHeight = 88;
    }
    
    _navi = [[DRNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.width, naviHeight)
                                         LeftImage:[UIImage imageNamed:@"back_icon"]
                                         LeftTitle:@""
                                       MiddleImage:[UIImage imageNamed:@"heartRate_icon"]
                                       MiddleTitle:@"心率测量"
                                        RightImage:[UIImage imageNamed:@"faq_icon"]
                                        RightTitle:@""];
    
    [self addSubview:_navi];
    
    _startMeasureBtn.layer.cornerRadius = 4;
}

- (void)dealloc {
    NSLog(@"HeartRateView释放");
    
    _tempre_loading.image = nil;
    _tempre_loading = nil;
    
    [_heartRateValue removeFromSuperview];
    _heartRateValue = nil;
    
    [_startMeasureBtn removeFromSuperview];
    _startMeasureBtn = nil;
    
    [_navi removeFromSuperview];
    [_navi removeAllSubviews];
    _navi = nil;
}

@end
