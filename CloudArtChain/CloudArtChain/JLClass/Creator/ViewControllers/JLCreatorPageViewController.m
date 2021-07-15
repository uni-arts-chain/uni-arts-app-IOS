//
//  JLCreatorPageViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCreatorPageViewController.h"
#import "JLArtDetailViewController.h"
#import "JLAuctionArtDetailViewController.h"

#import "JLCreatorPageNavView.h"
#import "JLCreatorPageHeaderView.h"
#import "JLNFTGoodCollectionCell.h"
#import "XPCollectionViewWaterfallFlowLayout.h"

#import "JLNormalEmptyView.h"

@interface JLCreatorPageViewController ()< XPCollectionViewWaterfallFlowLayoutDataSource,UICollectionViewDelegate,UICollectionViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) JLCreatorPageNavView *navView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) JLCreatorPageHeaderView *headerView;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton *focusButton;
@property (nonatomic, strong) MASConstraint *collectionHeightConstraint;

@property (nonatomic, strong) NSMutableArray *artArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) JLNormalEmptyView *emptyView;
@end

@implementation JLCreatorPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
    if (self.authorData) {
        [self createSubviews];
        [self headRefresh];
    }else {
        [self loadAuthorData];
    }
}

- (void)createSubviews {
//    [self.view addSubview:self.focusButton];
//    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//        make.height.mas_equalTo(46.0f + KTouch_Responder_Height);
//    }];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self.scrollView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.bgView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView).offset(-(KTouch_Responder_Height + 15));
        self.collectionHeightConstraint = make.height.mas_equalTo(@400);
    }];
    
    [self.view addSubview:self.navView];
}

- (UIButton *)focusButton {
    if (!_focusButton) {
        _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [_focusButton setTitle:@"取消关注" forState:UIControlStateSelected];
        [_focusButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _focusButton.titleLabel.font = kFontPingFangSCRegular(17.0f);
        _focusButton.backgroundColor = self.authorData.follow_by_me ? JL_color_gray_C5C5C5 : JL_color_gray_101010;
        [_focusButton addTarget:self action:@selector(focusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _focusButton.selected = self.authorData.follow_by_me;
    }
    return _focusButton;
}

- (void)focusButtonClick:(UIButton *)sender {
    WS(weakSelf)
    if (![JLLoginUtil haveSelectedAccount]) {
        [JLLoginUtil presentCreateWallet];
    } else {
        if (!sender.selected) {
            // 关注
            Model_members_follow_Req *request = [[Model_members_follow_Req alloc] init];
            request.author_id = self.authorData.ID;
            Model_members_follow_Rsp *response = [[Model_members_follow_Rsp alloc] init];
            response.request = request;
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                if (netIsWork) {
                    weakSelf.authorData = response.body;
                    sender.backgroundColor = JL_color_gray_C5C5C5;
                    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"关注成功" hideTime:KToastDismissDelayTimeInterval];
                    weakSelf.focusButton.selected = weakSelf.authorData.follow_by_me;
                    if (weakSelf.followOrCancelBlock) {
                        weakSelf.followOrCancelBlock(response.body);
                    }
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        } else {
            // 取消关注
            Model_members_unfollow_Req *request = [[Model_members_unfollow_Req alloc] init];
            request.author_id = self.authorData.ID;
            Model_members_unfollow_Rsp *response = [[Model_members_unfollow_Rsp alloc] init];
            response.request = request;
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                if (netIsWork) {
                    weakSelf.authorData = response.body;
                    sender.backgroundColor = JL_color_gray_101010;
                    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"已取消关注" hideTime:KToastDismissDelayTimeInterval];
                    weakSelf.focusButton.selected = weakSelf.authorData.follow_by_me;
                    if (weakSelf.followOrCancelBlock) {
                        weakSelf.followOrCancelBlock(response.body);
                    }
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }
    }
}

- (JLCreatorPageNavView *)navView {
    if (!_navView) {
        _navView = [[JLCreatorPageNavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KStatusBar_Navigation_Height)];
        _navView.bgView.alpha = 0;
        _navView.titleLabel.text = [NSString stringIsEmpty:self.authorData.display_name] ? @"未设置昵称" : self.authorData.display_name;
        WS(weakSelf)
        _navView.backBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _navView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        WS(weakSelf)
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.scrollView.mj_header endRefreshing];
        }];
        _scrollView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footRefresh];
        }];
    }
    return _scrollView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = JL_color_vcBgColor;
    }
    return _bgView;
}

- (JLCreatorPageHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JLCreatorPageHeaderView alloc] init];
        _headerView.authorData = self.authorData;
    }
    return _headerView;
}

