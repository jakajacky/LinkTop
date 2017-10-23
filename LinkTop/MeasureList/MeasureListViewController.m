//
//  MeasureListViewController.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/10.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "MeasureListViewController.h"
#import "LinkTop-Swift.h"

@interface MeasureListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *listView;

@end

@implementation MeasureListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareNavigationColor];
    
    [self setupViews];
    [self.listView registerNib:[UINib nibWithNibName:@"ShareCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ShareCell"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置子视图
- (void)setupViews {
    VegaScrollFlowLayout *layout  = [[VegaScrollFlowLayout alloc] init];
    _listView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, self.view.width, self.view.height-60-49) collectionViewLayout:layout];
    _listView.backgroundColor = [UIColor clearColor];
    layout.minimumLineSpacing = 4;
    layout.itemSize = CGSizeMake(_listView.width-20, 87);
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
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
    ShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareCell" forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 17;
}

@end
