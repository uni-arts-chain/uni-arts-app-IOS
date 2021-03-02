//
//  JLCreatorPageViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCreatorPageViewController.h"
#import "JLArtDetailViewController.h"

#import "JLHomePageHeaderView.h"
#import "JLPopularOriginalCollectionViewCell.h"
#import "JLNormalEmptyView.h"

@interface JLCreatorPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JLHomePageHeaderView *homePageHeaderView;
@property (nonatomic, strong) UIView *worksTitleView;
@property (nonatomic, strong) UILabel *worksTitleLabel;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton *focusButton;

@property (nonatomic, strong) NSMutableArray *artArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) JLNormalEmptyView *emptyView;
@end

@implementation JLCreatorPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主页";
    [self addBackItem];
    [self createSubviews];
    [self headRefresh];
}

- (void)createSubviews {
    [self.view addSubview:self.focusButton];
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
        make.height.mas_equalTo(46.0f);
    }];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.focusButton.mas_top);
    }];
    [self.scrollView addSubview:self.homePageHeaderView];
    [self.scrollView addSubview:self.worksTitleView];
    [self.scrollView addSubview:self.collectionView];
    [self.collectionView  registerClass:[JLPopularOriginalCollectionViewCell class] forCellWithReuseIdentifier:@"JLPopularOriginalCollectionViewCell"];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.collectionView.frameBottom);
}

- (UIButton *)focusButton {
    if (!_focusButton) {
        _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [_focusButton setTitle:@"取消关注" forState:UIControlStateSelected];
        [_focusButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _focusButton.titleLabel.font = kFontPingFangSCRegular(17.0f);
        _focusButton.backgroundColor = self.authorData.follow_by_me ? JL_color_gray_C5C5C5 : JL_color_blue_38B2F1;
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
                    sender.backgroundColor = JL_color_blue_38B2F1;
                    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"已取消关注" hideTime:KToastDismissDelayTimeInterval];
                    weakSelf.focusButton.selected = weakSelf.authorData.follow_by_me;
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        WS(weakSelf)
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = JL_color_white_ffffff;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.scrollView.mj_header endRefreshing];
        }];
    }
    return _scrollView;
}

- (JLHomePageHeaderView *)homePageHeaderView {
    if (!_homePageHeaderView) {
        _homePageHeaderView = [[JLHomePageHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 350.0f) authorData:self.authorData];
        _homePageHeaderView.backgroundColor = JL_color_white_ffffff;
    }
    return _homePageHeaderView;
}

- (UIView *)worksTitleView {
    if (!_worksTitleView) {
        _worksTitleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.homePageHeaderView.frameBottom, kScreenWidth, 27.0f)];
        _worksTitleView.backgroundColor = JL_color_white_ffffff;
        
        [_worksTitleView addSubview:self.worksTitleLabel];
        
        UIView *leftLineView = [[UIView alloc] init];
        leftLineView.backgroundColor = JL_color_black;
        [_worksTitleView addSubview:leftLineView];
        
        UIView *rightLineView = [[UIView alloc] init];
        rightLineView.backgroundColor = JL_color_black;
        [_worksTitleView addSubview:rightLineView];
        
        [self.worksTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_worksTitleView);
            make.centerX.equalTo(_worksTitleView);
        }];
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20.0f);
            make.height.mas_equalTo(2.0f);
            make.centerY.equalTo(self.worksTitleLabel);
            make.right.equalTo(self.worksTitleLabel.mas_left).offset(-8.0f);
        }];
        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20.0f);
            make.height.mas_equalTo(2.0f);
            make.centerY.equalTo(self.worksTitleLabel);
            make.left.equalTo(self.worksTitleLabel.mas_right).offset(8.0f);
        }];
    }
    return _worksTitleView;
}

- (UILabel *)worksTitleLabel {
    if (!_worksTitleLabel) {
        _worksTitleLabel = [[UILabel alloc] init];
        _worksTitleLabel.font = kFontPingFangSCSCSemibold(17.0f);
        _worksTitleLabel.textColor = JL_color_gray_101010;
        _worksTitleLabel.textAlignment = NSTextAlignmentCenter;
        _worksTitleLabel.text = @"TA的作品";
    }
    return _worksTitleLabel;
}

-(UICollectionView*)collectionView {
    if (!_collectionView) {
        WS(weakSelf)
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((kScreenWidth - 15.0f * 2 - 25.0f) * 0.5f, 250.0f);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 25.0f;
        NSInteger row = self.artArray.count / 2;
        if (self.artArray.count % 2 != 0) {
            row += 1;
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.worksTitleView.frameBottom + 25.0f, kScreenWidth, 250.0f * row) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 15.0f);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = JL_color_white_ffffff;
        _collectionView.scrollEnabled = NO;
        _collectionView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footRefresh];
        }];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.artArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLPopularOriginalCollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"JLPopularOriginalCollectionViewCell" forIndexPath:indexPath];
    cell.authorArtData = self.artArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
    artDetailVC.artDetailType = JLArtDetailTypeDetail;
    artDetailVC.artDetailData = self.artArray[indexPath.row];
    [self.navigationController pushViewController:artDetailVC animated:YES];
}

- (NSMutableArray *)artArray {
    if (!_artArray) {
        _artArray = [NSMutableArray array];
    }
    return _artArray;
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
    [self requestAuthorArtList];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestAuthorArtList];
}

- (void)endRefresh:(NSArray*)collectionArray {
    if (collectionArray.count < kPageSize) {
        self.collectionView.mj_footer.hidden = NO;
        [(JLRefreshFooter *)self.collectionView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.collectionView.mj_footer endRefreshing];
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
            weakSelf.collectionView.frame = CGRectMake(0.0f, self.worksTitleView.frameBottom + 25.0f, kScreenWidth, 250.0f * row);
            weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, self.collectionView.frameBottom);
            
            [weakSelf endRefresh:response.body];
            [self setNoDataShow];
            [self.collectionView reloadData];
        } else {
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
    }];
}
@end
