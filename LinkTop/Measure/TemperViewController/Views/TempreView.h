//
//  TempreView.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/19.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRNavigationBar.h"
#import "DRSegmentControl.h"

@interface TempreView : UIView

@property (nonatomic, strong) DRNavigationBar *navi;

@property (nonatomic, strong) DRSegmentControl *controlTypeOfTemp;

@property (strong, nonatomic) IBOutlet UIView *segmentContainer;

@property (strong, nonatomic) IBOutlet UILabel *tempretureValue;

@property (strong, nonatomic) IBOutlet UIButton *startMeasureBtn;
@property (weak, nonatomic) IBOutlet UILabel *tempreType;

@end
