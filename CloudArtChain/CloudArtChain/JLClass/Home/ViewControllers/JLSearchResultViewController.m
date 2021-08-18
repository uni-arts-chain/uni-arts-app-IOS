//
//  JLSearchResultViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLSearchResultViewController.h"
#import "UICollectionWaterLayout.h"
#import "JLCategoryWorkCollectionViewCell.h"
#import "JLNormalEmptyView.h"

#import "JLArtDetailViewController.h"
#import "JLNewAuctionArtDetailViewController.h"

@interface JLSearchResultViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *resultCollectionView;

// 搜索结果数组
@property (nonatomic, strong) NSMutableArray *searchResultArray;

@property (nonatomic, strong) JLNormalEmptyView *emptyView;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JLSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.resultCollectionView];
    
    if (![NSString stringIsEmpty:self.searchText]) {
        [self startSearch];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.searchResultArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLCategoryWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLCategoryWorkCollectionViewCell" forIndexPath:indexPath];
    if (self.type == JLSearchResultViewControllerTypeAuctioning) {
        cell.auctionsData = self.searchResultArray[indexPath.row];
    }else {
        cell.artDetailData = self.searchResultArray[indexPath.row];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == JLSearchResultViewControllerTypeAuctioning) {
        Model_auctions_Data *auctionsData = self.searchResultArray[indexPath.row];
        JLNewAuctionArtDetailViewController *vc = [[JLNewAuctionArtDetailViewController alloc] init];
        vc.auctionsId = auctionsData.ID;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        Model_art_Detail_Data *artDetailData = self.searchResultArray[indexPath.row];
        JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
        artDetailVC.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
        artDetailVC.artDetailData = artDetailData;
        [self.navigationController pushViewController:artDetailVC animated:YES];
    }
}

#pragma mark 请求搜索数据
- (void)requestSearchList {
    WS(weakSelf)
    Model_arts_search_Req *request = [[Model_arts_search_Req alloc] init];
    request.q = self.searchText;
    request.page = self.currentPage;
    request.per_page = kPageSize;
    Model_arts_search_Rsp *response = [[Model_arts_search_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.searchResultArray removeAllObjects];
            }
            [weakSelf.searchResultArray addObjectsFromArray:response.body];
            
            [weakSelf endRefresh:response.body];
            [weakSelf setNoDataShow];
            [weakSelf.resultCollectionView reloadData];
        } else {
            NSLog(@"%@", errorStr);
        }
    }];
}

- (void)requestAuctionSearchDatas {
    WS(weakSelf)
    Model_auctions_search_Req *request = [[Model_auctions_search_Req alloc] init];
    request.q = self.searchText;
    request.page = self.currentPage;
    request.per_page = kPageSize;
    Model_auctions_search_Rsp *response = [[Model_auctions_search_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.searchResultArray removeAllObjects];
            }
            [weakSelf.searchResultArray addObjectsFromArray:response.body];
            
            [weakSelf endRefresh:response.body];
            [weakSelf setNoDataShow];
            [weakSelf.resultCollectionView reloadData];
            
            if (weakSelf.searchResultArray.count) {
                [weakSelf createTimer];
            }
        } else {
            NSLog(@"%@", errorStr);
        }
    }];
}

#pragma mark - private methods
- (void)startSearch {
    if (self.type == JLSearchResultViewControllerTypeAuctioning) {
        [self requestAuctionSearchDatas];
    }else {
        [self requestSearchList];
    }
}

- (void)footRefresh {
    self.currentPage++;
    [self startSearch];
}

- (void)endRefresh:(NSArray*)collectionArray {
    if (collectionArray.count < kPageSize) {
        [(JLRefreshFooter *)self.resultCollectionView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.resultCollectionView.mj_footer endRefreshing];
    }
}

- (void)setNoDataShow {
    if (self.searchResultArray.count == 0) {
        [self.resultCollectionView addSubview:self.emptyView];
    } else {
        if (_emptyView) {
            [self.emptyView removeFromSuperview];
            self.emptyView = nil;
        }
    }
}

- (void)createTimer {
    /// 是否有拍卖作品 有启动定时器
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    WS(weakSelf)
    self.timer = [NSTimer jl_scheduledTimerWithTimeInterval:1.0 block:^{
        [weakSelf handleTimer];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)handleTimer {
    for (int i = 0; i < self.searchResultArray.count; i++) {
        Model_auctions_Data *model = self.searchResultArray[i];
        model.server_timestamp = @(model.server_timestamp.integerValue + 1).stringValue;
    }
    [self.resultCollectionView reloadData];
}

#pragma mark - setters and getters
- (void)setSearchText:(NSString *)searchText {
    _searchText = searchText;
    
    self.currentPage = 1;
    [self startSearch];
}

- (UICollectionView *)resultCollectionView {
    if (!_resultCollectionView) {
        WS(weakSelf)
        BOOL isAuction = NO;
        if (self.type == JLSearchResultViewControllerTypeAuctioning) {
            isAuction = YES;
        }
        UICollectionWaterLayout *layout = [UICollectionWaterLayout layoutWithColoumn:2 data:self.searchResultArray verticleMin:14.0f horizonMin:14.0f leftMargin:15.0f rightMargin:15.0f isAuction:isAuction];
        
        _resultCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, _topInset, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - _topInset) collectionViewLayout:layout];
        _resultCollectionView.backgroundColor = JL_color_white_ffffff;
        _resultCollectionView.delegate = self;
        _resultCollectionView.dataSource = self;
        [_resultCollectionView registerClass:[JLCategoryWorkCollectionViewCell class] forCellWithReuseIdentifier:@"JLCategoryWorkCollectionViewCell"];
        _resultCollectionView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footRefresh];
        }];
    }
    return _resultCollectionView;
}

- (JLNormalEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JLNormalEmptyView alloc]initWithFrame:CGRectMake(0.0f, _topInset, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - _topInset)];
    }
    return _emptyView;
}

- (NSMutableArray *)searchResultArray {
    if (!_searchResultArray) {
        _searchResultArray = [NSMutableArray array];
    }
    return _searchResultArray;
}

@end
