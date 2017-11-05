//
//  MeasureView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/16.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "MeasureView.h"
#import "DeviceName.h"
#import "MeasureSquareView.h"
#import "UIView+Shadow.h"
@interface MeasureView ()

@property (weak, nonatomic) IBOutlet UILabel *rothman;

@property (weak, nonatomic) IBOutlet UILabel *rothmanEN;

@property (weak, nonatomic) IBOutlet UILabel *hr;

@property (weak, nonatomic) IBOutlet UILabel *hrEN;

@property (weak, nonatomic) IBOutlet UIView *BPView;
@property (weak, nonatomic) IBOutlet UIView *TempView;
@property (weak, nonatomic) IBOutlet UIView *SPOView;
@property (weak, nonatomic) IBOutlet UIView *HRView;

// 下面是背景视图
@property (weak, nonatomic) IBOutlet UIView *rothman_bg;
@property (weak, nonatomic) IBOutlet UIImageView *rothmanIcon_bg;

@property (weak, nonatomic) IBOutlet UIView *ecg_bg;
@property (weak, nonatomic) IBOutlet UIImageView *ecgIcon_bg;

@property (weak, nonatomic) IBOutlet UIView *bp_bg;

@property (weak, nonatomic) IBOutlet UIView *temp_bg;

@property (weak, nonatomic) IBOutlet UIView *spo_bg;

@property (weak, nonatomic) IBOutlet UIView *hr_bg;

@end

@implementation MeasureView

- (void)awakeFromNib {
    [super awakeFromNib];
    // 针对5s特殊适配字体
    [self layoutForiPhone5s];
    
    [self layoutBackgroundViews];
}

#pragma mark - 5s重新布局
- (void)layoutForiPhone5s {
    NSString *st = [DeviceName platformString];
    if ([st isEqualToString:@"iPhone 5S"]||[st isEqualToString:@"iPhone 5C"]||[st isEqualToString:@"iPhone 5"]) {
        _rothman.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _rothmanInfo.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _rothmanEN.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
        _rothmanValue.font = [UIFont fontWithName:@"PingFangSC-Medium" size:26];
        
        _hr.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _hrEN.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
    }
}

#pragma mark - 背景子元素布局
- (void)layoutBackgroundViews {
    CGFloat radius = 4;
    
    _rothmanIcon_bg.layer.cornerRadius = radius;
    [_rothman_bg settingShadowWithDefaultStyle];
    
    _ecgIcon_bg.layer.cornerRadius     = radius;
    [_ecg_bg settingShadowWithDefaultStyle];
    
    _bp_bg.layer.cornerRadius         = radius;
    [_bp_bg settingShadowWithDefaultStyle];
    
    _temp_bg.layer.cornerRadius         = radius;
    [_temp_bg settingShadowWithDefaultStyle];
    
    _spo_bg.layer.cornerRadius         = radius;
    [_spo_bg settingShadowWithDefaultStyle];
    
    _hr_bg.layer.cornerRadius         = radius;
    [_hr_bg settingShadowWithDefaultStyle];
    
}

@end
