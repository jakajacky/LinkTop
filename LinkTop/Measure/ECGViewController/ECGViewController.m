//
//  ECGViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/22.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "ECGViewController.h"
#import "ECGView.h"
#import "LibHealthCombineSDK.h"
#import "SDKHealthMoniter.h"
#import "UIView+Rotate.h"
#import "TripleECGView.h"
#import "LeadPlayer.h"

@interface ECGViewController ()<sdkHealthMoniterDelegate>

@property (nonatomic, strong) ECGView *ecgView;
@property (nonatomic, strong) TripleECGView *ecgLine;
@property (nonatomic, strong) SDKHealthMoniter *sdkHealth;

@property (nonatomic, weak) NSTimer *drawingTimer, *popDataTimer;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) int index,drawNumbers;

@end

@implementation ECGViewController

@synthesize leads;
@synthesize liveMode, startRecordingIndex, HR, stopTheTimer;
@synthesize buffer, DEMO, newBornMode;

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
    // 启动服务
    [[LibHealthCombineSDK Instance] StartHealthMonitorServiceWithDelegate:self TcpStateChangeBlock:^(NSDictionary *dict) {
        
    }];
    
    // 获取健康检测仪SDK对象
    self.sdkHealth = [LibHealthCombineSDK Instance].LT_HealthMonitor;
    //    self.sdkHealth = [[SDKHealthMoniter alloc] init];
    //    self.sdkHealth.sdkHealthMoniterdelegate =self;
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

static int ind = 0;

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

- (void)startMeasureBtnDidClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 开始测量
        
        [self.sdkHealth startECG];
        
        [self startLiveMonitoring];
//        [self popDataTimerEvent];
//        [self.popDataTimer setFireDate:[NSDate distantPast]];
    }
    else {
        // 结束测量
        
        [self.sdkHealth endECG];
    }
    
}

#pragma mark - 蓝牙回调
- (void)didScanedPeripherals:(NSMutableArray *)foundPeripherals {
    NSLog(@"搜索到设备个数%ld",(long)foundPeripherals.count);
}

- (void)didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"连接到设备%@",peripheral);
}

- (void)disconnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"蓝牙断开连接");
}

/**
 * 测量温度的回调
 */
-(void)receiveThermometerData:(double)temperature {
    NSLog(@"体温测量结果：%f",temperature);
}


/**
 *  @discussion  Get Oximetry results
 *
 *  @param Oximetry Oximetry value
 *  @param heartRate heartRate value
 */
-(void)receiveOximetryData:(double)oxy andHeartRate:(int)heartRate {
    NSLog(@"血氧测量结果：%f, 脉率:%d",oxy,heartRate);
    
}




/**
 *  @discussion Get BloodPressure results
 *
 *  @param BloodPressure Systolic_pressure value Diastolic_pressure value
 *          Heart_beat value
 */
-(void)receiveBloodPressure:(int)Systolic_pressure andDiastolic_pressure:(int)Diastolic_pressure andHeart_beat:(int)Heart_beat {
    NSLog(@"血压测量结果：%d, %d",Systolic_pressure,Diastolic_pressure);

}

/**
 *  @discussion
 *
 *  @param msgtype msgType ENUM
 *  @param row     if row!=nil , according to this param ,invoke method getBloodSugarInRow in this object(SDKHealthMoniter) to transform blood sugar
 */
-(void) receiveBloodSugar:(MSGTYPE) msgtype andRow:(NSNumber*) row {
    
}



/**
 *  @discussion Get ECG results
 *
 *  @param ECGData rrMax value rrMin value HRV value
 *                  mood value smoothWave LineData heartRate Value
 */
-(void)receiveECGDataRRmax:(int)rrMax {
    NSLog(@"心电区间最大值：%d",rrMax);
}

-(void)receiveECGDataRRMin:(int)rrMin {
    NSLog(@"心电区间最小值：%d",rrMin);
}

-(void)receiveECGDataHRV:(int)hrv {
    NSLog(@"心率变异性：%d",hrv);
    [_dataArr removeAllObjects];
    _dataArr = nil;
}

-(void)receiveECGDataMood:(int)mood {
    NSLog(@"心情值：%d",mood);
}

-(void)receiveECGDataSmoothedWave:(int)smoothedWave {
    NSLog(@"revData：%d",smoothedWave);
    [_dataArr addObject:@(smoothedWave/5)];
}

-(void)receiveECGDataHeartRate:(int)heartRate {
    NSLog(@"心率结果：%d",heartRate);
    // 测量结束
//    [self.sdkHealth endECG];
    // 主线程修改UI
    dispatch_async(dispatch_get_main_queue(), ^{
        self.ecgView.startMeasureBtn.selected = NO;
        
    });
}

-(void)receiveECGDataBreathRate:(int)breathRate {
    NSLog(@"呼吸率：%d",breathRate);
}

/*!
 *  @method bloodPressureAbnormal
 *
 *  @param message   The <code>str</code> that abnormal message.
 *
 *  @discussion         This method is invoked when bloodPressure
 *  abnormal dicconnect
 */
-(void)bloodPressureAbnormal:(NSString *)message {
    NSLog(@"血压异常：%@",message);
}

#pragma mark - properties
- (ECGView *)ecgView {
    if (!_ecgView) {
        _ecgView = (ECGView *)self.view;
    }
    return _ecgView;
}

@end
