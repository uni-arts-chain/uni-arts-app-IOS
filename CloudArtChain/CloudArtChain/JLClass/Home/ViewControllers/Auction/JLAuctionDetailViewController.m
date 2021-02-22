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
@end

@implementation JLAuctionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"拍卖会详情";
    [self addBackItem];
    
    [self createView];
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
            [weakSelf.scrollView.mj_header endRefreshing];
        }];
    }
    return _scrollView;
}

- (JLAuctionDetailHeadView *)headerView {
    if (!_headerView) {
        _headerView = [[JLAuctionDetailHeadView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, AuctionDetailHeadHeight)];
    }
    return _headerView;
}

- (JLAuctionDetailTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[JLAuctionDetailTitleView alloc] initWithFrame:CGRectMake(0.0f, self.headerView.frameBottom, kScreenWidth, AuctionDetailTitleHeight)];
    }
    return _titleView;
}

- (JLAuctionDetailProductView *)productView {
    if (!_productView) {
        WS(weakSelf)
        _productView = [[JLAuctionDetailProductView alloc] initWithFrame:CGRectMake(0.0f, self.titleView .frameBottom, kScreenWidth, 66.0f + 250.0f * 5)];
        _productView.artDetailBlock = ^{
            JLAuctionArtDetailViewController *artDetailVC = [[JLAuctionArtDetailViewController alloc] init];
            artDetailVC.artDetailType = JLAuctionArtDetailTypeDetail;
            [weakSelf.navigationController pushViewController:artDetailVC animated:YES];
        };
    }
    return _productView;
}

@end
