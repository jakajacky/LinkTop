//
//  ShareCell.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "ShareCell.h"
#import "UIView+Corner.h"
@interface ShareCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UIView *colorLine;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *resultValue;
@property (weak, nonatomic) IBOutlet UILabel *resultUnit;
@property (weak, nonatomic) IBOutlet UILabel *resultDesc;

@end

@implementation ShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.masksToBounds = YES;
}

- (void)setMeasureRecord:(DiagnosticList *)measureRecord {
    _measureRecord = measureRecord;
    // 时间
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:measureRecord.create_date/1000];
    NSString *dateStr = [formatter stringFromDate:date];
    self.timeL.text = dateStr;
    switch (measureRecord.type) {
            
        case MTBloodPresure:{
            self.titleL.text = @"血压";
            self.resultUnit.text = @"mmHg";
            self.resultValue.text = [NSString stringWithFormat:@"%@/%@",measureRecord.sbp,measureRecord.dbp];
            if ([measureRecord.sbp intValue]<=90 || [measureRecord.dbp intValue]<=60) {
                self.resultDesc.text = @"过低";
                self.colorLine.backgroundColor = UIColorHex(#F5A623);
            }
            else if ([measureRecord.sbp intValue]>=140 || [measureRecord.dbp intValue]>=90) {
                self.resultDesc.text = @"过高";
                self.colorLine.backgroundColor = UIColorHex(#D0021B);
            }
            else if ([measureRecord.sbp intValue]>=140 && [measureRecord.dbp intValue]<=60) {
                self.resultDesc.text = @"过高";
                self.colorLine.backgroundColor = UIColorHex(#D0021B);
            }
            else {
                self.resultDesc.text = @"正常";
                self.colorLine.backgroundColor = UIColorHex(#4A90E2);
            }
            break;
        }
        case MTTemperature:{
            self.titleL.text = @"体温";
            self.resultUnit.text = @"℃";
            self.resultValue.text = [NSString stringWithFormat:@"%@",measureRecord.temp];
            if ([measureRecord.temp intValue]<=36.2) {
                self.resultDesc.text = @"过低";
                self.colorLine.backgroundColor = UIColorHex(#F5A623);
            }
            else if ([measureRecord.temp intValue]>=37.3) {
                self.resultDesc.text = @"过高";
                self.colorLine.backgroundColor = UIColorHex(#D0021B);
            }
            else {
                self.resultDesc.text = @"正常";
                self.colorLine.backgroundColor = UIColorHex(#4A90E2);
            }
            break;
        }
        case MTSpo2h:{
            self.titleL.text = @"血氧";
            self.resultUnit.text = @"";
            self.resultValue.text = [NSString stringWithFormat:@"%@",measureRecord.spo2h];
            if ([measureRecord.spo2h intValue]<=94) {
                self.resultDesc.text = @"过低";
                self.colorLine.backgroundColor = UIColorHex(#F5A623);
            }
            else {
                self.resultDesc.text = @"正常";
                self.colorLine.backgroundColor = UIColorHex(#4A90E2);
            }
            break;
        }
        case MTHeartRate:{
            self.titleL.text = @"心率";
            self.resultUnit.text = @"bpm";
            self.resultValue.text = [NSString stringWithFormat:@"%@",measureRecord.hr];
            if ([measureRecord.hr intValue]<=55) {
                self.resultDesc.text = @"过低";
                self.colorLine.backgroundColor = UIColorHex(#F5A623);
            }
            else if ([measureRecord.hr intValue]>=100) {
                self.resultDesc.text = @"过高";
                self.colorLine.backgroundColor = UIColorHex(#D0021B);
            }
            else {
                self.resultDesc.text = @"正常";
                self.colorLine.backgroundColor = UIColorHex(#4A90E2);
            }
            break;
        }
        default:
            break;
    }
}

@end