-(UICollectionView*)collectionView {
    if (!_collectionView) {
        XPCollectionViewWaterfallFlowLayout *layout = [[XPCollectionViewWaterfallFlowLayout alloc] init];
        layout.dataSource = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = JL_color_clear;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
        
        [_collectionView  registerClass:[JLNFTGoodCollectionCell class] forCellWithReuseIdentifier:@"JLNFTGoodCollectionCell"];
    }
    return _collectionView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y > 0) {
        self.navView.bgView.alpha = scrollView.contentOffset.y / (0.312 * kScreenWidth + KStatusBar_Navigation_Height);
    }else {
        self.navView.bgView.alpha = 0;
    }
}

#pragma mark - XPCollectionViewWaterfallFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout numberOfColumnInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(XPCollectionViewWaterfallFlowLayout *)layout itemWidth:(CGFloat)width heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    Model_art_Detail_Data *artDetailData = self.artArray[indexPath.item];
    
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

- (void)collectionViewContentSizeChange:(CGFloat)height {
    
    if (self.artArray.count) {
        [self.collectionHeightConstraint uninstall];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.collectionHeightConstraint = make.height.mas_equalTo(@(height));
        }];
    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.artArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLNFTGoodCollectionCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"JLNFTGoodCollectionCell" forIndexPath:indexPath];
    if (self.authorData.is_official_account) {
        cell.marketLevel = 1;
    }else {
        cell.marketLevel = 2;
    }
    cell.artDetailData = self.artArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Model_art_Detail_Data *artDetailData = self.artArray[indexPath.row];
    if ([artDetailData.aasm_state isEqualToString:@"auctioning"]) {
        // 拍卖中
        JLAuctionArtDetailViewController *auctionDetailVC = [[JLAuctionArtDetailViewController alloc] init];
        auctionDetailVC.artDetailType = artDetailData.is_owner ? JLAuctionArtDetailTypeSelf : JLAuctionArtDetailTypeDetail;
        Model_auction_meetings_arts_Data *meetingsArtsData = [[Model_auction_meetings_arts_Data alloc] init];
        meetingsArtsData.art = artDetailData;
        auctionDetailVC.artsData = meetingsArtsData;
        [self.navigationController pushViewController:auctionDetailVC animated:YES];
    } else {
        JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
        if (self.authorData.is_official_account) {
            artDetailVC.marketLevel = 1;
        }else {
            artDetailVC.marketLevel = 2;
        }
        artDetailVC.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
        artDetailVC.artDetailData = artDetailData;
        [self.navigationController pushViewController:artDetailVC animated:YES];
    }
}

- (NSMutableArray *)artArray {
    if (!_artArray) {
        _artArray = [NSMutableArray array];
    }
    return _artArray;
}

- (JLNormalEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JLNormalEmptyView alloc]initWithFrame:CGRectMake(12.0f, 0, kScreenWidth - 24, 400)];
        _emptyView.layer.cornerRadius = 5;
    }
    return _emptyView;
}

- (void)headRefresh {
    self.currentPage = 1;
    [self requestAuthorArtList];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestAuthorArtList];
}

- (void)endRefresh:(NSArray*)collectionArray {
    if (collectionArray.count < kPageSize) {
        [(JLRefreshFooter *)self.scrollView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.scrollView.mj_footer endRefreshing];
    }
}

- (void)setNoDataShow {
    if (self.artArray.count == 0) {
        [self.collectionView addSubview:self.emptyView];
    } else {
        if (_emptyView) {
            [self.emptyView removeFromSuperview];
            self.emptyView = nil;
        }
    }
}

- (void)loadAuthorData {
    WS(weakSelf)
    Model_members_Req *request = [[Model_members_Req alloc] init];
    request.author_id = self.authorId;
    Model_members_Rsp *response = [[Model_members_Rsp alloc] init];
    response.request = request;
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            
            weakSelf.authorData = response.body;
            
            [weakSelf createSubviews];
            
            [weakSelf headRefresh];
        }
    }];
}

- (void)requestAuthorArtList {
    WS(weakSelf)
    Model_members_arts_Req *request = [[Model_members_arts_Req alloc] init];
    request.page = self.currentPage;
    request.per_page = kPageSize;
    request.author_id = self.authorData.ID;
    Model_members_arts_Rsp *response = [[Model_members_arts_Rsp alloc] init];
    response.request = request;
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.artArray removeAllObjects];
            }
            [weakSelf.artArray addObjectsFromArray:response.body];
            
            NSInteger row = weakSelf.artArray.count / 2;
            if (self.artArray.count % 2 != 0) {
                row += 1;
            }
            if (row == 0) {
                row = 1;
            }
            
            [weakSelf endRefresh:response.body];
            [self setNoDataShow];
            [self.collectionView reloadData];
        } else {
            [weakSelf.scrollView.mj_footer endRefreshing];
        }
    }];
}

@end
