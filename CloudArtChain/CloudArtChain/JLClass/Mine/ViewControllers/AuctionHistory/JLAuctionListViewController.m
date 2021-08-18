//
//  JLAuctionListViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionListViewController.h"
#import "JLAuctionListContentView.h"

#import "JLAuctionSubmitOrderViewController.h"
#import "JLNewAuctionArtDetailViewController.h"

@interface JLAuctionListViewController ()<JLAuctionListContentViewDelegate>

@property (nonatomic, strong) JLAuctionListContentView *contentView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JLAuctionListViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    [self.view addSubview:self.contentView];
    
    [self loadDatas];
}

#pragma mark - JLAuctionListContentViewDelegate
- (void)refreshData {
    self.page = 1;
    [self loadDatas];
}

- (void)loadMoreData {
    self.page += 1;
    [self loadDatas];
}

- (void)payAuction:(NSString *)auctionsId {
    JLAuctionSubmitOrderViewController *vc = [[JLAuctionSubmitOrderViewController alloc] init];
    vc.auctionsId = auctionsId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lookAuctionDetail:(NSString *)auctionsId {
    JLNewAuctionArtDetailViewController *vc = [[JLNewAuctionArtDetailViewController alloc] init];
    vc.auctionsId = auctionsId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - loadDatas
- (void)loadDatas {
    Model_auctions_history_Req *request = [[Model_auctions_history_Req alloc] init];
    request.page = self.page;
    request.per_page = kPageSize;
    request.historyType = self.type;
    Model_auctions_history_Rsp *response = [[Model_auctions_history_Rsp alloc] init];
    response.request = request;
    
    if (self.dataArray.count == 0) {
        [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    }
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:response.body];
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
        [self.contentView setDataArray:[self.dataArray copy] page:self.page pageSize:kPageSize];
    }];
}

#pragma mark - public mehtods
- (void)refreshDatas {
    self.page = 1;
    [self loadDatas];
}

#pragma mark - setters and getters
- (JLAuctionListContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLAuctionListContentView alloc] initWithFrame:CGRectMake(0, _topInset, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - _topInset)];
        _contentView.delegate = self;
        _contentView.type = _type;
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
