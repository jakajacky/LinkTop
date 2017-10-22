//
//  ECGViewController.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/22.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LeadPlayer;
@interface ECGViewController : UIViewController
{
NSMutableArray *leads, *buffer;
NSTimer *drawingTimer, *readDataTimer, *recordingTimer, *popDataTimer, *playSoundTimer;

UIImage *recordingImage;

int second;
BOOL stopTheTimer, autoStart, DEMO, monitoring;

UIButton *btnStart, *btnStop, *photoView;

UIScrollView *scrollView;
UIImage *screenShot;

int layoutScale;  // 0: 3x4   1: 2x6   2: 1x12
int startRecordingIndex, endRecordingIndex, HR;

NSString *now;
BOOL liveMode;
UILabel *labelRate, *labelProfileId, *labelProfileName, *labelMsg;
UIBarButtonItem *statusInfo, *btnDismiss, *btnRefresh;


int countOfPointsInQueue, countOfRecordingPoints;
int currentDrawingPoint, bufferCount;


LeadPlayer *firstLead;

int lastHR;
int newBornMode, errorCount;
}

@property (nonatomic, strong) NSMutableArray *leads, *buffer;
@property (nonatomic) BOOL liveMode, DEMO;
@property (nonatomic) int startRecordingIndex, HR, newBornMode;
@property (nonatomic) BOOL stopTheTimer;

@end
