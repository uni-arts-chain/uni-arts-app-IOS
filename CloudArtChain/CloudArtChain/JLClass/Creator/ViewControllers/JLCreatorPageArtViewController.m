//
//  JLCreatorPageArtViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLCreatorPageArtViewController.h"
#import "JLPagetableCollectionView.h"
#import "JLNormalEmptyView.h"
#import "JLPopularCollectionWaterLayout.h"
#import "JLPopularOriginalCollectionViewCell.h"

@interface JLCreatorPageArtViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, JLPagetableCollectionViewRequestDelegate>

@property (nonatomic, strong) JLPagetableCollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *artsArray;
@property (nonatomic, strong) JLNormalEmptyView *emptyView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JLCreatorPageArtViewController

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
    if (self.type == JLCreatorPageArtViewControllerTypeAuctioning) {
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
    if (self.type == JLCreatorPageArtViewControllerTypeAuctioning) {
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
        if (self.type == JLCreatorPageArtViewControllerTypeAuctioning) {
            isAuction = YES;
        }
        JLPopularCollectionWaterLayout *layout = [JLPopularCollectionWaterLayout layoutWithColoumn:2 data:self.artsArray verticleMin:14.0f horizonMin:14.0f leftMargin:15.0f rightMargin:15.0f isAuction:isAuction];
        _collectionView = [[JLPagetableCollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - (46.0f + KTouch_Responder_Height) - KStatusBar_Navigation_Height - 40) collectionViewLayout:layout];
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
- (void)requestAuctioningList {
    WS(weakSelf)
    Model_members_auctions_Req *request = [[Model_members_auctions_Req alloc] init];
    request.page = self.currentPage;
    request.per_page = kPageSize;
    request.author_id = self.authorId;
    Model_members_auctions_Rsp *response = [[Model_members_auctions_Rsp alloc] init];
    response.request = request;
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.artsArray removeAllObjects];
                
                weakSelf.endRefreshBlock(weakSelf.currentPage);
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

- (void)requestArtList {
    WS(weakSelf)
    Model_members_arts_Req *request = [[Model_members_arts_Req alloc] init];
    request.page = self.currentPage;
    request.per_page = kPageSize;
    request.author_id = self.authorId;
    Model_members_arts_Rsp *response = [[Model_members_arts_Rsp alloc] init];
    response.request = request;
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.artsArray removeAllObjects];
                
                weakSelf.endRefreshBlock(weakSelf.currentPage);
            }
            [weakSelf.artsArray addObjectsFromArray:response.body];
            [weakSelf endRefresh:response.body];
            [weakSelf.collectionView reloadData];
            [weakSelf setNoDataShow];
        }
    }];
}

- (void)headRefresh {
    self.currentPage = 1;
    if (self.type == JLCreatorPageArtViewControllerTypeAuctioning) {
        [self requestAuctioningList];
    }else {
        [self requestArtList];
    }
}

- (void)footRefresh {
    self.currentPage++;
    if (self.type == JLCreatorPageArtViewControllerTypeAuctioning) {
        [self requestAuctioningList];
    }else {
        [self requestArtList];
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
        _emptyView = [[JLNormalEmptyView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - (46.0f + KTouch_Responder_Height) - KStatusBar_Navigation_Height - 40)];
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
