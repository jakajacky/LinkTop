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

@interface MeasureViewController ()


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
    MeasureNaviLeftView *leftview = [[MeasureNaviLeftView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    
    // 标题
    UILabel *title_copy = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title_copy.textAlignment = NSTextAlignmentCenter;
    title_copy.text = @"测量";
    title_copy.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    title_copy.textColor = [UIColor whiteColor];
    
    // 右侧视图
    MeasureNaviRightView *rightview = [[MeasureNaviRightView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    rightview.connectBlock = ^(BOOL isConnected) {
        NSLog(@"连接");
    };
    
    [ChangeView2GradientColor changeControllerView:self.view withNavi:self.navigationItem setLeftView:leftview RightView:rightview Title:title_copy];
    
}

- (BOOL)prefersStatusBarHidden {
  return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
