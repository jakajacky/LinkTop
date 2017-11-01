//
//  Spo2hView.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/20.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRNavigationBar.h"

@interface Spo2hView : UIView

@property (nonatomic, strong) DRNavigationBar *navi;

@property (strong, nonatomic) IBOutlet UILabel *Spo2hValue;
@property (weak, nonatomic) IBOutlet UILabel *PulseRateValue;

@property (weak, nonatomic) IBOutlet UILabel *spo2h_unit;
@property (weak, nonatomic) IBOutlet UILabel *pulse_unit;

@property (strong, nonatomic) IBOutlet UIButton *startMeasureBtn;
@property (strong, nonatomic) IBOutlet UIImageView *tempre_loading;
@property (weak, nonatomic) IBOutlet UIView *spo2hViewContainer;

@end
