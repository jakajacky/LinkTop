//
//  RothmanViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/3.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "RothmanViewController.h"
#import "RothmanView.h"
#import "BloodPreViewController.h"
#import "TemperViewController.h"
#import "Spo2hViewController.h"
#import "ECGViewController.h"
@interface RothmanViewController ()

@property (nonatomic, strong) RothmanView *rothmanView;
@property (nonatomic, strong) DiagnosticList *diagnostic;
@end

@implementation RothmanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) myself = self;
    
    self.rothmanView.navi.leftViewDidClicked = ^{
        [myself dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
    [self.rothmanView.startMeasureBtn addTarget:self
                                          action:@selector(startMeasureBtnDidClicked:)
                                forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"RothmanViewController 释放");
    [self.rothmanView removeAllSubviews];
    self.rothmanView = nil;
}

#pragma mark - 开始罗斯曼测量
- (void)startMeasureBtnDidClicked:(UIButton *)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BloodPreViewController *bp = [story instantiateViewControllerWithIdentifier:@"bp"];
    // step 1 血压
    bp.isRothmanMeasure = YES;
    [bp startRothmanStepOneMeasureWithViewController:self endCompletion:^(BOOL success, id result) {
        NSLog(@"%@",result);
        if (success) {
           _diagnostic = result;
        }
        else {
            _diagnostic = nil;
        }
    }];
    // step 2 体温
    
    // step 3 血氧
    
    // step 4 心电
    
    
}

- (RothmanView *)rothmanView {
    if (!_rothmanView) {
        _rothmanView = (RothmanView *)self.view;
    }
    return _rothmanView;
}

@end
