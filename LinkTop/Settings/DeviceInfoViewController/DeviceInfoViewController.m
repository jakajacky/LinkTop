//
//  DeviceInfoViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/27.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "DeviceInfoView.h"
#import "SettingModel.h"
@interface DeviceInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger numberOfSection;
}
@property (nonatomic, strong) DeviceInfoView *deviceInfoView;

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) myself = self;
    
    self.deviceInfoView.navi.leftViewDidClicked = ^{
        [myself dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
    self.deviceInfoView.tableView.delegate = self;
    self.deviceInfoView.tableView.dataSource = self;
    
    numberOfSection = [DeviceManger defaultManager].peripheral?3:2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview delegate&datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section==2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"deviceinfo_"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deviceinfo_"];
        }
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"deviceinfo"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"deviceinfo"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
        case 0:{
            cell.textLabel.text = @"设备名称";
            cell.detailTextLabel.text = self.settingsModel.deviceName;
            break;
        }
        case 1:{
            if (indexPath.row==0) {
                cell.textLabel.text = @"设备ID";
                cell.detailTextLabel.text = self.settingsModel.deviceID;
            }
            else if (indexPath.row==1) {
                cell.textLabel.text = @"固件版本";
                cell.detailTextLabel.text = self.settingsModel.softVersion;
            }
            else {
                cell.textLabel.text = @"硬件版本";
                cell.detailTextLabel.text = self.settingsModel.hardVersion;
            }
            break;
        }
        case 2:
            cell.textLabel.text = @"解除绑定";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        default:
            cell.textLabel.text = @"解除绑定";
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:{
            
            break;
        }
        case 1:{
            
            break;
        }
        case 2:{// 解除绑定
            numberOfSection = 2;
            [[DeviceManger defaultManager] endConnect];
            [self.settingsModel reloadData:^(BOOL success) {
                [self.deviceInfoView.tableView reloadData];
            }];
            break;
        }
        default:
            break;
    }
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 30;
    }
    return 15;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    if (section==2) {
        view.frame = CGRectMake(0, 0, 320, 30);
        return view;
    }
    view.backgroundColor = [UIColor clearColor];
    return view ;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (void)dealloc {
    NSLog(@"DeviceInfoViewController 释放");
    
    [self.deviceInfoView removeAllSubviews];
    self.deviceInfoView = nil;
}

#pragma mark - propertiese
- (DeviceInfoView *)deviceInfoView {
    if (!_deviceInfoView) {
        _deviceInfoView = (DeviceInfoView *)self.view;
    }
    return _deviceInfoView;
}

@end
