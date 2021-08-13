//
//  JLArtListViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/13.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLArtListViewController.h"
#import "JLArtListContentView.h"

#import "JLArtDetailViewController.h"
#import "JLNewAuctionArtDetailViewController.h"

@interface JLArtListViewController ()<JLArtListContentViewDelegate>

@property (nonatomic, strong) JLArtListContentView *contentView;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *dataArray;

/// 主题id
@property (nonatomic, copy) NSString *currentThemeID;
/// 类型id
@property (nonatomic, copy) NSString *currentTypeID;
/// 价格id
@property (nonatomic, copy) NSString *currentPriceID;

@end

@implementation JLArtListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.contentView];
    
    self.currentPage = 1;
    [self chooseMethodsLoadDatas];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelAuctionNotification) name:LOCALNOTIFICATION_JL_CANCEL_AUCTION object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOCALNOTIFICATION_JL_CANCEL_AUCTION object:nil];
    NSLog(@"释放了: %@", self.class);
}

#pragma mark - JLArtListContentViewDelegate
/// 下拉刷新数据
- (void)refreshDatas {
    self.currentPage = 1;
    [self chooseMethodsLoadDatas];
}
/// 上拉加载更多数据
- (void)loadMoreDatas {
    self.currentPage++;
    if (self.type == JLArtListTypeMineAuctioning ||
        self.type == JLArtListTypeMarketAuctioning ||
        self.type == JLArtListTypeSearchAuctioning ||
        self.type == JLArtListTypeCollectAuctioning ||
        self.type == JLArtListTypePopularAuctioning ||
        self.type == JLArtListTypeOtherUserAuctioning) {
        [self loadAuctionListData];
    }else {
        [self requestSellingList];
    }
}
/// 查看艺术品详情
/// @param artDetailData 艺术品信息
- (void)lookArtDetail: (Model_art_Detail_Data *)artDetailData {
    JLArtDetailViewController *vc = [[JLArtDetailViewController alloc] init];
    vc.artDetailData = artDetailData;
    vc.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
    [self.navigationController pushViewController:vc animated:YES];
}
/// 查看拍卖详情
/// @param auctionId 拍卖id
- (void)lookAuctionDetail: (NSString *)auctionId {
    JLNewAuctionArtDetailViewController *vc = [[JLNewAuctionArtDetailViewController alloc] init];
    vc.auctionsId = auctionId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification
- (void)cancelAuctionNotification {
    [self chooseMethodsLoadDatas];
}

#pragma mark - loadDatas
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
            
            [weakSelf.contentView setDatas:weakSelf.dataArray];
        } else {
            [weakSelf.contentView setDatas:weakSelf.dataArray];
        }
    }];
}

/// 拍卖列表
- (void)loadAuctionListData {
    WS(weakSelf)
    Model_auctions_list_Req *request = [[Model_auctions_list_Req alloc] init];
    request.page = self.currentPage;
    request.per_page = kPageSize;
    request.code = @"rmb";
    if (![NSString stringIsEmpty:self.currentThemeID]) {
        request.category_id = self.currentThemeID;
    }
    if (![NSString stringIsEmpty:self.currentTypeID]) {
        request.resource_type = self.currentTypeID;
    }
    if (![NSString stringIsEmpty:self.currentPriceID]) {
        request.price_sort = self.currentPriceID;
    }
    Model_auctions_list_Rsp *response = [[Model_auctions_list_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            [weakSelf.dataArray addObjectsFromArray:response.body];
            
            [weakSelf.contentView setDatas:weakSelf.dataArray];
        } else {
            [weakSelf.contentView setDatas:weakSelf.dataArray];
        }
    }];
}

#pragma mark - private methods
- (void)chooseMethodsLoadDatas {
    if (self.type == JLArtListTypeMineAuctioning ||
        self.type == JLArtListTypeMarketAuctioning ||
        self.type == JLArtListTypeSearchAuctioning ||
        self.type == JLArtListTypeCollectAuctioning ||
        self.type == JLArtListTypePopularAuctioning ||
        self.type == JLArtListTypeOtherUserAuctioning) {
        [self loadAuctionListData];
    }else {
        [self requestSellingList];
    }
}

#pragma mark - setters and getters
- (JLArtListContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLArtListContentView alloc] initWithFrame:self.view.bounds];
        _contentView.delegate = self;
        _contentView.type = self.type;
        _contentView.isNeedRefresh = self.isNeedRefresh;
        _contentView.topInset = self.topInset;
    }
    return _contentView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
