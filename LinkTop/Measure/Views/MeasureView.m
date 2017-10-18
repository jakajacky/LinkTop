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
    CGFloat radius       = 4;
    CGFloat borderwidth  = 0.5;
    UIColor *borderColor = UIColorHex(#DDDDDD);
    CGSize shadowOffset  = CGSizeMake(0, 1);
    UIColor *shadowColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3];
    
    
    _rothmanIcon_bg.layer.cornerRadius = radius;
    _rothman_bg.layer.cornerRadius     = radius;
    [_rothman_bg setLayerShadow:shadowColor offset:shadowOffset radius:radius];
    _rothman_bg.layer.borderWidth = borderwidth;
    _rothman_bg.layer.borderColor = borderColor.CGColor;
    
    _ecgIcon_bg.layer.cornerRadius     = radius;
    _ecg_bg.layer.cornerRadius         = radius;
    [_ecg_bg setLayerShadow:shadowColor offset:shadowOffset radius:radius];
    _ecg_bg.layer.borderWidth = borderwidth;
    _ecg_bg.layer.borderColor = borderColor.CGColor;
    
    _bp_bg.layer.cornerRadius         = radius;
    [_bp_bg setLayerShadow:shadowColor offset:shadowOffset radius:radius];
    _bp_bg.layer.borderWidth = borderwidth;
    _bp_bg.layer.borderColor = borderColor.CGColor;
    
    _temp_bg.layer.cornerRadius         = radius;
    [_temp_bg setLayerShadow:shadowColor offset:shadowOffset radius:radius];
    _temp_bg.layer.borderWidth = borderwidth;
    _temp_bg.layer.borderColor = borderColor.CGColor;
    
    _spo_bg.layer.cornerRadius         = radius;
    [_spo_bg setLayerShadow:shadowColor offset:shadowOffset radius:radius];
    _spo_bg.layer.borderWidth = borderwidth;
    _spo_bg.layer.borderColor = borderColor.CGColor;
    
    _hr_bg.layer.cornerRadius         = radius;
    [_hr_bg setLayerShadow:shadowColor offset:shadowOffset radius:radius];
    _hr_bg.layer.borderWidth = borderwidth;
    _hr_bg.layer.borderColor = borderColor.CGColor;
    
}

@end
