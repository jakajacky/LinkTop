//
//  BloodPreViewController.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/22.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodPreViewController : UIViewController

@property (nonatomic, assign) BOOL isRothmanMeasure;

- (void)startRothmanStepOneMeasureWithViewController:(UIViewController *)vc endCompletion:(void(^)(BOOL success,id result))complete;

@end
