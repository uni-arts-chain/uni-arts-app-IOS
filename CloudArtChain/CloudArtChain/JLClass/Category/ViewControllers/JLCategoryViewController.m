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
#import "JLNormalEmptyView.h"

@interface JLCategoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) JLCategoryNaviView *cateNaviView;
@property (nonatomic, strong) JLCateFilterView *cateFilterView;
@property (nonatomic, strong) JLCateFilterView *themeFilterView;
@property (nonatomic, strong) JLCateFilterView *priceFilterView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JLNormalEmptyView *emptyView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSString *currentCategoryID;
@property (nonatomic, strong) NSString *currentThemeID;
@property (nonatomic, strong) NSString *currentLT;
@property (nonatomic, strong) NSString *currentGTE;
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
    self.currentPage = 1;
    [self requestSellingList];
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
        WS(weakSelf)
        NSMutableArray *tempCateArray = [NSMutableArray array];
        for (Model_arts_categories_Data *cateData in [AppSingleton sharedAppSingleton].artCategoryArray) {
            [tempCateArray addObject:cateData.title];
        }
        _cateFilterView = [[JLCateFilterView alloc] initWithFrame:CGRectMake(0.0f, self.cateNaviView.frameBottom, kScreenWidth, 40.0f) title:@"分类" items:[tempCateArray copy] selectBlock:^(NSInteger index) {
            if (index == 0) {
                weakSelf.currentCategoryID = nil;
            } else {
                Model_arts_categories_Data *selectedCateData = [AppSingleton sharedAppSingleton].artCategoryArray[index - 1];
                weakSelf.currentCategoryID = selectedCateData.ID;
            }
            [weakSelf headRefresh];
        }];
    }
    return _cateFilterView;
}

- (JLCateFilterView *)themeFilterView {
    if (!_themeFilterView) {
        WS(weakSelf)
        NSMutableArray *tempThemeArray = [NSMutableArray array];
        for (Model_arts_themes_Data *themeData in [AppSingleton sharedAppSingleton].artThemeArray) {
            [tempThemeArray addObject:themeData.title];
        }
        _themeFilterView = [[JLCateFilterView alloc] initWithFrame:CGRectMake(0.0f, self.cateFilterView.frameBottom, kScreenWidth, 40.0f) title:@"题材" items:[tempThemeArray copy] selectBlock:^(NSInteger index) {
            if (index == 0) {
                weakSelf.currentThemeID = nil;
            } else {
                Model_arts_themes_Data *selectedThemeData = [AppSingleton sharedAppSingleton].artThemeArray[index - 1];
                weakSelf.currentThemeID = selectedThemeData.ID;
            }
            [weakSelf headRefresh];
        }];
    }
    return _themeFilterView;
}

- (JLCateFilterView *)priceFilterView {
    if (!_priceFilterView) {
        WS(weakSelf)
        NSMutableArray *tempPriceArray = [NSMutableArray array];
        for (Model_arts_prices_Data *priceData in [AppSingleton sharedAppSingleton].artPriceArray) {
            if ([NSString stringIsEmpty:priceData.lt]) {
                [tempPriceArray addObject:[NSString stringWithFormat:@"¥%@以上", priceData.gte]];
            } else if ([NSString stringIsEmpty:priceData.gte]) {
                [tempPriceArray addObject:[NSString stringWithFormat:@"¥%@以下", priceData.lt]];
            } else {
                [tempPriceArray addObject:[NSString stringWithFormat:@"¥%@-¥%@", priceData.gte, priceData.lt]];
            }
        }
        _priceFilterView = [[JLCateFilterView alloc] initWithFrame:CGRectMake(0.0f, self.themeFilterView.frameBottom, kScreenWidth, 40.0f) title:@"价格" items:[tempPriceArray copy] selectBlock:^(NSInteger index) {
            if (index == 0) {
                weakSelf.currentLT = nil;
                weakSelf.currentGTE = nil;
            } else {
                Model_arts_prices_Data *selectedPriceData = [AppSingleton sharedAppSingleton].artPriceArray[index - 1];
                weakSelf.currentLT = selectedPriceData.lt;
                weakSelf.currentGTE = selectedPriceData.gte;
            }
            [weakSelf headRefresh];
        }];
    }
    return _priceFilterView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        WS(weakSelf)
        UICollectionWaterLayout *layout = [UICollectionWaterLayout layoutWithColoumn:2 data:self.dataArray verticleMin:0.0f horizonMin:26.0f leftMargin:15.0f rightMargin:15.0f];

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.priceFilterView.frameBottom, kScreenWidth, kScreenHeight - self.priceFilterView.frameBottom - KTabBar_Height) collectionViewLayout:layout];
        _collectionView.backgroundColor = JL_color_white_ffffff;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[JLCategoryWorkCollectionViewCell class] forCellWithReuseIdentifier:@"JLCategoryWorkCollectionViewCell"];
        _collectionView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footRefresh];
        }];
        _collectionView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf headRefresh];
        }];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLCategoryWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLCategoryWorkCollectionViewCell" forIndexPath:indexPath];
    cell.artDetailData = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
    Model_art_Detail_Data *artDetailData = self.dataArray[indexPath.row];
    artDetailVC.artDetailType = [artDetailData.author.ID isEqualToString:[AppSingleton sharedAppSingleton].userBody.ID] ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
    artDetailVC.artDetailData = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:artDetailVC animated:YES];
}

- (JLNormalEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JLNormalEmptyView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height)];
    }
    return _emptyView;
}

- (void)headRefresh {
    self.currentPage = 1;
    self.collectionView.mj_footer.hidden = YES;
    [self requestSellingList];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestSellingList];
}

- (void)endRefresh:(NSArray*)collectionArray {
    [self.collectionView.mj_header endRefreshing];
    if (collectionArray.count < kPageSize) {
        self.collectionView.mj_footer.hidden = NO;
        [(JLRefreshFooter *)self.collectionView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.collectionView.mj_footer endRefreshing];
    }
}

- (void)setNoDataShow {
    if (self.dataArray.count == 0) {
        [self.collectionView addSubview:self.emptyView];
    } else {
        if (_emptyView) {
            [self.emptyView removeFromSuperview];
            self.emptyView = nil;
        }
    }
}

#pragma mark 请求selling list
- (void)requestSellingList {
    WS(weakSelf)
    Model_arts_selling_Req *request = [[Model_arts_selling_Req alloc] init];
    request.page = self.currentPage;
    request.per_page = kPageSize;
    if (![NSString stringIsEmpty:self.currentCategoryID]) {
        request.category_id = self.currentCategoryID;
    }
    if (![NSString stringIsEmpty:self.currentThemeID]) {
        request.theme_id = self.currentThemeID;
    }
    if (![NSString stringIsEmpty:self.currentGTE]) {
        request.price_gte = self.currentGTE;
    }
    if (![NSString stringIsEmpty:self.currentLT]) {
        request.price_lt = self.currentLT;
    }
    Model_arts_selling_Rsp *response = [[Model_arts_selling_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            [weakSelf.dataArray addObjectsFromArray:response.body];
            
            [weakSelf endRefresh:response.body];
            [self setNoDataShow];
            [self.collectionView reloadData];
        } else {
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
    }];
}

@end
