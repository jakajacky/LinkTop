//
//  MeasureListView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/23.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "MeasureListView.h"
#import "VegaScrollFlowLayout.h"

#define kTabBarHeight 49
#define kNaviBarHeight 64
#define kLeftandRightMargin 10
#define kTopandBottomMargin 8
#define kItemWidth (self.listView.width-(2*kLeftandRightMargin))
#define kItemHeight 87
#define kItemSpacing 4
@interface MeasureListView ()

@property (nonatomic, strong) VegaScrollFlowLayout *layout;

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

@end
