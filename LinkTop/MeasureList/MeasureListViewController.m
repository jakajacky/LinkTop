//
//  MeasureListViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/10.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "MeasureListViewController.h"
//#import "LinkTop-Swift.h"
#import "VegaScrollFlowLayout.h"
#import "ShareCell.h"
#import "ECGCell.h"

#define kTabBarHeight 49
#define kNaviBarHeight 64
#define kLeftandRightMargin 10
#define kTopandBottomMargin 8
#define kItemWidth (self.listView.width-(2*kLeftandRightMargin))
#define kItemHeight 87
#define kItemSpacing 4

@interface MeasureListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *listView;

@property (nonatomic, strong) VegaScrollFlowLayout *layout;

@end

@implementation MeasureListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareNavigationColor];
    
    [self setupViews];
    [self.listView registerNib:[UINib nibWithNibName:@"ShareCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ShareCell"];
    [self.listView registerNib:[UINib nibWithNibName:@"ECGCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ECGCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置子视图
- (void)setupViews {
    _layout  = [[VegaScrollFlowLayout alloc] init];
    _listView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNaviBarHeight, self.view.width, self.view.height-kNaviBarHeight-kTabBarHeight) collectionViewLayout:_layout];
    _listView.backgroundColor = [UIColor clearColor];
    _layout.minimumLineSpacing = kItemSpacing;
    _layout.itemSize = CGSizeMake(kItemWidth, kItemHeight);
    // 决定整体的上下边距
    _layout.sectionInset = UIEdgeInsetsMake(kTopandBottomMargin, 0, kLeftandRightMargin-6, 0);
    
    /*
     * vega布局，一个缺点，自动恢复offset太快，不是无缝衔接的，
     * 但是如果增加下拉刷新后，这个缺点就可以忽略了
     */
    _listView.bounces = NO;
    _listView.delegate = self;
    _listView.dataSource = self;
    [self.view addSubview:_listView];
}

#pragma mark - 修改导航栏和状态栏渐变色
- (void)prepareNavigationColor {
    // iOS7之后，设置状态栏和导航栏统一背景色，是很简单的，但是渐变颜色又是特殊的一种
    [ChangeView2GradientColor changeView:self.navigationController.navigationBar toGradientColors:@[UIColorHex(#1F67B6),UIColorHex(#51A8F2),UIColorHex(#89BDF4),UIColorHex(#C1E4FE)]];
}

#pragma mark - datasource & delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if (indexPath.item == 0 || indexPath.item == 7) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ECGCell" forIndexPath:indexPath];
        ECGCell *ecgc = (ECGCell *)cell;
        ecgc.index = indexPath.item;
        ecgc.info  = [NSString stringWithFormat:@"--%d",indexPath.item];
    }
    else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareCell" forIndexPath:indexPath];
        ShareCell *ecgc = (ShareCell *)cell;
        ecgc.index = indexPath.item;
        ecgc.info  = [NSString stringWithFormat:@"--%d",indexPath.item];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.item == 0 || indexPath.item == 7) {
        return CGSizeMake(kItemWidth, 150);
    }
    else {
        return CGSizeMake(kItemWidth, kItemHeight);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 17;
}

@end
