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
#import "JLNewAuctionArtDetailViewController.h"
#import "JLCreatorPageArtViewController.h"

#import "JLHoveringView.h"
#import "JLHomePageHeaderView.h"

@interface JLCreatorPageViewController ()<JLHoveringListViewDelegate>
@property (nonatomic, strong) JLHoveringView *hoveringView;

@property (nonatomic, strong) JLHomePageHeaderView *homePageHeaderView;
@property (nonatomic, strong) UIButton *focusButton;

@property (nonatomic,   copy) NSArray <UIViewController *> *viewControllers;
@property (nonatomic,   copy) NSArray <NSString *> *titles;
@end

@implementation JLCreatorPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主页";
    [self addBackItem];
    
    [self createSubviews];
    
    // 发起拍卖
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllVCDatas) name:LOCALNOTIFICATION_JL_LAUNCH_AUCTION object:nil];
    // 取消拍卖
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllVCDatas) name:LOCALNOTIFICATION_JL_CANCEL_AUCTION object:nil];
    // 拍卖结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllVCDatas) name:LOCALNOTIFICATION_JL_END_AUCTION object:nil];
    
    [self artHeadRefresh];
}

- (void)createSubviews {
    [self.view addSubview:self.focusButton];
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(46.0f + KTouch_Responder_Height);
    }];
    
    [self.view addSubview:self.hoveringView];
}

#pragma mark - JLHoveringListViewDelegate
- (NSArray *)listView {
    NSMutableArray *tableViewArray = [NSMutableArray array];
    for (JLCreatorPageArtViewController *artVC in self.viewControllers) {
        [tableViewArray addObject:artVC.collectionView];
    }
    return [tableViewArray copy];
}

- (UIView *)headView {
    return self.homePageHeaderView;
}

- (NSArray<UIViewController *> *)listCtroller {
    return self.viewControllers;
}

- (NSArray<NSString *> *)listTitle {
    return self.titles;
}

#pragma mark - event response
- (void)focusButtonClick:(UIButton *)sender {
    if (![JLLoginUtil haveSelectedAccount]) {
        [JLLoginUtil presentCreateWallet];
    } else {
        if (!sender.selected) {
            [self follow];
        } else {
            [self unFollow];
        }
    }
}

#pragma mark - loadDatas
/// 关注
- (void)follow {
    WS(weakSelf)
    Model_members_follow_Req *request = [[Model_members_follow_Req alloc] init];
    request.author_id = self.authorData.ID;
    Model_members_follow_Rsp *response = [[Model_members_follow_Rsp alloc] init];
    response.request = request;
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.authorData = response.body;
            weakSelf.focusButton.backgroundColor = JL_color_gray_C5C5C5;
            [[JLLoading sharedLoading] showMBSuccessTipMessage:@"关注成功" hideTime:KToastDismissDelayTimeInterval];
            weakSelf.focusButton.selected = weakSelf.authorData.follow_by_me;
            if (weakSelf.followOrCancelBlock) {
                weakSelf.followOrCancelBlock(response.body);
            }
        } else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}
/// 取消关注
- (void)unFollow {
    WS(weakSelf)
    Model_members_unfollow_Req *request = [[Model_members_unfollow_Req alloc] init];
    request.author_id = self.authorData.ID;
    Model_members_unfollow_Rsp *response = [[Model_members_unfollow_Rsp alloc] init];
    response.request = request;
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.authorData = response.body;
            weakSelf.focusButton.backgroundColor = JL_color_gray_101010;
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

#pragma mark - private methods
- (void)refreshAllVCDatas {
    for (JLCreatorPageArtViewController *artVC in self.viewControllers) {
        [artVC headRefresh];
    }
}

- (void)artHeadRefresh {
    JLCreatorPageArtViewController *artVC = (JLCreatorPageArtViewController *)self.viewControllers[self.hoveringView.pageView.currentSelectedIndex];
    [artVC headRefresh];
}

- (CGFloat)getDescLabelHeight:(NSString *)descStr {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:descStr];
    CGRect rect = [JLTool getAdaptionSizeWithAttributedText:attr font:kFontPingFangSCRegular(13.0f) labelWidth:kScreenWidth - 40.0f * 2 lineSpace:10.0f];
    return rect.size.height + 20.0f;
}

#pragma mark - setters and getters
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

- (JLHomePageHeaderView *)homePageHeaderView {
    if (!_homePageHeaderView) {
        NSString *descStr = [NSString stringIsEmpty:self.authorData.desc] ? @"未设置描述" : self.authorData.desc;
        CGFloat descHeight = [self getDescLabelHeight:descStr];
        
        _homePageHeaderView = [[JLHomePageHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 206.0f + descHeight)];
        _homePageHeaderView.authorData = self.authorData;
        _homePageHeaderView.backgroundColor = JL_color_white_ffffff;
    }
    return _homePageHeaderView;
}

- (JLHoveringView *)hoveringView {
    if (!_hoveringView) {
        _hoveringView = [[JLHoveringView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - (46.0f + KTouch_Responder_Height) - KStatusBar_Navigation_Height) deleaget:self];
        _hoveringView.isMidRefresh = NO;

        _hoveringView.pageView.defaultTitleColor = JL_color_gray_999999;
        _hoveringView.pageView.selectTitleColor = JL_color_gray_101010;
        _hoveringView.pageView.lineColor = JL_color_gray_333333;
        _hoveringView.pageView.lineWitdhScale = 0.18f;
        _hoveringView.pageView.defaultTitleFont = kFontPingFangSCRegular(15.0f);
        _hoveringView.pageView.selectTitleFont = kFontPingFangSCSCSemibold(16.0f);
            
        WS(weakSelf)
        //设置头部刷新的方法。头部刷新的话isMidRefresh 必须为NO
        _hoveringView.scrollView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf artHeadRefresh];
        }];
    }
    return _hoveringView;
}

- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"寄售的NFT"];
    }
    return _titles;
}

- (NSArray <UIViewController *> *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [self setupViewControllers];
    }
    return _viewControllers;
}

- (NSArray <UIViewController *> *)setupViewControllers {
    WS(weakSelf)
    NSMutableArray <UIViewController *> *artVCArray = [NSMutableArray array];
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JLCreatorPageArtViewController *artVC = [[JLCreatorPageArtViewController alloc] init];
        artVC.type = idx;
        artVC.authorId = weakSelf.authorData.ID;
        artVC.lookArtDetailBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            JLArtDetailViewController *vc = [[JLArtDetailViewController alloc] init];
            vc.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
            vc.artDetailData = artDetailData;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
//        artVC.lookAuctionDetailBlock = ^(Model_auctions_Data * _Nonnull auctionsData) {
//            JLNewAuctionArtDetailViewController *vc = [[JLNewAuctionArtDetailViewController alloc] init];
//            vc.auctionsId = auctionsData.ID;
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        };
        artVC.endRefreshBlock = ^(NSInteger page) {
            if (page == 1 && [weakSelf.hoveringView.scrollView.mj_header isRefreshing]) {
                [weakSelf.hoveringView.scrollView.mj_header endRefreshing];
            }
        };
        [artVCArray addObject:artVC];
    }];
    return artVCArray.copy;
}

@end
