//
//  SettingsView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/26.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "SettingsView.h"

@interface SettingsView ()

@end

@implementation SettingsView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupViews];
}

- (void)setupViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    [self addSubview:_tableView];
}

- (void)dealloc {
    NSLog(@"SettingsView 释放");
}

@end
