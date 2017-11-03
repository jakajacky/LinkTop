//
//  ECGViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/22.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "ECGViewController.h"
#import "ECGView.h"
#import "MeasureAPI.h"
#import "UIView+Rotate.h"
#import "TripleECGView.h"
#import "LeadPlayer.h"

typedef void(^RothmanStepFourComplete)(BOOL,id);

@interface ECGViewController ()
{
    NSInteger _heartrate;
    NSInteger _rr;
    NSInteger _rr_max;
    NSInteger _rr_min;
    NSInteger _respiration;
    NSInteger _mood;
    NSInteger _hrv;
}
@property (nonatomic, strong) ECGView *ecgView;
@property (nonatomic, strong) TripleECGView *ecgLine;

@property (nonatomic, strong) MeasureAPI *measureAPI;

@property (nonatomic, weak) NSTimer *drawingTimer, *popDataTimer;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) int index,drawNumbers;
@property (nonatomic, copy)   RothmanStepFourComplete rothmanStepFourComplete;

@end

@implementation ECGViewController

@synthesize leads;
@synthesize liveMode, startRecordingIndex, HR, stopTheTimer;
@synthesize buffer, DEMO, newBornMode;

static int ind = 0;

int leadCount = 1;
int sampleRate = 500;
float uVpb = 0.9;
float drawingInterval = 0.04; // the interval is greater, the drawing is faster, but more choppy, smaller -> slower and smoother
int bufferSecond = 300;
float pixelPerUV = 5 * 10.0 / 1000;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) myself = self;
    ind = 0;
    self.ecgView.navi.leftViewDidClicked = ^{
        [myself dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
    [self.ecgView.startMeasureBtn addTarget:self
                                          action:@selector(startMeasureBtnDidClicked:)
                                forControlEvents:UIControlEventTouchUpInside];
    
    _dataArr = [NSMutableArray array];
    [self addViews];
    [self initialMonitor];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setLeadsLayout:self.interfaceOrientation];
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self startLiveMonitoring];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"ECGViewController 释放");
    _dataArr = nil;
    [self.view removeFromSuperview];
    [self.view removeAllSubviews];
    self.view = nil;
}

#pragma mark -
#pragma mark Initialization, Monitoring and Timer events

- (void)initialMonitor
{
    bufferCount = 10;
    
    NSMutableArray *buf = [[NSMutableArray alloc] init];
    self.buffer = buf;
}

- (void)startLiveMonitoring
{
    monitoring = YES;
    stopTheTimer = NO;
    
    [self startTimer_popDataFromBuffer];
    [self startTimer_drawing];
}

- (void)startTimer_popDataFromBuffer
{
    CGFloat popDataInterval = 420.0f / sampleRate;
    
    popDataTimer = [NSTimer scheduledTimerWithTimeInterval:popDataInterval
                                                    target:self
                                                  selector:@selector(timerEvent_popData)
                                                  userInfo:NULL
                                                   repeats:YES];
}

- (void)startTimer_drawing
{
    drawingTimer = [NSTimer scheduledTimerWithTimeInterval:drawingInterval
                                                    target:self
                                                  selector:@selector(timerEvent_drawing)
                                                  userInfo:NULL
                                                   repeats:YES];
}


- (void)timerEvent_drawing
{
    [self drawRealTime];
}

- (void)timerEvent_popData
{
    [self popDemoDataAndPushToLeads];
}

- (void)popDemoDataAndPushToLeads
{
    
    int length = 440;
    if (_dataArr.count<=length) {
        return;
    }
    NSArray *a;
    if (_dataArr.count - ind>=length) {
        a = [_dataArr subarrayWithRange:NSMakeRange(ind, length)];
    }
    else {
        a = [_dataArr subarrayWithRange:NSMakeRange(ind-(-_dataArr.count+ind+length), length)];
    }
    
    ind = _dataArr.count;
    
//    [_dataArr removeObjeactsInRange:NSMakeRange(0, length)];
    [self pushPoints:a data12Index:0];
}

