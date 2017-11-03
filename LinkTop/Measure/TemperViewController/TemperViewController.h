//
//  TemperViewController.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/18.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperViewController : UIViewController

@property (nonatomic, assign) BOOL isRothmanMeasure;

- (void)startRothmanStepTwoMeasureWithViewController:(UIViewController *)vc endCompletion:(void(^)(BOOL success,id result))complete;

@end
