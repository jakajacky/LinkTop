//
//  RothmanViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/3.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "RothmanViewController.h"
#import "RothmanView.h"
#import "UIAlertController+Element.h"
#import "BloodPreViewController.h"
#import "TemperViewController.h"
#import "Spo2hViewController.h"
#import "ECGViewController.h"
#import "RothmanResultViewController.h"
#define kNextMsg @"点击【确定】\n进行下一项指标测量"

@interface RothmanViewController ()

@property (nonatomic, strong) RothmanView *rothmanView;
@property (nonatomic, strong) DiagnosticList *diagnostic;
@property (nonatomic, strong) UIStoryboard *story;
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
    
    _story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
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

#pragma mark - 开始罗斯曼测量流程
- (void)startMeasureBtnDidClicked:(UIButton *)sender {
    // 第一步：测血压
    [self bloodPresureMeasure];
}

#pragma mark - funcitons
/**
 * step 1 血压
 */
- (void)bloodPresureMeasure {
    BloodPreViewController *bp = [_story instantiateViewControllerWithIdentifier:@"bp"];
    
    bp.isRothmanMeasure = YES;
    [bp startRothmanStepOneMeasureWithViewController:self endCompletion:^(BOOL success, id result) {
        NSLog(@"%@",result);
        _diagnostic = result;
        if (success) { // 血压数据正常
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:kNextMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert setMessageColor:UIColorHex(#333333) Font:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]];
            UIAlertAction *action_ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [bp dismissViewControllerAnimated:NO completion:^{
                    // 第二步：测体温
                    [self tempMeasure];
                }];
                
            }];
            [alert addAction:action_ok];
            [bp presentViewController:alert animated:YES completion:nil];
        }
        else { // 血压数据异常
            
            NSString *msg = [NSString stringWithFormat:@"您的本次测量值为%@/%@ mmHg,指标异常，是否需要重新测量",_diagnostic.sbp,_diagnostic.dbp];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
            [alert setMessageColor:UIColorHex(#333333) Font:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]];
            UIAlertAction *action_ok = [UIAlertAction actionWithTitle:@"下一项" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [bp dismissViewControllerAnimated:NO completion:^{
                    // 第二步：测体温
                    [self tempMeasure];
                }];
            }];
            UIAlertAction *action_retry = [UIAlertAction actionWithTitle:@"重新测量" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action_ok];
            [alert addAction:action_retry];
            [bp presentViewController:alert animated:YES completion:nil];
        }
    }];
}

/**
 * step 2 体温
 */
- (void)tempMeasure {
    TemperViewController *temp = [_story instantiateViewControllerWithIdentifier:@"temp"];
    temp.isRothmanMeasure = YES;
    [temp startRothmanStepTwoMeasureWithViewController:self endCompletion:^(BOOL success, id result) {
        DiagnosticList *dia = result;
        _diagnostic.temp = dia.temp;
        if (success) { // 体温数据正常
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:kNextMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert setMessageColor:UIColorHex(#333333) Font:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]];
            UIAlertAction *action_ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [temp dismissViewControllerAnimated:NO completion:^{
                    // 第三步：测血氧
                    [self spo2hMeasure];
                }];
                
            }];
            [alert addAction:action_ok];
            [temp presentViewController:alert animated:YES completion:nil];
        }
        else { // 体温数据异常
            NSString *msg = [NSString stringWithFormat:@"您的本次测量值为%@ ℃，指标异常，是否需要重新测量",_diagnostic.temp];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
            [alert setMessageColor:UIColorHex(#333333) Font:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]];
            UIAlertAction *action_ok = [UIAlertAction actionWithTitle:@"下一项" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [temp dismissViewControllerAnimated:NO completion:^{
                    // 第三步：测血氧
                    [self spo2hMeasure];
                }];
                
            }];
            UIAlertAction *action_retry = [UIAlertAction actionWithTitle:@"重新测量" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action_ok];
            [alert addAction:action_retry];
            [temp presentViewController:alert animated:YES completion:nil];
        }
    }];
}

/**
 * step 3 血氧
 */
