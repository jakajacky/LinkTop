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


@end

@implementation MeasureView

- (void)awakeFromNib {
    [super awakeFromNib];
    // 针对5s特殊适配字体
    [self layoutForiPhone5s];
}

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

@end
