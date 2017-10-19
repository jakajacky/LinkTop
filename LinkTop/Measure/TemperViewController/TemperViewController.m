//
//  TemperViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/18.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "TemperViewController.h"
#import "TempreView.h"

@interface TemperViewController ()

@property (nonatomic, strong) TempreView *tempreView;


@end

@implementation TemperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tempreView.controlTypeOfTemp.valueChangedBlock = ^(NSInteger currentIndex) {
        NSLog(@"选中：%d", currentIndex);
    };
    __weak typeof(self) myself = self;
    self.tempreView.navi.leftViewDidClicked = ^{
        [myself dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tempreView.navi.leftViewDidClicked = nil; // 这种block记得及时释放，否则控制器一直持有，无法dealloc
    self.tempreView.navi.rightViewDidClicked = nil;
    self.tempreView.controlTypeOfTemp.valueChangedBlock = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"Tempreture控制器 释放");
    [self.tempreView removeFromSuperview];
    [self.tempreView removeAllSubviews];
    self.tempreView = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - properties
- (TempreView *)tempreView {
    if (!_tempreView) {
        _tempreView = (TempreView *)self.view;
    }
    return _tempreView;
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
