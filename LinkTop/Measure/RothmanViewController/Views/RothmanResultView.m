//
//  RothmanResultView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/3.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "RothmanResultView.h"

@implementation RothmanResultView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat naviHeight = 64;
    if (iPhoneX) {
        naviHeight = 88;
    }
    
    _navi = [[DRNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.width, naviHeight)
                                         LeftImage:[UIImage imageNamed:@"back_icon"]
                                         LeftTitle:@""
                                       MiddleImage:[UIImage imageNamed:@"rothman_icon"]
                                       MiddleTitle:@"Rothman Index"
                                        RightImage:[UIImage imageNamed:@"faq_icon"]
                                        RightTitle:@""];
    
    [self addSubview:_navi];
    
    _endMeasureBtn.layer.cornerRadius = 4;
}

- (void)dealloc {
    NSLog(@"RothmanResultView释放");
    
    [_endMeasureBtn removeFromSuperview];
    _endMeasureBtn = nil;
    
    [_navi removeFromSuperview];
    [_navi removeAllSubviews];
    _navi = nil;
}

@end
