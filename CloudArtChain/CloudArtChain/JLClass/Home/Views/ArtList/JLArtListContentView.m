//
//  JLArtListContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/13.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLArtListContentView.h"
#import "JLNormalEmptyView.h"
#import "JLArtListWaterFlowLayout.h"
#import "JLArtListContentCell.h"

@interface JLArtListContentView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) JLNormalEmptyView *emptyView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JLArtListContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLArtListContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (self.type == JLArtListTypeMineAuctioning ||
        self.type == JLArtListTypeMarketAuctioning ||
        self.type == JLArtListTypeSearchAuctioning ||
        self.type == JLArtListTypeCollectAuctioning ||
        self.type == JLArtListTypePopularAuctioning ||
        self.type == JLArtListTypeOtherUserAuctioning) {
        cell.auctionsData = self.dataArray[indexPath.row];
    }else {
        cell.artDetailData = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScrollContentOffset:)]) {
        [self.delegate scrollViewDidScrollContentOffset:scrollView.contentOffset];
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell layoutSubviews];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == JLArtListTypeMineAuctioning ||
        self.type == JLArtListTypeMarketAuctioning ||
        self.type == JLArtListTypeSearchAuctioning ||
        self.type == JLArtListTypeCollectAuctioning ||
        self.type == JLArtListTypePopularAuctioning ||
        self.type == JLArtListTypeOtherUserAuctioning) {
        Model_auctions_Data *auctionData = self.dataArray[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(lookAuctionDetail:)]) {
            [self.delegate lookAuctionDetail:auctionData.ID];
        }
    }else {
        Model_art_Detail_Data *artDetailData = self.dataArray[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(lookArtDetail:)]) {
            [self.delegate lookArtDetail:artDetailData];
        }
    }
}

#pragma mark - private methods
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
    for (int i = 0; i < self.dataArray.count; i++) {
        Model_auctions_Data *model = self.dataArray[i];
        model.server_timestamp = @(model.server_timestamp.integerValue + 1).stringValue;
    }
    [self.collectionView reloadData];
}

- (void)endRefresh {
    if (self.collectionView.mj_header && self.collectionView.mj_header.isRefreshing) {
        [self.collectionView.mj_header endRefreshing];
    }
    if (self.collectionView.mj_footer && self.collectionView.mj_footer.isRefreshing) {
        if (self.dataArray.count < self.page * kPageSize) {
            [(JLRefreshFooter *)self.collectionView.mj_footer endWithNoMoreDataNotice];
        } else {
            [self.collectionView.mj_footer endRefreshing];
        }
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

#pragma mark - setters and getters
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self endRefresh];
    
    [self setNoDataShow];
    
    if (_dataArray.count &&
        (self.type == JLArtListTypeMineAuctioning ||
         self.type == JLArtListTypeMarketAuctioning ||
         self.type == JLArtListTypeSearchAuctioning ||
         self.type == JLArtListTypeCollectAuctioning ||
         self.type == JLArtListTypePopularAuctioning ||
         self.type == JLArtListTypeOtherUserAuctioning)) {
        [self createTimer];
    }
    
    BOOL isAuction = NO;
    if (self.type == JLArtListTypeMineAuctioning ||
        self.type == JLArtListTypeMarketAuctioning ||
        self.type == JLArtListTypeSearchAuctioning ||
        self.type == JLArtListTypeCollectAuctioning ||
        self.type == JLArtListTypePopularAuctioning ||
        self.type == JLArtListTypeOtherUserAuctioning) {
        isAuction = YES;
    }
    JLArtListWaterFlowLayout *layout = [JLArtListWaterFlowLayout layoutWithColoumn:2 data:_dataArray verticleMin:14.0f horizonMin:14.0f leftMargin:15.0f rightMargin:15.0f isAuction:isAuction];
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView reloadData];
}

- (void)setContentOffsetY:(CGFloat)contentOffsetY {
    self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x, contentOffsetY);
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        WS(weakSelf)
        BOOL isAuction = NO;
        if (self.type == JLArtListTypeMineAuctioning ||
            self.type == JLArtListTypeMarketAuctioning ||
            self.type == JLArtListTypeSearchAuctioning ||
            self.type == JLArtListTypeCollectAuctioning ||
            self.type == JLArtListTypePopularAuctioning ||
            self.type == JLArtListTypeOtherUserAuctioning) {
            isAuction = YES;
        }
        JLArtListWaterFlowLayout *layout = [JLArtListWaterFlowLayout layoutWithColoumn:2 data:self.dataArray verticleMin:14.0f horizonMin:14.0f leftMargin:15.0f rightMargin:15.0f isAuction:isAuction];

        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = JL_color_white_ffffff;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
//        _collectionView.contentInset = UIEdgeInsetsMake(self.topInset, 0, 0, 0);
        [_collectionView registerClass:[JLArtListContentCell class] forCellWithReuseIdentifier:@"cell"];
        if (self.isNeedRefresh) {
            _collectionView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshDatas)]) {
                    [weakSelf.delegate refreshDatas];
                }
            }];
            _collectionView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(loadMoreDatas)]) {
                    [weakSelf.delegate loadMoreDatas];
                }
            }];
        }
    }
    return _collectionView;
}

- (JLNormalEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JLNormalEmptyView alloc]initWithFrame:self.bounds];
    }
    return _emptyView;
}

@end
