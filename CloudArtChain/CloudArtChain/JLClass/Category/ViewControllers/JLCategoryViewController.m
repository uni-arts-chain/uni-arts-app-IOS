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
#import "JLAuctionArtDetailViewController.h"
#import "JLWechatPayWebViewController.h"
#import "JLAlipayWebViewController.h"

#import "JLCategoryNaviView.h"
#import "JLCateFilterView.h"
#import "JLCategoryWorkCollectionViewCell.h"
#import "JLNormalEmptyView.h"

@interface JLCategoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) JLCategoryNaviView *cateNaviView;
@property (nonatomic, strong) JLCateFilterView *themeFilterView;
@property (nonatomic, strong) JLCateFilterView *typeFilterView;
@property (nonatomic, strong) JLCateFilterView *priceFilterView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JLNormalEmptyView *emptyView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSString *currentThemeID;
@property (nonatomic, strong) NSString *currentTypeID;
@property (nonatomic, strong) NSString *currentPriceID;
@end

@implementation JLCategoryViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self createView];
    self.currentPage = 1;
    [self requestSellingList];
}

- (void)createView {
    [self.view addSubview:self.cateNaviView];
    [self.view addSubview:self.themeFilterView];
    [self.view addSubview:self.typeFilterView];
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

- (JLCateFilterView *)themeFilterView {
    if (!_themeFilterView) {
        WS(weakSelf)
        NSMutableArray *tempThemeArray = [NSMutableArray array];
        for (Model_arts_theme_Data *themeData in [AppSingleton sharedAppSingleton].artThemeArray) {
            [tempThemeArray addObject:themeData.title];
        }
        _themeFilterView = [[JLCateFilterView alloc] initWithFrame:CGRectMake(0.0f, self.cateNaviView.frameBottom, kScreenWidth, 40.0f) title:@"主题" items:[tempThemeArray copy] selectBlock:^(NSInteger index) {
            if (index == 0) {
                weakSelf.currentThemeID = nil;
            } else {
                Model_arts_theme_Data *selectedThemeData = [AppSingleton sharedAppSingleton].artThemeArray[index - 1];
                weakSelf.currentThemeID = selectedThemeData.ID;
            }
            [weakSelf headRefresh];
        }];
        [self refreshThemeFilterView];
    }
    return _themeFilterView;
}

- (void)refreshThemeFilterView {
    WS(weakSelf)
    if ([AppSingleton sharedAppSingleton].artThemeArray.count == 0) {
        // 重新请求列表
        [[AppSingleton sharedAppSingleton] requestArtThemeWithSuccessBlock:^{
            NSMutableArray *tempThemeArray = [NSMutableArray array];
            for (Model_arts_theme_Data *themeData in [AppSingleton sharedAppSingleton].artThemeArray) {
                [tempThemeArray addObject:themeData.title];
            }
            [weakSelf.themeFilterView refreshItems:[tempThemeArray copy]];
        }];
    }
}

- (JLCateFilterView *)typeFilterView {
    if (!_typeFilterView) {
        WS(weakSelf)
        NSMutableArray *tempTypeArray = [NSMutableArray array];
        for (Model_arts_art_types_Data *typeData in [AppSingleton sharedAppSingleton].artTypeArray) {
            [tempTypeArray addObject:typeData.title];
        }
        _typeFilterView = [[JLCateFilterView alloc] initWithFrame:CGRectMake(0.0f, self.themeFilterView.frameBottom, kScreenWidth, 40.0f) title:@"类型" items:[tempTypeArray copy] selectBlock:^(NSInteger index) {
            if (index == 0) {
                weakSelf.currentTypeID = nil;
            } else {
                Model_arts_art_types_Data *selectedTypeData = [AppSingleton sharedAppSingleton].artTypeArray[index - 1];
                weakSelf.currentTypeID = selectedTypeData.ID;
            }
            [weakSelf headRefresh];
        }];
        [self refreshTypeFilterView];
    }
    return _typeFilterView;
}

- (void)refreshTypeFilterView {
    WS(weakSelf)
    if ([AppSingleton sharedAppSingleton].artTypeArray.count == 0) {
        // 重新请求列表
        [[AppSingleton sharedAppSingleton] requestArtTypeWithSuccessBlock:^{
            NSMutableArray *tempTypeArray = [NSMutableArray array];
            for (Model_arts_art_types_Data *typeData in [AppSingleton sharedAppSingleton].artTypeArray) {
                [tempTypeArray addObject:typeData.title];
            }
            [weakSelf.typeFilterView refreshItems:[tempTypeArray copy]];
        }];
    }
}

- (JLCateFilterView *)priceFilterView {
    if (!_priceFilterView) {
        WS(weakSelf)
        NSMutableArray *tempPriceArray = [NSMutableArray array];
        for (Model_arts_prices_Data *priceData in [AppSingleton sharedAppSingleton].artPriceArray) {
            [tempPriceArray addObject:priceData.title];
        }
        NSInteger defaultSelectIndex = 1; // 从1开始
        _priceFilterView = [[JLCateFilterView alloc] initWithFrame:CGRectMake(0.0f, self.typeFilterView.frameBottom, kScreenWidth, 40.0f) title:@"价格" items:[tempPriceArray copy] defaultSelectIndex:defaultSelectIndex selectBlock:^(NSInteger index) {
            if (index == 0) {
                weakSelf.currentPriceID = nil;
            } else {
                Model_arts_prices_Data *selectedPriceData = [AppSingleton sharedAppSingleton].artPriceArray[index - 1];
                weakSelf.currentPriceID = selectedPriceData.ID;
            }
            [weakSelf headRefresh];
        }];
        [self refreshPriceFilterView: defaultSelectIndex];
    }
    return _priceFilterView;
}

- (void)refreshPriceFilterView: (NSInteger)defaultSelectIndex {
    WS(weakSelf)
    if ([AppSingleton sharedAppSingleton].artPriceArray.count == 0) {
        // 重新请求列表
        [[AppSingleton sharedAppSingleton] requestArtPriceWithSuccessBlock:^{
            NSMutableArray *tempPriceArray = [NSMutableArray array];
            for (Model_arts_prices_Data *priceData in [AppSingleton sharedAppSingleton].artPriceArray) {
                [tempPriceArray addObject:priceData.title];
            }
            if (defaultSelectIndex >= 1 && defaultSelectIndex <= [AppSingleton sharedAppSingleton].artPriceArray.count) {
                weakSelf.currentPriceID = [AppSingleton sharedAppSingleton].artPriceArray[defaultSelectIndex - 1].ID;
                
                [self requestSellingList];
            }
            
            [weakSelf.priceFilterView refreshItems:[tempPriceArray copy]];
        }];
    }else {
        if (defaultSelectIndex >= 1 && defaultSelectIndex <= [AppSingleton sharedAppSingleton].artPriceArray.count) {
            self.currentPriceID = [AppSingleton sharedAppSingleton].artPriceArray[defaultSelectIndex - 1].ID;
        }
    }
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
        UICollectionWaterLayout *layout = [UICollectionWaterLayout layoutWithColoumn:2 data:self.dataArray verticleMin:14.0f horizonMin:14.0f leftMargin:15.0f rightMargin:15.0f];

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

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell layoutSubviews];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    Model_art_Detail_Data *artDetailData = self.dataArray[indexPath.row];
    if ([artDetailData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        JLAuctionArtDetailViewController *auctionDetailVC = [[JLAuctionArtDetailViewController alloc] init];
        auctionDetailVC.artDetailType = [artDetailData.author.ID isEqualToString:[AppSingleton sharedAppSingleton].userBody.ID] ? JLAuctionArtDetailTypeSelf : JLAuctionArtDetailTypeDetail;
        Model_auction_meetings_arts_Data *meetingsArtsData = [[Model_auction_meetings_arts_Data alloc] init];
        meetingsArtsData.art = artDetailData;
        auctionDetailVC.artsData = meetingsArtsData;
        [self.navigationController pushViewController:auctionDetailVC animated:YES];
    } else {
        JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
        artDetailVC.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
        artDetailVC.artDetailData = self.dataArray[indexPath.row];
        artDetailVC.backBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            if ([artDetailData.aasm_state isEqualToString:@"bidding"]) {
                [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:artDetailData];
            } else {
                [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
                [weakSelf.collectionView reloadData];
            }
        };
        __weak JLArtDetailViewController *weakArtDetailVC = artDetailVC;
        artDetailVC.buySuccessDeleteBlock = ^(JLOrderPayType payType, NSString * _Nonnull payUrl) {
            [weakArtDetailVC.navigationController popViewControllerAnimated:NO];
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
            [weakSelf.collectionView reloadData];
            if (payType == JLOrderPayTypeWeChat) {
                // 调用支付
                JLWechatPayWebViewController *payWebVC = [[JLWechatPayWebViewController alloc] init];
                payWebVC.payUrl = payUrl;
                [weakSelf.navigationController pushViewController:payWebVC animated:YES];
            } else {
                JLAlipayWebViewController *payWebVC = [[JLAlipayWebViewController alloc] init];
                payWebVC.payUrl = payUrl;
                [weakSelf.navigationController pushViewController:payWebVC animated:YES];
            }
        };
        [self.navigationController pushViewController:artDetailVC animated:YES];
    }
}

- (JLNormalEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JLNormalEmptyView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height)];
    }
    return _emptyView;
}

- (void)headRefresh {
    self.currentPage = 1;
    [self requestSellingList];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestSellingList];
}

- (void)endRefresh:(NSArray*)collectionArray {
    [self.collectionView.mj_header endRefreshing];
    if (collectionArray.count < kPageSize) {
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
    if (![NSString stringIsEmpty:self.currentThemeID]) {
        request.category_id = self.currentThemeID;
    }
    if (![NSString stringIsEmpty:self.currentTypeID]) {
        request.resource_type = self.currentTypeID;
    }
    if (![NSString stringIsEmpty:self.currentPriceID]) {
        request.price_sort = self.currentPriceID;
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
