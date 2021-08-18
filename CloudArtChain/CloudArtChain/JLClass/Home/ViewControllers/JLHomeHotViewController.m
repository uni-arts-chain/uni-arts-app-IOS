//
//  JLHomeHotViewController.m
//  CloudArtChain
//
//  Created by 浮云骑士 on 2021/8/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLHomeHotViewController.h"
#import "JLPagetableCollectionView.h"
#import "JLNormalEmptyView.h"
#import "JLPopularCollectionWaterLayout.h"
#import "JLPopularOriginalCollectionViewCell.h"

@interface JLHomeHotViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, JLPagetableCollectionViewRequestDelegate>

@property (nonatomic, strong) JLPagetableCollectionView *collectionView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *artsArray;
@property (nonatomic, strong) JLNormalEmptyView *emptyView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JLHomeHotViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    [self headRefresh];
}

//这里是必须存在的方法 传递tableView的偏移量
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.collectionView.scrollViewDidScroll) {
        self.collectionView.scrollViewDidScroll(self.collectionView);
    }
}

- (void)JLPagetableCollectionView:(JLPagetableCollectionView *)JLPagetableView requestFailed:(NSError *)error {
    
}

- (void)JLPagetableCollectionView:(JLPagetableCollectionView *)JLPagetableView isPullDown:(BOOL)PullDown SuccessData:(id)SuccessData {
    //处理返回的SuccessData 数据之后刷新table
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.artsArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLPopularOriginalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLPopularOriginalCollectionViewCell" forIndexPath:indexPath];
    if (self.type == JLHomeHotViewControllerTypeAuctioning) {
        [cell setAuctionsData:self.artsArray[indexPath.row]];
    }else {
        [cell setPopularArtData:self.artsArray[indexPath.row]];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell layoutSubviews];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == JLHomeHotViewControllerTypeAuctioning) {
        if (self.lookAuctionDetailBlock) {
            self.lookAuctionDetailBlock(self.artsArray[indexPath.row]);
        }
    }else {
        if (self.lookArtDetailBlock) {
            self.lookArtDetailBlock(self.artsArray[indexPath.row]);
        }
    }
}

- (JLPagetableCollectionView *)collectionView {
    if (!_collectionView) {
        WS(weakSelf)
        BOOL isAuction = NO;
        if (self.type == JLHomeHotViewControllerTypeAuctioning) {
            isAuction = YES;
        }
        JLPopularCollectionWaterLayout *layout = [JLPopularCollectionWaterLayout layoutWithColoumn:2 data:self.artsArray verticleMin:14.0f horizonMin:14.0f leftMargin:15.0f rightMargin:15.0f isAuction:isAuction];
        _collectionView = [[JLPagetableCollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KTabBar_Height - KStatusBar_Navigation_Height - 40) collectionViewLayout:layout];
        _collectionView.backgroundColor = JL_color_white_ffffff;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.isHasHeaderRefresh = NO;
        [_collectionView registerClass:[JLPopularOriginalCollectionViewCell class] forCellWithReuseIdentifier:@"JLPopularOriginalCollectionViewCell"];
        _collectionView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footRefresh];
        }];
        _collectionView.scrollViewDidScroll = ^(UIScrollView *scrollView) {
            
        };
    }
    return _collectionView;
}

- (void)createTimer {
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
    for (int i = 0; i < self.artsArray.count; i++) {
        Model_auctions_Data *model = self.artsArray[i];
        model.server_timestamp = @(model.server_timestamp.integerValue + 1).stringValue;
    }
    [self.collectionView reloadData];
}

#pragma mark - loadDatas
// 热门原创
- (void)requestPopularSellingList {
    WS(weakSelf)
    Model_arts_popular_Req *request = [[Model_arts_popular_Req alloc] init];
    request.page = 1;
    request.per_page = 10;
    Model_arts_popular_Rsp *response = [[Model_arts_popular_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.artsArray removeAllObjects];
            }
            [weakSelf.artsArray addObjectsFromArray:response.body];
            [weakSelf endRefresh:response.body];
            [weakSelf.collectionView reloadData];
            [weakSelf setNoDataShow];
        }
    }];
}

// 精品拍卖
- (void)requestPopularAuctioningList {
    WS(weakSelf)
    Model_auctions_popular_Req *request = [[Model_auctions_popular_Req alloc] init];
    request.page = 1;
    request.per_page = 10;
    Model_auctions_popular_Rsp *response = [[Model_auctions_popular_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.artsArray removeAllObjects];
            }
            [weakSelf.artsArray addObjectsFromArray:response.body];
            [weakSelf endRefresh:response.body];
            [weakSelf.collectionView reloadData];
            [weakSelf setNoDataShow];
            
            if (weakSelf.artsArray.count) {
                [weakSelf createTimer];
            }
        }
    }];
}

- (void)headRefresh {
    self.currentPage = 1;
    if (self.type == JLHomeHotViewControllerTypeAuctioning) {
        [self requestPopularAuctioningList];
    }else {
        [self requestPopularSellingList];
    }
}

- (void)footRefresh {
    self.currentPage++;
    if (self.type == JLHomeHotViewControllerTypeAuctioning) {
        [self requestPopularAuctioningList];
    }else {
        [self requestPopularSellingList];
    }
}

- (void)endRefresh:(NSArray*)artsArray {
    if (artsArray.count < kPageSize) {
        [(JLRefreshFooter *)self.collectionView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.collectionView.mj_footer endRefreshing];
    }
}

- (JLNormalEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JLNormalEmptyView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KTabBar_Height - KStatusBar_Navigation_Height - 40)];
    }
    return _emptyView;
}

- (void)setNoDataShow {
    if (self.artsArray.count == 0) {
        [self.collectionView addSubview:self.emptyView];
    } else {
        if (_emptyView) {
            [self.emptyView removeFromSuperview];
            self.emptyView = nil;
        }
    }
}

- (NSMutableArray *)artsArray {
    if (!_artsArray) {
        _artsArray = [NSMutableArray array];
    }
    return _artsArray;
}

@end
