//
//  ECGView.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/22.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRNavigationBar.h"

@interface ECGView : UIView

@property (nonatomic, strong) DRNavigationBar *navi;

@property (strong, nonatomic) IBOutlet UIButton *startMeasureBtn;

@property (weak, nonatomic) IBOutlet UIView *tutorialView;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UILabel *hrvValue;
@property (weak, nonatomic) IBOutlet UILabel *hrValue;
@property (weak, nonatomic) IBOutlet UILabel *brValue;
@property (weak, nonatomic) IBOutlet UILabel *rrmaxValue;
@property (weak, nonatomic) IBOutlet UILabel *rrminValue;

@property (weak, nonatomic) IBOutlet UIView *ecgContainer;



@end
