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
#import "RothmanCell.h"
#import "MeasureListModel.h"
#import "MeasureListView.h"
#import "UIImage+memory.h"
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
    [self.measureListView.listView registerNib:[UINib nibWithNibName:@"RothmanCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"RothmanCell"];
    
    self.measureListView.listView.delegate = self;
    self.measureListView.listView.dataSource = self;
    // 下拉刷新
    self.measureListView.listView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullToReloadMoreData)];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [SVProgressHUD showWithStatus:@"正在获取数据"];
    // 请求数据
    [self.measureListModel reloadData:^(BOOL success, NSString *msg) {
        if (success) {
            [SVProgressHUD dismiss];
            // 刷新
            if (self.measureListModel.dataSource.count<=0) {
                self.measureListView.isNull = YES;
            }
            else {
                self.measureListView.isNull = NO;
            }
            [self.measureListView.listView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:msg];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 清空数据源、起始页page置1，保证再次进入后，从新开始
    [self.measureListModel clearDatasource];
    /*
     * 清空数据后，刷新一下listView，否则listView缓存的的indexpath.
     * item有可能>=datasource.count，导致越界
     */
    [self.measureListView.listView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"MeasureListViewController 释放");
    [self.measureListView removeAllSubviews];
    self.measureListView = nil;
}

#pragma mark - 修改导航栏和状态栏渐变色
- (void)prepareNavigationColor {
    // iOS7之后，设置状态栏和导航栏统一背景色，是很简单的，但是渐变颜色又是特殊的一种
    [ChangeView2GradientColor changeView:self.navigationController.navigationBar toGradientColors:@[UIColorHex(#1F67B6),UIColorHex(#51A8F2),UIColorHex(#89BDF4),UIColorHex(#C1E4FE)]];
}

#pragma mark - 上拉刷新更早数据
- (void)pullToReloadMoreData {
    [self.measureListModel reloadData:^(BOOL success, NSString *msg) {
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
    else if (diag.type==MTRothmanIndex) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RothmanCell" forIndexPath:indexPath];
        RothmanCell *rothcell = (RothmanCell *)cell;
        rothcell.measureRecord = diag;
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
    else if (diag.type==MTRothmanIndex){
        return CGSizeMake((self.measureListView.listView.width-(2*kLeftandRightMargin)), 170);
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
