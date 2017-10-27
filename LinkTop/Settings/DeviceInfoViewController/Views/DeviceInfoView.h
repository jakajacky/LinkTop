//
//  DeviceInfoView.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/27.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRNavigationBar.h"

@interface DeviceInfoView : UIView

@property (nonatomic, strong) DRNavigationBar *navi;

@property (strong, nonatomic) UITableView *tableView;

@end
