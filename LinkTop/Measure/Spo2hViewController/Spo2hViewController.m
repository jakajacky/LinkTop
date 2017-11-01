//
//  Spo2hViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/20.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "Spo2hViewController.h"
#import "Spo2hView.h"
#import "MeasureAPI.h"
#import "UIView+Rotate.h"
#import "TripleECGView.h"
#import "LeadPlayer.h"
@interface Spo2hViewController ()

@property (nonatomic, strong) Spo2hView *spo2hView;
@property (nonatomic, strong) MeasureAPI *measureAPI;

@property (nonatomic, strong) TripleECGView *ecgLine;

@property (nonatomic, weak) NSTimer *drawingTimer, *popDataTimer;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) int index,drawNumbers;

@end

@implementation Spo2hViewController

@synthesize leads;
@synthesize liveMode, startRecordingIndex, HR, stopTheTimer;
@synthesize buffer, DEMO, newBornMode;

static int ind = 0;

int leadCount_s = 1;
int sampleRate_s = 500;
float uVpb_s = 0.9;
float drawingInterval_s = 0.04; // the interval is greater, the drawing is faster, but more choppy, smaller -> slower and smoother
int bufferSecond_s = 300;
float pixelPerUV_s = 5 * 10.0 / 1000;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) myself = self;
    ind = 0;
    self.spo2hView.navi.leftViewDidClicked = ^{
        [myself dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
    [self.spo2hView.startMeasureBtn addTarget:self
                                       action:@selector(startMeasureBtnDidClicked:)
                             forControlEvents:UIControlEventTouchUpInside];
    _dataArr = [NSMutableArray array];
    [self addViews];
    [self initialMonitor];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setLeadsLayout:self.interfaceOrientation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"Spo2hViewController 释放");
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
    CGFloat popDataInterval = 420.0f / sampleRate_s;
    
    popDataTimer = [NSTimer scheduledTimerWithTimeInterval:popDataInterval
                                                    target:self
                                                  selector:@selector(timerEvent_popData)
                                                  userInfo:NULL
                                                   repeats:YES];
}

- (void)startTimer_drawing
{
    drawingTimer = [NSTimer scheduledTimerWithTimeInterval:drawingInterval_s
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
    
    if (lead.pointsArray.count > bufferSecond_s * sampleRate_s)
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
    
    for (int i=0; i<leadCount_s; i++) {
        LeadPlayer *lead = [[LeadPlayer alloc] init];
        lead.isbgLine = YES;
        lead.layer.cornerRadius = 0;
        lead.backgroundColor = [UIColor clearColor];
        lead.layer.borderColor = [[UIColor grayColor] CGColor];
        lead.layer.borderWidth = 0;
        lead.clipsToBounds = YES;
        
        lead.index = i;
        lead.pointsArray = [[NSMutableArray alloc] init];
        
        lead.liveMonitor = self;
        
        [array insertObject:lead atIndex:i];
        
        [self.spo2hView.spo2hViewContainer addSubview:lead];
    }
    
    self.leads = array;
}

- (void)setLeadsLayout:(UIInterfaceOrientation)orientation
{
    float margin = 5;
    NSInteger leadHeight = self.spo2hView.spo2hViewContainer.height / leadCount_s;
    NSInteger leadWidth = self.spo2hView.spo2hViewContainer.width;
    scrollView.contentSize = self.spo2hView.spo2hViewContainer.size;
    
    for (int i=0; i<leadCount_s; i++)
    {
        LeadPlayer *lead = [self.leads objectAtIndex:i];
        float pos_y = i * (margin + leadHeight);
        
        [lead setFrame:CGRectMake(0., pos_y-8, leadWidth, leadHeight+20)];
        lead.pos_x_offset = lead.currentPoint;
        lead.alpha = 0;
        lead.isbgLine = YES;
        [lead setNeedsDisplay];
    }
    
    [UIView animateWithDuration:0.6f animations:^{
        for (int i=0; i<leadCount_s; i++)
        {
            LeadPlayer *lead = [self.leads objectAtIndex:i];
            lead.alpha = 1;
        }
    }];
}

- (void)startMeasureBtnDidClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 开始测量
        [self.spo2hView.tempre_loading startRotating];
        NSMutableString *spo_raw = [NSMutableString string];
        [[DeviceManger defaultManager] measureSpo2hWithConnect:^(CBPeripheral *peripheral) {
            
        } disconnect:^(CBPeripheral *peripheral) {
            
        } bleAbnormal:^{
            
        } receiveSpo2hData:^(double oxy) {
            [_dataArr addObject:@(oxy*4)];
            if (spo_raw.length==0) {
                [spo_raw appendFormat:@"%.0f",oxy];
            }
            else {
                [spo_raw appendFormat:@",%.0f",oxy];
            }
        } receiveSpo2hResult:^(double oxy, int heartrate) {
            [_dataArr removeAllObjects];
            _dataArr = nil;
            // 更新UI结果
            self.spo2hView.Spo2hValue.text     = [NSString stringWithFormat:@"%.0f",oxy];
            self.spo2hView.PulseRateValue.text = [NSString stringWithFormat:@"%d",heartrate];
            self.spo2hView.spo2h_unit.text = @"%";
            self.spo2hView.pulse_unit.text = @"bmp";
            
            // 上传数据
            Patient *user = [LoginManager defaultManager].currentPatient;
            NSString *device_id  = [DeviceManger defaultManager].deviceID;
            NSString *device_key = [DeviceManger defaultManager].deviceKEY;
            NSString *soft_v  = [DeviceManger defaultManager].softVersion;
            NSString *hard_v  = [DeviceManger defaultManager].hardVersion;
            NSDictionary *params = @{@"user_id"         : user.user_id,   // 用户名
                                     @"spo2h"           : @(oxy), // 血氧
                                     @"spo2h_raw"       : spo_raw,    // 血氧原始数据
                                     @"spo2h_freq"      : @(120), // 血氧采样率
                                     @"device_id"       : device_id?device_id:@"", // 设备id
                                     @"device_key"      : device_key?device_key:@"", // 设备key
                                     @"device_soft_ver" : soft_v?soft_v:@"", // 软件版本
                                     @"device_hard_ver" : hard_v?hard_v:@"", // 硬件版本
                                     };
            [self.measureAPI uploadResult:params type:MTSpo2h completion:^(BOOL success, id result, NSString *msg) {
                //结束
                self.spo2hView.startMeasureBtn.selected = NO;
                [self.spo2hView.tempre_loading stopRotating];
                if (success) {
                    
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"上传失败"];
                    [SVProgressHUD dismissWithDelay:1.5];
                }
            }];
        }];
        [self startLiveMonitoring];
    }
    else {
        // 结束测量
        [self.spo2hView.tempre_loading stopRotating];
        [[DeviceManger defaultManager] endMeasureSpo2h];
    }
}

#pragma mark - properties
- (Spo2hView *)spo2hView {
    if (!_spo2hView) {
        _spo2hView = (Spo2hView *)self.view;
    }
    return _spo2hView;
}

- (MeasureAPI *)measureAPI {
    if (!_measureAPI) {
        _measureAPI = [MeasureAPI biz];
    }
    return _measureAPI;
}

@end
