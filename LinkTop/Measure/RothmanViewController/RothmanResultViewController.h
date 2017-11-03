//
//  RothmanResultViewController.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/3.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RothmanResultViewController : UIViewController

@property (nonatomic, strong) DiagnosticList *diagnostic;

- (void)startRothmanStepFiveMeasureWithViewController:(UIViewController *)vc endCompletion:(void(^)(BOOL success,id result))complete;

@end
