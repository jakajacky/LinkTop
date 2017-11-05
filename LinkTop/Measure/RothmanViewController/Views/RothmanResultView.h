//
//  RothmanResultView.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/3.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRNavigationBar.h"
@interface RothmanResultView : UIView
@property (nonatomic, strong) DRNavigationBar *navi;
@property (strong, nonatomic) IBOutlet UIButton *endMeasureBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *bp;
@property (weak, nonatomic) IBOutlet UILabel *spo2h;
@property (weak, nonatomic) IBOutlet UILabel *br;
@property (weak, nonatomic) IBOutlet UILabel *temp;
@property (weak, nonatomic) IBOutlet UILabel *hr;
@property (weak, nonatomic) IBOutlet UILabel *riValue;
@property (weak, nonatomic) IBOutlet UITextView *riDesc;

@end
