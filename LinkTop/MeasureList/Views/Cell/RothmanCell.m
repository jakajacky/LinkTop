//
//  RothmanCell.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/5.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "RothmanCell.h"
#import "TimeInterval2DateString.h"
@interface RothmanCell ()

@property (weak, nonatomic) IBOutlet UILabel *rothmanValue;
@property (weak, nonatomic) IBOutlet UILabel *bpValue;
@property (weak, nonatomic) IBOutlet UILabel *tempValue;
@property (weak, nonatomic) IBOutlet UILabel *spo2hValue;
@property (weak, nonatomic) IBOutlet UILabel *hrValue;
@property (weak, nonatomic) IBOutlet UILabel *brValue;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *rothmanDesc;
@property (weak, nonatomic) IBOutlet UIView *colorLine;

@end

@implementation RothmanCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 4;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.masksToBounds = YES;
}

- (void)setMeasureRecord:(DiagnosticList *)measureRecord {
    _measureRecord = measureRecord;
    // 时间
    NSString *dateStr = [TimeInterval2DateString TimeIntervalToDateString:measureRecord.create_date/1000];
    NSArray *s = [dateStr componentsSeparatedByString:@" "];
    self.timeL.text = s.lastObject;
    self.dateL.text = s.firstObject;
    self.rothmanValue.text = [NSString stringWithFormat:@"%ld",measureRecord.ri];
    self.bpValue.text = [NSString stringWithFormat:@"%@/%@ mmHg",measureRecord.sbp,measureRecord.dbp];
    self.tempValue.text  = [NSString stringWithFormat:@"%@ ℃",measureRecord.temp];
    self.spo2hValue.text = [NSString stringWithFormat:@"%@%%",measureRecord.spo2h];
    self.hrValue.text    = [NSString stringWithFormat:@"%@ bpm",measureRecord.hr];
    self.brValue.text    = [NSString stringWithFormat:@"%@ 次/分钟",measureRecord.respiration];
    
    // 罗斯曼描述
    if (measureRecord.ri<=40) {
        self.rothmanDesc.text = @"高风险";
        self.rothmanDesc.textColor = UIColorHex(#D0021B);
        self.colorLine.backgroundColor = UIColorHex(#D0021B);
    }
    else if (measureRecord.ri<=65) {
        self.rothmanDesc.text = @"中等风险";
        self.rothmanDesc.textColor = UIColorHex(#F5A623);
        self.colorLine.backgroundColor = UIColorHex(#F5A623);
    }
    else {
        self.rothmanDesc.text = @"低风险";
        self.rothmanDesc.textColor = UIColorHex(#4A90E2);
        self.colorLine.backgroundColor = UIColorHex(#4A90E2);
    }
}

@end
