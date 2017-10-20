//
//  Spo2hView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/20.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "Spo2hView.h"

@interface Spo2hView ()

@property (strong, nonatomic) IBOutlet UIImageView *tempre_tech;


@property (strong, nonatomic) IBOutlet UIView *bg1;
@property (strong, nonatomic) IBOutlet UIView *bg2;



@end

@implementation Spo2hView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat naviHeight = 64;
    if (iPhoneX) {
        naviHeight = 88;
    }
    
    _navi = [[DRNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.width, naviHeight)
                                         LeftImage:[UIImage imageNamed:@"back_icon"]
                                         LeftTitle:@""
                                       MiddleImage:[UIImage imageNamed:@"spo2h_icon"]
                                       MiddleTitle:@"血氧测量"
                                        RightImage:[UIImage imageNamed:@"faq_icon"]
                                        RightTitle:@""];
    
    [self addSubview:_navi];
    
    _startMeasureBtn.layer.cornerRadius = 4;
}

- (void)dealloc {
    NSLog(@"Spo2hView释放");
    
    _tempre_tech.image = nil;
    [_tempre_tech removeFromSuperview];
    _tempre_tech = nil;
    
    _tempre_loading.image = nil;
    _tempre_loading = nil;
    
    [_Spo2hValue removeFromSuperview];
    _Spo2hValue = nil;
    [_PulseRateValue removeFromSuperview];
    _PulseRateValue = nil;
    
    [_startMeasureBtn removeFromSuperview];
    _startMeasureBtn = nil;
    
    [_bg1 removeFromSuperview];
    [_bg1 removeAllSubviews];
    _bg1 = nil;
    
    [_bg2 removeFromSuperview];
    [_bg2 removeAllSubviews];
    _bg2 = nil;
    
    [_navi removeFromSuperview];
    [_navi removeAllSubviews];
    _navi = nil;
}

@end
