//
//  RothmanResultViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/3.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "RothmanResultViewController.h"
#import "RothmanResultView.h"
#import "MeasureAPI.h"
typedef void(^RothmanStepFiveComplete)(BOOL,id);

@interface RothmanResultViewController ()

@property (nonatomic, strong) RothmanResultView *rothmanResultView;
@property (nonatomic, copy)   RothmanStepFiveComplete rothmanStepFiveComplete;
@property (nonatomic, strong) MeasureAPI *measureAPI;
@end

@implementation RothmanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) myself = self;
    
    self.rothmanResultView.navi.leftViewDidClicked = ^{
        [myself dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
    [self.rothmanResultView.endMeasureBtn addTarget:self
                                         action:@selector(endMeasureBtnDidClicked:)
                               forControlEvents:UIControlEventTouchUpInside];
    // 测量记录
    [self reloadData];
    // 计算rothman index
    [self onlineCalcRothmanIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"RothmanResultViewController 释放");
    [self.rothmanResultView removeAllSubviews];
    self.rothmanResultView = nil;
}

#pragma mark - 刷新测量数据
- (void)reloadData {
    // 时间
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.diagnostic.create_date];
    NSString *dateStr = [formatter stringFromDate:date];
    
    self.rothmanResultView.timeL.text = dateStr;
    self.rothmanResultView.bp.text = [NSString stringWithFormat:@"%@/%@ mmHg",self.diagnostic.sbp,self.diagnostic.dbp];
    self.rothmanResultView.spo2h.text = [NSString stringWithFormat:@"%@%%",self.diagnostic.spo2h];
    self.rothmanResultView.br.text = [NSString stringWithFormat:@"%@ 次/分钟",self.diagnostic.respiration];
    self.rothmanResultView.temp.text = [NSString stringWithFormat:@"%@ ℃",self.diagnostic.temp];
    self.rothmanResultView.hr.text = [NSString stringWithFormat:@"%@ bpm",self.diagnostic.hr];
}

#pragma mark - 退出罗斯曼测量流程
- (void)endMeasureBtnDidClicked:(UIButton *)sender {
    
}

#pragma mark - 在线计算Rothman Index
- (void)onlineCalcRothmanIndex {
    // 上传数据
    [SVProgressHUD showWithStatus:@"正在计算"];
    Patient *user = [LoginManager defaultManager].currentPatient;
    NSString *device_id  = [DeviceManger defaultManager].deviceID;
    NSString *device_key = [DeviceManger defaultManager].deviceKEY;
    NSString *soft_v  = [DeviceManger defaultManager].softVersion;
    NSString *hard_v  = [DeviceManger defaultManager].hardVersion;
    NSDictionary *params = @{@"user_id"         : user.user_id,   // 用户名
                             @"spo2h"           : _diagnostic.spo2h, // 血氧
                             @"temp"            : _diagnostic.temp,// 体温
                             @"rr_max"          : @(_diagnostic.rr_max),  // 最大值
                             @"rr_min"          : @(_diagnostic.rr_min),  // 最小值
                             @"mood"            : @(_diagnostic.mood),    // 心情
                             @"hrv"             : @(_diagnostic.hrv),        // 心率异常
                             @"hr"              : _diagnostic.hr,   // 心率
                             @"respiration"     : _diagnostic.respiration, // 呼吸率
                             @"sbp"             : _diagnostic.sbp, // 收缩压
                             @"dbp"             : _diagnostic.dbp, // 舒张压
                             @"device_id"       : device_id?device_id:@"", // 设备id
                             @"device_key"      : device_key?device_key:@"", // 设备key
                             @"device_power"    : @(100),
                             @"device_soft_ver" : soft_v?soft_v:@"", // 软件版本
                             @"device_hard_ver" : hard_v?hard_v:@"", // 硬件版本
                             };
    [self.measureAPI uploadResult:params type:MTRothmanIndex completion:^(BOOL success, id result, NSString *msg) {
        
        if (success) {
            
            [SVProgressHUD showSuccessWithStatus:@"计算成功"];
            [SVProgressHUD dismissWithDelay:1.5];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"计算失败"];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}

- (void)startRothmanStepFiveMeasureWithViewController:(UIViewController *)vc endCompletion:(void(^)(BOOL success,id result))complete {
    _rothmanStepFiveComplete = complete;
    [vc presentViewController:self animated:YES completion:^{
        
    }];
}

#pragma mark - propertiese
- (RothmanResultView *)rothmanResultView {
    if (!_rothmanResultView) {
        _rothmanResultView = (RothmanResultView *)self.view;
    }
    return _rothmanResultView;
}

- (MeasureAPI *)measureAPI {
    if (!_measureAPI) {
        _measureAPI = [MeasureAPI biz];
    }
    return _measureAPI;
}

@end
