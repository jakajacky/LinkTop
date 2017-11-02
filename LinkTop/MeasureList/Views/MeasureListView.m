//
//  MeasureListView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/23.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "MeasureListView.h"
#import "VegaScrollFlowLayout.h"
#import "UIImage+memory.h"
@interface MeasureListView ()

@property (nonatomic, strong) VegaScrollFlowLayout *layout;

@property (nonatomic, strong) UIImageView *imgv;
@property (nonatomic, strong) UILabel *la;

@end

@implementation MeasureListView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupViews];
    [self.listView registerNib:[UINib nibWithNibName:@"ShareCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ShareCell"];
    [self.listView registerNib:[UINib nibWithNibName:@"ECGCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ECGCell"];
}

#pragma mark - 设置子视图
- (void)setupViews {
    _imgv = [[UIImageView alloc] initWithImage:[UIImage imageWithMName:@"nodata"]];
    _imgv.frame = CGRectMake(0, 0, 120, 80);
    [self addSubview:_imgv];
    _la = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    _la.text = @"暂无数据";
    _la.textColor = UIColorHex(#999999);
    _la.font = [UIFont systemFontOfSize:14];
    [self addSubview:_la];
    
    [_imgv autoSetDimensionsToSize:CGSizeMake(120, 80)];
    [_imgv autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_imgv autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:-30];
    
    [_la autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_imgv withOffset:10];
    [_la autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    _layout  = [[VegaScrollFlowLayout alloc] init];
    _listView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNaviBarHeight, self.width, self.height-kNaviBarHeight-kTabBarHeight) collectionViewLayout:_layout];
    _listView.backgroundColor = [UIColor clearColor];
    _layout.minimumLineSpacing = kItemSpacing;
    _layout.itemSize = CGSizeMake(kItemWidth, kItemHeight);
    // 决定整体的上下边距
    _layout.sectionInset = UIEdgeInsetsMake(kTopandBottomMargin, 0, kLeftandRightMargin-6, 0);
    
    /*
     * vega布局，一个缺点，自动恢复offset太快，不是无缝衔接的，
     * 但是如果增加下拉刷新后，这个缺点就可以忽略了
     * _listView.bounces = NO;
     */
    _listView.scrollsToTop = NO;
    
    [self addSubview:_listView];
}

- (void)setIsNull:(BOOL)isNull {
    _isNull = isNull;
    if (isNull) {
        _imgv.hidden = NO;
        _la.hidden = NO;
    }
    else {
        _imgv.hidden = YES;
        _la.hidden = YES;
    }
}

- (void)dealloc {
    NSLog(@"MeasureListView 释放");
    _imgv.image = nil;
    _imgv = nil;
    _la = nil;
    _listView = nil;
}

@end
