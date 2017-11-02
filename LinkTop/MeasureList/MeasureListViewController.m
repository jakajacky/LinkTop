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
#import "MeasureListModel.h"
#import "MeasureListView.h"

@interface MeasureListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) MeasureListView  *measureListView;

@property (nonatomic, strong) MeasureListModel  *measureListModel;

@end

@implementation MeasureListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareNavigationColor];
    
    [self.measureListView.listView registerNib:[UINib nibWithNibName:@"ShareCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ShareCell"];
    [self.measureListView.listView registerNib:[UINib nibWithNibName:@"ECGCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ECGCell"];
    
    self.measureListView.listView.delegate = self;
    self.measureListView.listView.dataSource = self;
    // 下拉刷新
    self.measureListView.listView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullToReloadMoreData)];
    // 请求数据并刷新
    [self.measureListModel reloadData:^(BOOL success) {
        if (success) {
            // 数据
            [self.measureListView.listView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 修改导航栏和状态栏渐变色
- (void)prepareNavigationColor {
    // iOS7之后，设置状态栏和导航栏统一背景色，是很简单的，但是渐变颜色又是特殊的一种
    [ChangeView2GradientColor changeView:self.navigationController.navigationBar toGradientColors:@[UIColorHex(#1F67B6),UIColorHex(#51A8F2),UIColorHex(#89BDF4),UIColorHex(#C1E4FE)]];
}

#pragma mark - 上拉刷新更早数据
- (void)pullToReloadMoreData {
    [self.measureListModel reloadData:^(BOOL success) {
        [self.measureListView.listView.mj_footer endRefreshing];
        [self.measureListView.listView reloadData];
    }];
}

#pragma mark - datasource & delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    DiagnosticList *diag = self.measureListModel.dataSource[indexPath.item];
    if (diag.type==MTECG) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ECGCell" forIndexPath:indexPath];
        ECGCell *ecgc = (ECGCell *)cell;
        ecgc.measureRecord = diag;
    }
    else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareCell" forIndexPath:indexPath];
        ShareCell *sharcell = (ShareCell *)cell;
        sharcell.measureRecord = diag;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DiagnosticList *diag = self.measureListModel.dataSource[indexPath.item];
    if (diag.type==MTECG) {
        return CGSizeMake((self.measureListView.listView.width-(2*kLeftandRightMargin)), 150);
    }
    else {
        return CGSizeMake((self.measureListView.listView.width-(2*kLeftandRightMargin)), kItemHeight);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.measureListModel.dataSource.count;
}

#pragma mark - propertiese
- (MeasureListModel *)measureListModel {
    if (!_measureListModel) {
        _measureListModel = [[MeasureListModel alloc] init];
    }
    return _measureListModel;
}

- (MeasureListView *)measureListView {
    if (!_measureListView) {
        _measureListView = (MeasureListView *)self.view;
    }
    return _measureListView;
}

@end
