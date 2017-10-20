//
//  HeartRateView.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/20.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRNavigationBar.h"

@interface HeartRateView : UIView

@property (nonatomic, strong) DRNavigationBar *navi;

@property (strong, nonatomic) IBOutlet UILabel *heartRateValue;

@property (strong, nonatomic) IBOutlet UIButton *startMeasureBtn;
@property (strong, nonatomic) IBOutlet UIImageView *tempre_loading;

@end
