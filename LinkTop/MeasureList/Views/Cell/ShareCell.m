//
//  ShareCell.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "ShareCell.h"

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
    self.layer.shadowOffset = CGSizeMake(0, 5);
    self.layer.masksToBounds = YES;
}

- (void)setInfo:(NSString *)info {
    _info = info;
    
    self.timeL.text = info;
}

@end
