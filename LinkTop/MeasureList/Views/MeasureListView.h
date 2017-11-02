//
//  MeasureListView.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/23.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTabBarHeight 49
#define kNaviBarHeight 64
#define kLeftandRightMargin 10
#define kTopandBottomMargin 8
#define kItemWidth (self.width-(2*kLeftandRightMargin))
#define kItemHeight 87
#define kItemSpacing 4
@interface MeasureListView : UIView

@property (nonatomic, strong) UICollectionView *listView;

@property (nonatomic, assign) BOOL isNull;

@end
