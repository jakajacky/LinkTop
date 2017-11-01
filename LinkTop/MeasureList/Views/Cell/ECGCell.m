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

- (void)setInfo:(NSString *)info {
    _info = info;
    
    self.timeL.text = info;
}

@end