- (void)pushPoints:(NSArray *)_pointsArray data12Index:(NSInteger)data12Index;
{
    LeadPlayer *lead = [self.leads objectAtIndex:data12Index];
    
    if (lead.pointsArray.count > bufferSecond * sampleRate)
    {
        [lead resetBuffer];
    }
    
    if (lead.pointsArray.count - lead.currentPoint <= 2000)
    {
        [lead.pointsArray addObjectsFromArray:_pointsArray];
    }
    
    if (data12Index==0)
    {
        countOfPointsInQueue = lead.pointsArray.count;
        currentDrawingPoint = lead.currentPoint;
    }
}

- (void)drawRealTime
{
    LeadPlayer *l = [self.leads objectAtIndex:0];
    
    if (l.pointsArray.count > l.currentPoint)
    {
        for (LeadPlayer *lead in self.leads)
        {
            [lead fireDrawing];
        }
    }
}

- (void)addViews
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i=0; i<leadCount; i++) {
        LeadPlayer *lead = [[LeadPlayer alloc] init];
        
        lead.layer.cornerRadius = 0;
        lead.layer.borderColor = [[UIColor grayColor] CGColor];
        lead.layer.borderWidth = 1;
        lead.clipsToBounds = YES;
        
        lead.index = i;
        lead.pointsArray = [[NSMutableArray alloc] init];
        
        lead.liveMonitor = self;
        
        [array insertObject:lead atIndex:i];
        
        [self.ecgView.ecgContainer addSubview:lead];
    }
    
    self.leads = array;
}

- (void)setLeadsLayout:(UIInterfaceOrientation)orientation
{
    float margin = 5;
    NSInteger leadHeight = self.ecgView.ecgContainer.height / leadCount;
    NSInteger leadWidth = self.ecgView.ecgContainer.width;
    scrollView.contentSize = self.ecgView.ecgContainer.size;
    
    for (int i=0; i<leadCount; i++)
    {
        LeadPlayer *lead = [self.leads objectAtIndex:i];
        float pos_y = i * (margin + leadHeight);
        
        [lead setFrame:CGRectMake(0., pos_y, leadWidth, leadHeight+20)];
        lead.pos_x_offset = lead.currentPoint;
        lead.alpha = 0;
        [lead setNeedsDisplay];
    }
    
    [UIView animateWithDuration:0.6f animations:^{
        for (int i=0; i<leadCount; i++)
        {
            LeadPlayer *lead = [self.leads objectAtIndex:i];
            lead.alpha = 1;
        }
    }];
}

