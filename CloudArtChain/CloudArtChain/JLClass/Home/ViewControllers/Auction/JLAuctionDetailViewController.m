//
//  JLAuctionDetailViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/4.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLAuctionDetailViewController.h"
#import "JLAuctionArtDetailViewController.h"

#import "JLAuctionDetailHeadView.h"
#import "JLAuctionDetailTitleView.h"
#import "JLAuctionDetailProductView.h"

#define AuctionDetailHeadHeight 218.0f
#define AuctionDetailTitleHeight 110.0f

@interface JLAuctionDetailViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JLAuctionDetailHeadView *headerView;
@property (nonatomic, strong) JLAuctionDetailTitleView *titleView;
@property (nonatomic, strong) JLAuctionDetailProductView *productView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *auctionArtArray;
@end

@implementation JLAuctionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"拍卖会详情";
    [self addBackItem];
    
    self.currentPage = 1;
    [self createView];
    [self requestAuctionMeetingArtList];
}

- (void)createView {
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.titleView];
    [self.scrollView addSubview:self.productView];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.productView.frameBottom);
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        WS(weakSelf)
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = JL_color_gray_F5F5F5;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
            weakSelf.currentPage = 1;
            [weakSelf requestAuctionMeetingArtList];
        }];
        _scrollView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            weakSelf.currentPage++;
            [weakSelf requestAuctionMeetingArtList];
        }];
    }
    return _scrollView;
}

- (JLAuctionDetailHeadView *)headerView {
    if (!_headerView) {
        _headerView = [[JLAuctionDetailHeadView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, AuctionDetailHeadHeight)];
        _headerView.auctionMeetingData = self.auctionMeetingData;
    }
    return _headerView;
}

- (JLAuctionDetailTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[JLAuctionDetailTitleView alloc] initWithFrame:CGRectMake(0.0f, self.headerView.frameBottom, kScreenWidth, AuctionDetailTitleHeight)];
        _titleView.auctionMeetingData = self.auctionMeetingData;
    }
    return _titleView;
}

- (JLAuctionDetailProductView *)productView {
    if (!_productView) {
        WS(weakSelf)
        _productView = [[JLAuctionDetailProductView alloc] initWithFrame:CGRectMake(0.0f, self.titleView .frameBottom, kScreenWidth, 66.0f)];
        _productView.artDetailBlock = ^(Model_auction_meetings_arts_Data * _Nonnull artsData) {
            JLAuctionArtDetailViewController *artDetailVC = [[JLAuctionArtDetailViewController alloc] init];
            artDetailVC.artDetailType = JLAuctionArtDetailTypeDetail;
            artDetailVC.artsData = artsData;
            [weakSelf.navigationController pushViewController:artDetailVC animated:YES];
        };
    }
    return _productView;
}

#pragma mark 获取拍卖会作品列表
- (void)requestAuctionMeetingArtList {
    WS(weakSelf)
    Model_auction_meetings_arts_Req *request = [[Model_auction_meetings_arts_Req alloc] init];
    request.page = self.currentPage;
    request.per_page = kPageSize;
    request.meeting_id = self.auctionMeetingData.ID;
    
    Model_auction_meetings_arts_Rsp *response = [[Model_auction_meetings_arts_Rsp alloc] init];
    response.request = request;
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.auctionArtArray removeAllObjects];
            }
            [weakSelf.auctionArtArray addObjectsFromArray:response.body];
            
            [weakSelf.scrollView.mj_header endRefreshing];
            if (response.body.count < kPageSize) {
                [(JLRefreshFooter *)weakSelf.scrollView.mj_footer endWithNoMoreDataNotice];
            } else {
                [weakSelf.scrollView.mj_footer endRefreshing];
            }
            NSInteger row = weakSelf.auctionArtArray.count / 2;
            if (weakSelf.auctionArtArray.count % 2 != 0) {
                row += 1;
            }
            weakSelf.productView.frame = CGRectMake(0.0f, weakSelf.titleView.frameBottom, kScreenWidth, 66.0f + 250.0f * row);
            weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, weakSelf.productView.frameBottom);
            [weakSelf.productView setAuctionMeetingData:weakSelf.auctionMeetingData auctionArtList:weakSelf.auctionArtArray];
        } else {
            [weakSelf.scrollView.mj_header endRefreshing];
            [weakSelf.scrollView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 懒加载初始化
- (NSMutableArray *)auctionArtArray {
    if (!_auctionArtArray) {
        _auctionArtArray = [NSMutableArray array];
    }
    return _auctionArtArray;
}

@end
