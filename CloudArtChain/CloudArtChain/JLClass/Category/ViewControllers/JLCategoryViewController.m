//
//  JLCategoryViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCategoryViewController.h"
#import "JLSearchViewController.h"
#import "UICollectionWaterLayout.h"
#import "JLArtDetailViewController.h"

#import "JLCategoryNaviView.h"
#import "JLCateFilterView.h"
#import "JLCategoryWorkCollectionViewCell.h"

@interface JLCategoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) JLCategoryNaviView *cateNaviView;
@property (nonatomic, strong) JLCateFilterView *cateFilterView;
@property (nonatomic, strong) JLCateFilterView *themeFilterView;
@property (nonatomic, strong) JLCateFilterView *priceFilterView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation JLCategoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

- (void)createView {
    [self.view addSubview:self.cateNaviView];
    [self.view addSubview:self.cateFilterView];
    [self.view addSubview:self.themeFilterView];
    [self.view addSubview:self.priceFilterView];
    [self.view addSubview:self.collectionView];
}

- (JLCategoryNaviView *)cateNaviView {
    if (!_cateNaviView) {
        WS(weakSelf)
        _cateNaviView = [[JLCategoryNaviView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, KStatusBar_Navigation_Height)];
        _cateNaviView.searchBlock = ^{
            JLSearchViewController *searchVC = [[JLSearchViewController alloc] init];
            [weakSelf.navigationController pushViewController:searchVC animated:YES];
        };
    }
    return _cateNaviView;
}

- (JLCateFilterView *)cateFilterView {
    if (!_cateFilterView) {
        _cateFilterView = [[JLCateFilterView alloc] initWithFrame:CGRectMake(0.0f, self.cateNaviView.frameBottom, kScreenWidth, 40.0f) title:@"分类" items:@[@"油画", @"版画", @"水墨", @"水彩(粉)"] selectBlock:^(NSInteger index) {
            
        }];
    }
    return _cateFilterView;
}

- (JLCateFilterView *)themeFilterView {
    if (!_themeFilterView) {
        _themeFilterView = [[JLCateFilterView alloc] initWithFrame:CGRectMake(0.0f, self.cateFilterView.frameBottom, kScreenWidth, 40.0f) title:@"题材" items:@[@"风景", @"人物", @"静物", @"动物", @"花鸟", @"山水", @"其他"] selectBlock:^(NSInteger index) {
            
        }];
    }
    return _themeFilterView;
}

- (JLCateFilterView *)priceFilterView {
    if (!_priceFilterView) {
        _priceFilterView = [[JLCateFilterView alloc] initWithFrame:CGRectMake(0.0f, self.themeFilterView.frameBottom, kScreenWidth, 40.0f) title:@"价格" items:@[@"¥2,000以下", @"¥2,000-¥8,000", @"¥8,000-¥15,000", @"¥15,000以上"] selectBlock:^(NSInteger index) {
            
        }];
    }
    return _priceFilterView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:@[@"123", @"123", @"123", @"123", @"123", @"123", @"123", @"123", @"123", @"123", @"123", @"123", @"123", @"123"]];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionWaterLayout *layout = [UICollectionWaterLayout layoutWithColoumn:2 data:self.dataArray verticleMin:0.0f horizonMin:26.0f leftMargin:15.0f rightMargin:15.0f];

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.priceFilterView.frameBottom, kScreenWidth, kScreenHeight - self.priceFilterView.frameBottom - KTabBar_Height) collectionViewLayout:layout];
        _collectionView.backgroundColor = JL_color_white_ffffff;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[JLCategoryWorkCollectionViewCell class] forCellWithReuseIdentifier:@"JLCategoryWorkCollectionViewCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLCategoryWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLCategoryWorkCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
    artDetailVC.artDetailType = JLArtDetailTypeDetail;
    [self.navigationController pushViewController:artDetailVC animated:YES];
}
@end
