//
//  ECGCell.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "ECGCell.h"

@interface ECGCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *rrmaxValue;
@property (weak, nonatomic) IBOutlet UILabel *rrminValue;
@property (weak, nonatomic) IBOutlet UILabel *moodValue;
@property (weak, nonatomic) IBOutlet UILabel *hrValue;


@end

@implementation ECGCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0, 5);
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
    NSArray *s = [dateStr componentsSeparatedByString:@" "];
    self.timeL.text = s.lastObject;
    self.dateL.text = s.firstObject;
    self.rrmaxValue.text = [NSString stringWithFormat:@"%ld",measureRecord.rr_max];
    self.rrminValue.text = [NSString stringWithFormat:@"%ld",measureRecord.rr_min];
    self.moodValue.text  = [NSString stringWithFormat:@"%ld",measureRecord.mood];
    self.hrValue.text    = [NSString stringWithFormat:@"%@",measureRecord.hr];
    
}

@end
