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

@property (weak, nonatomic) IBOutlet UIView *ecgContainer;

@end
