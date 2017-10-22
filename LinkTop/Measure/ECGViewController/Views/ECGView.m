//
//  ECGView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/22.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "ECGView.h"

@implementation ECGView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat naviHeight = 64;
    if (iPhoneX) {
        naviHeight = 88;
    }
    
    _navi = [[DRNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.width, naviHeight)
                                         LeftImage:[UIImage imageNamed:@"back_icon"]
                                         LeftTitle:@""
                                       MiddleImage:[UIImage imageNamed:@"ecg_icon"]
                                       MiddleTitle:@"心电记录"
                                        RightImage:[UIImage imageNamed:@"faq_icon"]
                                        RightTitle:@""];
    
    [self addSubview:_navi];
    
    _startMeasureBtn.layer.cornerRadius = 4;
}

- (void)dealloc {
    NSLog(@"ECGView释放");
    
    [_tutorialView removeFromSuperview];
    _tutorialView = nil;
    
    [_ecgContainer removeFromSuperview];
    _ecgContainer = nil;
    
    [_startMeasureBtn removeFromSuperview];
    _startMeasureBtn = nil;
    
    [_navi removeFromSuperview];
    [_navi removeAllSubviews];
    _navi = nil;
}

@end
