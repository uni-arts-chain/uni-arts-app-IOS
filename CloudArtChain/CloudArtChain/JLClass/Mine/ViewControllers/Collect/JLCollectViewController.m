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

#import "JLNFTGoodCollectionCell.h"
#import "JLNormalEmptyView.h"
#import "XPCollectionViewWaterfallFlowLayout.h"

@interface JLCollectViewController ()<XPCollectionViewWaterfallFlowLayoutDataSource,UICollectionViewDataSource, UICollectionViewDelegate>
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
    [self.collectionView  registerClass:[JLNFTGoodCollectionCell class] forCellWithReuseIdentifier:@"JLNFTGoodCollectionCell"];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
    }];
}

#pragma mark - 懒加载
-(UICollectionView*)collectionView {
    if (!_collectionView) {
        WS(weakSelf)
        XPCollectionViewWaterfallFlowLayout *layout = [[XPCollectionViewWaterfallFlowLayout alloc] init];
        layout.dataSource = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height) collectionViewLayout:layout];
        _collectionView.backgroundColor = JL_color_clear;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
        _collectionView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf headRefresh];
        }];
        _collectionView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footRefresh];
        }];
    }
    return _collectionView;
}

#pragma mark - XPCollectionViewWaterfallFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout numberOfColumnInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout itemWidth:(CGFloat)width heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    Model_members_favorate_arts_Data *facorateArtsData = self.collectionArray[indexPath.row];
    Model_art_Detail_Data *artDetailData = facorateArtsData.favoritable;
    
    CGFloat textH = [JLTool getAdaptionSizeWithText:artDetailData.name labelWidth:width - 25 font:kFontPingFangSCMedium(13.0f)].height;
    if (textH > 36.4) {
        textH = 36.4;
    }
    return 45 + textH + artDetailData.imgHeight;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 12, 12);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout*)layout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout referenceHeightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout referenceHeightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLNFTGoodCollectionCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"JLNFTGoodCollectionCell" forIndexPath:indexPath];
    Model_members_favorate_arts_Data *facorateArtsData = self.collectionArray[indexPath.row];
    cell.artDetailData = facorateArtsData.favoritable;
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
        auctionDetailVC.artDetailType = artDetailData.is_owner ? JLAuctionArtDetailTypeSelf : JLAuctionArtDetailTypeDetail;
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
        artDetailVC.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
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
