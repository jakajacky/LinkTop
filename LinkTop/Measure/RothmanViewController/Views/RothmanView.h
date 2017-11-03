//
//  RothmanView.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/3.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRNavigationBar.h"
@interface RothmanView : UIView

@property (nonatomic, strong) DRNavigationBar *navi;
@property (strong, nonatomic) IBOutlet UIButton *startMeasureBtn;
@end
