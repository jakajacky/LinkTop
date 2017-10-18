//
//  TemperViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/18.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "TemperViewController.h"
#import "MeasureNaviLeftView.h"
#import "MeasureNaviRightView.h"
#import "DRNavigationBar.h"

@interface TemperViewController ()



@end

@implementation TemperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat naviHeight = 64;
    if (iPhoneX) {
        naviHeight = 88;
    }
    
    DRNavigationBar *navi = [[DRNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, naviHeight)
                                                         LeftImage:[UIImage imageNamed:@"back_icon"]
                                                         LeftTitle:@"Back"
                                                       MiddleImage:[UIImage imageNamed:@"tempre_icon"]
                                                       MiddleTitle:@"体温测量"
                                                        RightImage:[UIImage imageNamed:@"faq_icon"]
                                                        RightTitle:@"详细"];
    [self.view addSubview:navi];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dealloc {
    
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
