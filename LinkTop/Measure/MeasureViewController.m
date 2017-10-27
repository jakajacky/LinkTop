//
//  MeasureViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/10.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "MeasureViewController.h"
#import "MeasureNaviRightView.h"
#import "MeasureNaviLeftView.h"

#import "LoginViewController.h"

@interface MeasureViewController ()
{
    int isConnectTimeout;
}

@property (nonatomic, strong) CBPeripheral         *peripheral;

@property (nonatomic, strong) NSMutableArray       *peripherals;

@property (nonatomic, strong) MeasureNaviRightView *rightview;

@property (nonatomic, strong) MeasureNaviLeftView  *leftview;

@property (nonatomic, strong) NSTimer              *timer;

@end

@implementation MeasureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 更改导航栏
    [self prepareNavigationColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 登录页面判断
    [[LoginManager defaultManager] shouldShowLoginViewControllerIn:self];
    // 用户名称更新
    _leftview.name.text = [LoginManager defaultManager].currentPatient.login_name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 修改导航栏和状态栏渐变色
- (void)prepareNavigationColor {
    // iOS7之后，设置状态栏和导航栏统一背景色，是很简单的，但是渐变颜色又是特殊的一种
    [ChangeView2GradientColor changeView:self.navigationController.navigationBar toGradientColors:@[UIColorHex(#1F67B6),UIColorHex(#51A8F2),UIColorHex(#89BDF4),UIColorHex(#C1E4FE)]];
    
    // 重新自定义设置导航栏
    // 左侧视图
    _leftview = [[MeasureNaviLeftView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    
    // 标题
    UILabel *title_copy = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title_copy.textAlignment = NSTextAlignmentCenter;
    title_copy.text = @"测量";
    title_copy.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    title_copy.textColor = [UIColor whiteColor];
    
    // 右侧视图
    __weak typeof(self) myself = self;
    _rightview = [[MeasureNaviRightView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    _rightview.connectBlock = ^(BOOL isConnected) {
        if ([DeviceManger defaultManager].peripheral && [DeviceManger defaultManager].peripheral.state == CBPeripheralStateConnected) {
            NSLog(@"准备断开连接");
            [[DeviceManger defaultManager] endConnect];
        }
        else {
            [SVProgressHUD show];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            
            [[DeviceManger defaultManager] startConnectWithConnect:^(CBPeripheral *peripheral) {
                NSLog(@"+++++++已连接");
                myself.rightview.isPeriperalConnected = YES;
                [SVProgressHUD dismissWithDelay:0.37];
            } disconnect:^(CBPeripheral *peripheral) {
                NSLog(@"+++++++断开连接");
                dispatch_async(dispatch_get_main_queue(), ^{
                    myself.rightview.isPeriperalConnected = NO;
                });
            } bleAbnormal:^{
                NSLog(@"+++++++异常断开");
                dispatch_async(dispatch_get_main_queue(), ^{
                    myself.rightview.isPeriperalConnected = NO;
                });
            }];
            
            
        }
    };
    
    [ChangeView2GradientColor changeControllerView:self.view withNavi:self.navigationItem setLeftView:_leftview RightView:_rightview Title:title_copy];
    
}

#pragma mark - 进入温度测量页面
- (IBAction)TemperatureBtnDidClicked:(id)sender {
    if (![DeviceManger defaultManager].peripheral || [DeviceManger defaultManager].peripheral.state != CBPeripheralStateConnected) {
        [SVProgressHUD showErrorWithStatus:@"未连接设备"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissWithDelay:1.5];
    }
    else {
        [self performSegueWithIdentifier:@"temperature" sender:self];
    }
}

#pragma mark - 进入血氧测量页面
- (IBAction)Spo2hBtnDidClicked:(id)sender {
    if (![DeviceManger defaultManager].peripheral || [DeviceManger defaultManager].peripheral.state != CBPeripheralStateConnected) {
        [SVProgressHUD showErrorWithStatus:@"未连接设备"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissWithDelay:1.5];
    }
    else {
        [self performSegueWithIdentifier:@"spo2h" sender:self];
    }
}

#pragma mark - 进入心率测量页面
- (IBAction)HeartRateBtnDidClicked:(id)sender {
    if (![DeviceManger defaultManager].peripheral || [DeviceManger defaultManager].peripheral.state != CBPeripheralStateConnected) {
        [SVProgressHUD showErrorWithStatus:@"未连接设备"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissWithDelay:1.5];
    }
    else {
        [self performSegueWithIdentifier:@"heartrate" sender:self];
    }
}

#pragma mark - 进入血压测量页面
- (IBAction)BloodPreBtnDidClicked:(id)sender {
    if (![DeviceManger defaultManager].peripheral || [DeviceManger defaultManager].peripheral.state != CBPeripheralStateConnected) {
        [SVProgressHUD showErrorWithStatus:@"未连接设备"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissWithDelay:1.5];
    }
    else {
        [self performSegueWithIdentifier:@"bloodpre" sender:self];
    }
}

- (IBAction)ECGBtnDidClicked:(id)sender {
    if (![DeviceManger defaultManager].peripheral || [DeviceManger defaultManager].peripheral.state != CBPeripheralStateConnected) {
        [SVProgressHUD showErrorWithStatus:@"未连接设备"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD dismissWithDelay:1.5];
    }
    else {
        [self performSegueWithIdentifier:@"ecg" sender:self];
    }
}



@end