#pragma mark - 开始&结束测量
- (void)startMeasureBtnDidClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.ecgView.resultView.hidden = NO;
    self.ecgView.tutorialView.hidden = YES;
    if (sender.selected) {
        // 开始测量
        ind = 0;
        NSMutableString *ecg_raw = [NSMutableString string];
        [[DeviceManger defaultManager] measureECGWithConnect:^(CBPeripheral *peripheral) {
            
        } disconnect:^(CBPeripheral *peripheral) {
            
        } bleAbnormal:^{
            
        } receiveRRMax:^(int rrmax) {
            _rr_max = rrmax;
            // 主线程修改UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ecgView.rrmaxValue.text = [NSString stringWithFormat:@"%d",rrmax];
                
            });
        } receiveRRMin:^(int rrmin) {
            _rr_min = rrmin;
            // 主线程修改UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ecgView.rrminValue.text = [NSString stringWithFormat:@"%d",rrmin];
                
            });
        } receiveHRV:^(int hrv) {
            _hrv = hrv;
            [_dataArr removeAllObjects];
            [drawingTimer invalidate];
            [popDataTimer invalidate];
            drawingTimer = nil;
            popDataTimer = nil;
            // 主线程修改UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ecgView.startMeasureBtn.selected = NO;
                self.ecgView.hrvValue.text = [NSString stringWithFormat:@"%d",hrv];
            });
            
            // 测量有误：
            if (_heartrate<=0) {
                return;
            }
            
            // 测量无误，但是结果异常：
            if (_isRothmanMeasure) {
                DiagnosticList *diag = [[DiagnosticList alloc] initWithDictionary:@{@"rr_max" : @(_rr_max),
                                                                                    @"rr_min" : @(_rr_min),
                                                                                    @"mood" : @(_mood),
                                                                                    @"hrv" : @(_hrv),
                                                                                    @"hr" : @(_heartrate),
                                                                                    @"respiration" : @(_respiration),
                                                                                    @"ecg_raw" : ecg_raw,
                                                                                    @"ecg_freq" : @(122)}];
                if (_heartrate<55 || _heartrate>100) {
                    _rothmanStepFourComplete(NO,diag); // 异常
                }
                else {
                    _rothmanStepFourComplete(YES,diag); // 正常
                }
                return;
            }
            
            // 上传数据
            [SVProgressHUD showWithStatus:@"正在上传"];
            Patient *user = [LoginManager defaultManager].currentPatient;
            NSString *device_id  = [DeviceManger defaultManager].deviceID;
            NSString *device_key = [DeviceManger defaultManager].deviceKEY;
            NSString *soft_v  = [DeviceManger defaultManager].softVersion;
            NSString *hard_v  = [DeviceManger defaultManager].hardVersion;
            NSDictionary *params = @{@"user_id"         : user.user_id,   // 用户名
                                     @"ecg_raw"         : ecg_raw, // 心电原始数据
                                     @"ecg_freq"        : @(122),// 心电采样率
                                     @"rr_max"          : @(_rr_max),  // 最大值
                                     @"rr_min"          : @(_rr_min),  // 最小值
                                     @"mood"            : @(_mood),    // 心情
                                     @"hrv"             : @(_hrv),        // 心率异常
                                     @"hr"              : @(_heartrate),   // 心率
                                     @"respiration"     : @(_respiration), // 呼吸率
                                     @"device_id"       : device_id?device_id:@"", // 设备id
                                     @"device_key"      : device_key?device_key:@"", // 设备key
                                     @"device_power"    : @(100),
                                     @"device_soft_ver" : soft_v?soft_v:@"", // 软件版本
                                     @"device_hard_ver" : hard_v?hard_v:@"", // 硬件版本
                                     };
            [self.measureAPI uploadResult:params type:MTECG completion:^(BOOL success, id result, NSString *msg) {
                
                if (success) {
                    // 清除字符串
                    [ecg_raw deleteCharactersInRange:NSMakeRange(0, ecg_raw.length)];
                    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                    [SVProgressHUD dismissWithDelay:1.5];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"上传失败"];
                    [SVProgressHUD dismissWithDelay:1.5];
                }
            }];
            
        } receiveMood:^(int mood) {
            _mood = mood;
        } receiveSmothWave:^(int revdata) {
            [_dataArr addObject:@(revdata/5)];
            if (ecg_raw.length==0) {
                [ecg_raw appendFormat:@"%d",revdata];
            }
            else {
                [ecg_raw appendFormat:@",%d",revdata];
            }
        } receiveHeartRate:^(int heartrate) {
            _heartrate = heartrate;
            // 主线程修改UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ecgView.hrValue.text = [NSString stringWithFormat:@"%d",heartrate];
                
            });
        } ReceiveBreathRateComplete:^(int breathrate) {
            _respiration = breathrate;
            // 主线程修改UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ecgView.brValue.text = [NSString stringWithFormat:@"%d",breathrate];
                
            });
        }];
        
        [self startLiveMonitoring];
//        [self popDataTimerEvent];
//        [self.popDataTimer setFireDate:[NSDate distantPast]];
    }
    else {
        // 结束测量
        [[DeviceManger defaultManager] endMeasureECG];
    }
    
}

- (void)startRothmanStepFourMeasureWithViewController:(UIViewController *)vc endCompletion:(void(^)(BOOL success,id result))complete {
    _rothmanStepFourComplete = complete;
    [vc presentViewController:self animated:YES completion:^{
        
    }];
}

#pragma mark - properties
- (ECGView *)ecgView {
    if (!_ecgView) {
        _ecgView = (ECGView *)self.view;
    }
    return _ecgView;
}

- (MeasureAPI *)measureAPI {
    if (!_measureAPI) {
        _measureAPI = [MeasureAPI biz];
    }
    return _measureAPI;
}

@end
