//
//  TempreView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/19.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "TempreView.h"

@interface TempreView ()

@property (strong, nonatomic) IBOutlet UIImageView *tempre_tech;


@property (strong, nonatomic) IBOutlet UIView *bg1;
@property (strong, nonatomic) IBOutlet UIView *bg2;

@end

@implementation TempreView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat naviHeight = 64;
    if (iPhoneX) {
        naviHeight = 88;
    }
    
    _navi = [[DRNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.width, naviHeight)
                                                         LeftImage:[UIImage imageNamed:@"back_icon"]
                                                         LeftTitle:@""
                                                       MiddleImage:[UIImage imageNamed:@"tempre_icon"]
                                                       MiddleTitle:@"体温测量"
                                                        RightImage:[UIImage imageNamed:@"faq_icon"]
                                                        RightTitle:@""];
    
    [self addSubview:_navi];
    
    _controlTypeOfTemp = [[DRSegmentControl alloc] initWithFrame:CGRectMake(0, 0, _segmentContainer.width, _segmentContainer.height)];
    _controlTypeOfTemp.segOneTitle = @"℃";
    _controlTypeOfTemp.segTwoTitle = @"℉";
    
    [_segmentContainer addSubview:_controlTypeOfTemp];
    
    _startMeasureBtn.layer.cornerRadius = 4;
}

- (void)dealloc {
    NSLog(@"TemperView释放");

    _tempre_tech.image = nil;
    [_tempre_tech removeFromSuperview];
    _tempre_tech = nil;
    
    _tempre_loading.image = nil;
    _tempre_loading = nil;
    
    [_tempretureValue removeFromSuperview];
    _tempretureValue = nil;
    [_startMeasureBtn removeFromSuperview];
    _startMeasureBtn = nil;
    
    [_controlTypeOfTemp removeFromSuperview];
    [_controlTypeOfTemp removeAllSubviews];
    _controlTypeOfTemp = nil;
    
    [_segmentContainer removeFromSuperview];
    [_segmentContainer removeAllSubviews];
    _segmentContainer = nil;
    
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
