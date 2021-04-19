//
//  JLCollectViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/4.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLCollectViewController.h"
#import "JLArtDetailViewController.h"
#import "JLAuctionArtDetailViewController.h"

#import "JLPopularOriginalCollectionViewCell.h"
#import "JLNormalEmptyView.h"
#import "JLFavorateCollectionWaterLayout.h"

@interface JLCollectViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) JLNormalEmptyView *emptyView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *collectionArray;
@end

@implementation JLCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"作品收藏";
    [self addBackItem];
    
    [self createSubViews];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)createSubViews {
    [self.view addSubview:self.collectionView];
    [self.collectionView  registerClass:[JLPopularOriginalCollectionViewCell class] forCellWithReuseIdentifier:@"JLPopularOriginalCollectionViewCell"];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
    }];
}

#pragma mark - 懒加载
-(UICollectionView*)collectionView {
    if (!_collectionView) {
        WS(weakSelf)
        JLFavorateCollectionWaterLayout *layout = [JLFavorateCollectionWaterLayout layoutWithColoumn:2 data:self.collectionArray verticleMin:14.0f horizonMin:14.0f leftMargin:15.0f rightMargin:15.0f];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height) collectionViewLayout:layout];
        _collectionView.backgroundColor = JL_color_white_ffffff;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = JL_color_white_ffffff;
        _collectionView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf headRefresh];
        }];
        _collectionView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footRefresh];
        }];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLPopularOriginalCollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"JLPopularOriginalCollectionViewCell" forIndexPath:indexPath];
    Model_members_favorate_arts_Data *facorateArtsData = self.collectionArray[indexPath.row];
    cell.collectionArtData = facorateArtsData.favoritable;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell layoutSubviews];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    Model_members_favorate_arts_Data *facorateArtsData = self.collectionArray[indexPath.row];
    Model_art_Detail_Data *artDetailData = facorateArtsData.favoritable;
    if ([artDetailData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        JLAuctionArtDetailViewController *auctionDetailVC = [[JLAuctionArtDetailViewController alloc] init];
        auctionDetailVC.artDetailType = [artDetailData.member.ID isEqualToString:[AppSingleton sharedAppSingleton].userBody.ID] ? JLAuctionArtDetailTypeSelf : JLAuctionArtDetailTypeDetail;
        Model_auction_meetings_arts_Data *meetingsArtsData = [[Model_auction_meetings_arts_Data alloc] init];
        meetingsArtsData.art = artDetailData;
        auctionDetailVC.artsData = meetingsArtsData;
        auctionDetailVC.cancelFavorateBlock = ^{
            [weakSelf.collectionArray removeObjectAtIndex:indexPath.row];
            [weakSelf.collectionView reloadData];
        };
        [self.navigationController pushViewController:auctionDetailVC animated:YES];
    } else {
        JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
        artDetailVC.artDetailType = [artDetailData.member.ID isEqualToString:[AppSingleton sharedAppSingleton].userBody.ID] ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
        artDetailVC.artDetailData = artDetailData;
        artDetailVC.cancelFavorateBlock = ^{
            [weakSelf.collectionArray removeObjectAtIndex:indexPath.row];
            [weakSelf.collectionView reloadData];
        };
        [self.navigationController pushViewController:artDetailVC animated:YES];
    }
}

#pragma mark 请求收藏作品列表
- (void)requestCollectionList {
    WS(weakSelf)
    Model_members_favorate_arts_Req *request = [[Model_members_favorate_arts_Req alloc] init];
    request.page = self.currentPage;
    request.per_page = kPageSize;
    Model_members_favorate_arts_Rsp *response = [[Model_members_favorate_arts_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.collectionArray removeAllObjects];
            }
            [weakSelf.collectionArray addObjectsFromArray:response.body];
            
            [weakSelf endRefresh:response.body];
            [self setNoDataShow];
            [self.collectionView reloadData];
        } else {
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
    }];
}

- (NSMutableArray *)collectionArray {
    if (!_collectionArray) {
        _collectionArray = [NSMutableArray array];
    }
    return _collectionArray;
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
    [self requestCollectionList];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestCollectionList];
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
    if (self.collectionArray.count == 0) {
        [self.view addSubview:self.emptyView];
    } else {
        if (_emptyView) {
            [self.emptyView removeFromSuperview];
            self.emptyView = nil;
        }
    }
}
@end
