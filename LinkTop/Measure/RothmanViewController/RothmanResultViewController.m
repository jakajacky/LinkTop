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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    self.rothmanResultView.riValue.text = @"正在计算中";
    self.rothmanResultView.riValue.textColor = UIColorHex(#F5A623);
    self.rothmanResultView.riDesc.text = @"请在约一分钟后前往测量记录进行查看";
}

- (void)reloadRothmanIndex {
    self.rothmanResultView.riValue.text = [NSString stringWithFormat:@"%ld",self.diagnostic.ri];
    self.rothmanResultView.riValue.textColor = UIColorHex(#F5A623);
    if (self.diagnostic.ri<0) {
        self.rothmanResultView.riValue.textColor = UIColorHex(#F5A623);
        self.rothmanResultView.riDesc.text = @"请在约一分钟后前往测量记录进行查看";
    }
    else if (self.diagnostic.ri<=40) {
        // #D0021B
        self.rothmanResultView.riValue.textColor = UIColorHex(#D0021B);
        self.rothmanResultView.riDesc.text = @"        通过您的问卷填写情况与测量结果综合评估，您的身体健康状况较差，建议及时进行专业检查或针对身体不适状况进行咨询。保证每天RI测量，可让你更直观的查看身体状况变化趋势。";
    }
    else if (self.diagnostic.ri<=65) {
        // #F5A623
        self.rothmanResultView.riValue.textColor = UIColorHex(#F5A623);
        self.rothmanResultView.riDesc.text = @"        通过您的问卷填写情况与测量结果综合评估，您的身体健康状况存在风险，建议在身体感到不适时及时咨询专业医生，并改善生活方式。保证每天RI测量，可让你更直观的查看身体状况变化趋势。";
    }
    else if (self.diagnostic.ri<=100){
        // #4A90E2
        self.rothmanResultView.riValue.textColor = UIColorHex(#4A90E2);
        self.rothmanResultView.riDesc.text = @"        通过您的问卷填写情况与测量结果综合评估，您的身体健康状况良好，请继续坚持健康的生活方式。保证每天RI测量，可让你更直观的查看身体状况变化趋势。";
    }
}

#pragma mark - 退出罗斯曼测量流程
- (void)endMeasureBtnDidClicked:(UIButton *)sender {
    
}

#pragma mark - 在线计算Rothman Index
- (void)onlineCalcRothmanIndex {
    // 上传数据
    [SVProgressHUD showWithStatus:@"正在上传数据"];
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
                             @"ecg_raw"         : _diagnostic.ecg_raw, // ecg原始数据
                             @"ecg_freq"        : @(_diagnostic.ecg_freq), // ecg采样率
                             @"spo2h_raw"       : _diagnostic.spo2h_raw, // 血氧原始数据
                             @"spo2h_freq"      : @(_diagnostic.spo2h_freq), // 血氧采样率
                             @"device_id"       : device_id?device_id:@"", // 设备id
                             @"device_key"      : device_key?device_key:@"", // 设备key
                             @"device_power"    : @(100),
                             @"device_soft_ver" : soft_v?soft_v:@"", // 软件版本
                             @"device_hard_ver" : hard_v?hard_v:@"", // 硬件版本
                             };
    [self.measureAPI uploadResult:params type:MTRothmanIndex completion:^(BOOL success, id result, NSString *msg) {
        
        if (success) {
            
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [SVProgressHUD dismissWithDelay:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 从数据库查最新的一条罗斯曼
                self.diagnostic = [self.measureAPI getNewestRothmanIndexInfo];
                // 刷新页面
                [self reloadRothmanIndex];
            });
        }
        else {
            [SVProgressHUD showErrorWithStatus:msg];
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
