//
//  MeasureNaviRightView.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/17.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConnectBlock)(BOOL);

@interface MeasureNaviRightView : UIView

@property (nonatomic, copy) ConnectBlock connectBlock;

@end