- (void)spo2hMeasure {
    Spo2hViewController *spo = [_story instantiateViewControllerWithIdentifier:@"spo"];
    spo.isRothmanMeasure = YES;
    [spo startRothmanStepThreeMeasureWithViewController:self endCompletion:^(BOOL success, id result) {
        DiagnosticList *dia = result;
        _diagnostic.spo2h = dia.spo2h;
        _diagnostic.hr    = dia.hr;
        if (success) { // 血氧数据正常
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:kNextMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert setMessageColor:UIColorHex(#333333) Font:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]];
            UIAlertAction *action_ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [spo dismissViewControllerAnimated:NO completion:^{
                    // 第四步：测心电
                    [self ecgMeasure];
                }];
                
            }];
            [alert addAction:action_ok];
            [spo presentViewController:alert animated:YES completion:nil];
        }
        else { // 血氧数据异常
            NSString *msg = [NSString stringWithFormat:@"您的本次测量值为%@ %%，指标异常，是否需要重新测量",_diagnostic.spo2h];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
            [alert setMessageColor:UIColorHex(#333333) Font:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]];
            UIAlertAction *action_ok = [UIAlertAction actionWithTitle:@"下一项" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [spo dismissViewControllerAnimated:NO completion:^{
                    // 第四步：测心电
                    [self ecgMeasure];
                }];
                
            }];
            UIAlertAction *action_retry = [UIAlertAction actionWithTitle:@"重新测量" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action_ok];
            [alert addAction:action_retry];
            [spo presentViewController:alert animated:YES completion:nil];
        }
    }];
}

/**
 * step 4 心电
 */
- (void)ecgMeasure {
    ECGViewController *ecg = [_story instantiateViewControllerWithIdentifier:@"ecg"];
    ecg.isRothmanMeasure = YES;
    [ecg startRothmanStepFourMeasureWithViewController:self endCompletion:^(BOOL success, id result) {
        DiagnosticList *dia = result;
        _diagnostic.hr  = dia.hr;
        _diagnostic.hrv = dia.hrv;
        _diagnostic.mood = dia.mood;
        _diagnostic.rr_max = dia.rr_max;
        _diagnostic.rr_min = dia.rr_min;
        _diagnostic.respiration = dia.respiration;
        _diagnostic.create_date = [[NSDate date] timeIntervalSince1970];
        if (success) { // 心率数据正常
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:kNextMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert setMessageColor:UIColorHex(#333333) Font:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]];
            UIAlertAction *action_ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [ecg dismissViewControllerAnimated:NO completion:^{
                    // 第五步：计算Rothman Index
                    [self RothmanCalculate];
                }];
                
            }];
            [alert addAction:action_ok];
            [ecg presentViewController:alert animated:YES completion:nil];
        }
        else { // 心率数据异常
            NSString *msg = [NSString stringWithFormat:@"您的本次测量值为%@ bpm，指标异常，是否需要重新测量",_diagnostic.hr];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
            [alert setMessageColor:UIColorHex(#333333) Font:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]];
            UIAlertAction *action_ok = [UIAlertAction actionWithTitle:@"下一项" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [ecg dismissViewControllerAnimated:NO completion:^{
                    // 第五步：计算Rothman Index
                    [self RothmanCalculate];
                }];
                
            }];
            UIAlertAction *action_retry = [UIAlertAction actionWithTitle:@"重新测量" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action_ok];
            [alert addAction:action_retry];
            [ecg presentViewController:alert animated:YES completion:nil];
        }
    }];
}

/**
 * step 5 计算Rothman Index
 */
- (void)RothmanCalculate {
    NSLog(@"%@",_diagnostic);
    RothmanResultViewController *result = [_story instantiateViewControllerWithIdentifier:@"rothmanresult"];
    result.diagnostic = self.diagnostic;
    [result startRothmanStepFiveMeasureWithViewController:self endCompletion:^(BOOL success, id result) {
        
    }];
    
}

#pragma mark - propertiese
- (RothmanView *)rothmanView {
    if (!_rothmanView) {
        _rothmanView = (RothmanView *)self.view;
    }
    return _rothmanView;
}

@end
