//
//  DeviceInfoView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/27.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "DeviceInfoView.h"
#import "UIImage+memory.h"
@interface DeviceInfoView ()

@property (weak, nonatomic) IBOutlet UIImageView *device_icon;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation DeviceInfoView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupViews];
    self.device_icon.image = [UIImage imageWithMName:@"Group"];
}

- (void)setupViews {
    CGFloat naviHeight = 64;
    if (iPhoneX) {
        naviHeight = 88;
    }
    
    _navi = [[DRNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.width, naviHeight)
                                         LeftImage:[UIImage imageWithMName:@"back_icon"]
                                         LeftTitle:@""
                                       MiddleImage:nil
                                       MiddleTitle:@"设备信息"
                                        RightImage:nil
                                        RightTitle:@""];
    
    [self addSubview:_navi];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
    
    [_tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bgView withOffset:5];
    
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [_tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    
}

- (void)dealloc {
    NSLog(@"DeviceInfo 释放");
    [self.navi removeAllSubviews];
    self.navi= nil;
    self.device_icon = nil;
}

@end
