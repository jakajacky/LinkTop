//
//  DRSegmentControl.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/19.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "DRSegmentControl.h"

@interface DRSegmentControl ()

@property (nonatomic, strong) UIButton *segOne;
@property (nonatomic, strong) UIButton *segTwo;

@end

@implementation DRSegmentControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = 0;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _segOne = [UIButton buttonWithType:UIButtonTypeSystem];
    _segOne.frame = CGRectMake(0, 0, self.width/2.0, self.height);
    [_segOne setTitle:@"A" forState:UIControlStateNormal];
    [_segOne.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_segOne setTintColor:UIColorHex(#ffffff)];
    _segOne.backgroundColor = UIColorHex(#4A90E2);
    [_segOne addTarget:self action:@selector(segOneDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _segTwo = [UIButton buttonWithType:UIButtonTypeSystem];
    _segTwo.frame = CGRectMake(0, 0, self.width/2.0, self.height);
    [_segTwo setTitle:@"B" forState:UIControlStateNormal];
    [_segTwo.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_segTwo setTintColor:UIColorHex(#666666)];
    _segTwo.backgroundColor = UIColorHex(#DDDDDD);
    [_segTwo addTarget:self action:@selector(segTwoDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_segOne];
    [self addSubview:_segTwo];
    
    [_segOne autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_segOne autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_segOne autoSetDimensionsToSize:CGSizeMake(self.width/2.0, self.height)];
    
    [_segTwo autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_segTwo autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_segTwo autoSetDimensionsToSize:CGSizeMake(self.width/2.0, self.height)];
}

- (void)segOneDidClicked:(UIButton *)sender {
    if (_currentIndex==0) {
        return;
    }
    self.currentIndex = 0;
    if (_valueChangedBlock) {
        self.valueChangedBlock(_currentIndex);
    }
}

- (void)segTwoDidClicked:(UIButton *)sender {
    if (_currentIndex==1) {
        return;
    }
    self.currentIndex = 1;
    if (_valueChangedBlock) {
        self.valueChangedBlock(_currentIndex);
    }
}

#pragma mark - 设置当前选中
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    if (_currentIndex == 0) {
        [self didChangeWhileSegOneDidSelected:YES];
        [self didChangeWhileSegTwoDidSelected:NO];
    }
    else {
        [self didChangeWhileSegOneDidSelected:NO];
        [self didChangeWhileSegTwoDidSelected:YES];
    }
}

#pragma mark - 设置one标题
- (void)setSegOneTitle:(NSString *)segOneTitle {
    _segOneTitle = segOneTitle;
    [_segOne setTitle:_segOneTitle forState:UIControlStateNormal];
}

#pragma mark - 选择one后改变背景
- (void)didChangeWhileSegOneDidSelected:(BOOL)selected {
    if (selected) {
        [_segOne setTintColor:UIColorHex(#ffffff)];
        _segOne.backgroundColor = UIColorHex(#4A90E2);
    }
    else {
        [_segOne setTintColor:UIColorHex(#666666)];
        _segOne.backgroundColor = UIColorHex(#DDDDDD);
    }
}

#pragma mark - 设置two标题
- (void)setSegTwoTitle:(NSString *)segTwoTitle {
    _segTwoTitle = segTwoTitle;
    [_segTwo setTitle:_segTwoTitle forState:UIControlStateNormal];
}

#pragma mark - 选择two后改变背景
- (void)didChangeWhileSegTwoDidSelected:(BOOL)selected {
    if (selected) {
        [_segTwo setTintColor:UIColorHex(#ffffff)];
        _segTwo.backgroundColor = UIColorHex(#4A90E2);
    }
    else {
        [_segTwo setTintColor:UIColorHex(#666666)];
        _segTwo.backgroundColor = UIColorHex(#DDDDDD);
    }
}

- (void)dealloc {
    NSLog(@"DRSegmentControl释放");
    _segOne = nil;
    _segTwo = nil;
}

@end
