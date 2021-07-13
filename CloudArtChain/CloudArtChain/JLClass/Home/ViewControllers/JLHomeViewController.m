//
//  JLHomeViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLHomeViewController.h"
#import "JLSearchViewController.h"
#import "NSDate+Extension.h"
#import "JLArtDetailViewController.h"
#import "JLChainQueryViewController.h"
#import "JLApplyCertListViewController.h"
#import "JLCreateWalletViewController.h"
#import "JLWalletViewController.h"
#import "JLMessageViewController.h"
#import "JLCustomerServiceViewController.h"
#import "JLBaseWebViewController.h"
#import "JLAuctionArtDetailViewController.h"
#import "JLNewsDetailViewController.h"
#import "JLCategoryViewController.h"

#import "NewPagedFlowView.h"
#import "JLPopularOriginalView.h"
#import "JLHomeNaviView.h"
#import "JLThemeRecommendView.h"

#define scrollPageHeight 192.0f

@interface JLHomeViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) JLHomeNaviView *homeNaviView;
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) JLPopularOriginalView *popularOriginalView;
@property (nonatomic, strong) UIView *themeRecommendView;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;

// banner
@property (nonatomic, strong) NSMutableArray *bannerArray;
// 热门原创
@property (nonatomic, strong) NSMutableArray *popularArray;
// 主题推荐
@property (nonatomic, strong) NSMutableArray *themeArray;
@property (nonatomic, assign) NSInteger messageUnreadNumber;
@end

@implementation JLHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self createView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createOrImportWalletNotification:) name:@"CreateOrImportWalletNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginNotification:) name:@"UserLoginNotification" object:nil];
    
    NSLog(@"signed token %@", [[JLViewControllerTool appDelegate].walletTool accountSignWithOriginData:[[[AppSingleton sharedAppSingleton].userBody getToken].token dataUsingEncoding:NSUTF8StringEncoding] error:nil]);
    
    if ([JLLoginUtil haveSelectedAccount] && ![[JLViewControllerTool appDelegate].walletTool pincodeExists]) {
        NSString *userAvatar = [NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]] ? nil : [AppSingleton sharedAppSingleton].userBody.avatar[@"url"];
#if (WALLET_ENV == AUTOCREATEWALLET)
        [[JLViewControllerTool appDelegate].walletTool defaultCreateWalletWithNavigationController:[AppSingleton sharedAppSingleton].globalNavController userAvatar:userAvatar];
#elif (WALLET_ENV == MANUALCREATEWALLET)
        [[JLViewControllerTool appDelegate].walletTool presenterLoadOnLaunchWithNavigationController:[AppSingleton sharedAppSingleton].globalNavController userAvatar:userAvatar];
#endif
    } else {
        if ([JLLoginUtil haveToken]) {
            [self requestThemeList];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([JLLoginUtil haveToken]) {
        [self reloadAllService];
    }
}

- (void)reloadAllService {
    [self requestHasUnreadMessages];
    [self requestBannersData];
}

- (void)headRefreshService {
    [self requestHasUnreadMessages];
    [self requestBannersData];
    [self requestThemeList];
}

- (void)createOrImportWalletNotification:(NSNotification *)notification {
    [[JLViewControllerTool appDelegate].walletTool reloadContacts];
    // 登录
    [JLLoginUtil loginWallet];
}

- (void)userLoginNotification:(NSNotification *)notification {
    [self headRefreshService];
}

- (void)createView {
    [self.view addSubview:self.homeNaviView];
    [self.view addSubview:self.scrollView];
    // scrollView 内容视图
    [self.scrollView addSubview:self.bgView];
    // banner
    [self.bgView addSubview:self.pageFlowView];
    // 主题推荐
    [self.bgView addSubview:self.themeRecommendView];
    // 热门原创
    [self.bgView addSubview:self.popularOriginalView];
    
    // 布局
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.homeNaviView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.pageFlowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(@(scrollPageHeight));
    }];
    [self.themeRecommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pageFlowView.mas_bottom);
        make.left.right.equalTo(self.bgView);
    }];
    [self.popularOriginalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.themeRecommendView.mas_bottom);
        make.left.right.bottom.equalTo(self.bgView);
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        WS(weakSelf)
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.homeNaviView.frameBottom, kScreenWidth, kScreenHeight - self.homeNaviView.frameBottom - KTabBar_Height - KTouch_Responder_Height)];
        _scrollView.backgroundColor = JL_color_gray_F5F5F5;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf headRefreshService];
        }];
        _scrollView.mj_footer = self.footer;
    }
    return _scrollView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

- (JLHomeNaviView *)homeNaviView {
    if (!_homeNaviView) {
        WS(weakSelf)
        _homeNaviView = [[JLHomeNaviView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, KStatusBar_Navigation_Height)];
        _homeNaviView.customerServiceBlock = ^{
            JLCustomerServiceViewController *customerServiceVC = [[JLCustomerServiceViewController alloc] init];
            [weakSelf.navigationController pushViewController:customerServiceVC animated:YES];
        };
        _homeNaviView.searchBlock = ^{
            JLSearchViewController *searchVC = [[JLSearchViewController alloc] init];
            [weakSelf.navigationController pushViewController:searchVC animated:YES];
        };
        _homeNaviView.messageBlock = ^{
            JLMessageViewController *messageVC = [[JLMessageViewController alloc] init];
            messageVC.messageUnreadNumber = weakSelf.messageUnreadNumber;
            [weakSelf.navigationController pushViewController:messageVC animated:YES];
        };
    }
    return _homeNaviView;
}

- (NewPagedFlowView *)pageFlowView {
    if (!_pageFlowView) {
        _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, scrollPageHeight)];
        _pageFlowView.autoTime = 5.0f;
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.4f;
        _pageFlowView.isOpenAutoScroll = YES;
        _pageFlowView.leftRightMargin = 40.0f;
        [_pageFlowView reloadData];
    }
    return _pageFlowView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, self.pageFlowView.frame.size.height - 40.0f, kScreenWidth, 5.0f)];
        _pageControl.currentPageIndicatorTintColor = [JL_color_white_ffffff colorWithAlphaComponent:0.9f];
        _pageControl.pageIndicatorTintColor = [JL_color_white_ffffff colorWithAlphaComponent:0.5f];
    }
    return _pageControl;
}

- (UIView *)themeRecommendView {
    if (!_themeRecommendView) {
        _themeRecommendView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.pageFlowView.frameBottom, kScreenWidth, 0.0f)];
    }
    return _themeRecommendView;
}

- (JLPopularOriginalView *)popularOriginalView {
    if (!_popularOriginalView) {
        WS(weakSelf)
        _popularOriginalView = [[JLPopularOriginalView alloc] initWithFrame:CGRectMake(0.0f, self.themeRecommendView.frameBottom, kScreenWidth, 80.0f)];
        _popularOriginalView.artDetailBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            if ([artDetailData.aasm_state isEqualToString:@"auctioning"]) {
                // 拍卖中
                JLAuctionArtDetailViewController *auctionDetailVC = [[JLAuctionArtDetailViewController alloc] init];
                auctionDetailVC.artDetailType = artDetailData.is_owner ? JLAuctionArtDetailTypeSelf : JLAuctionArtDetailTypeDetail;
                Model_auction_meetings_arts_Data *meetingsArtsData = [[Model_auction_meetings_arts_Data alloc] init];
                meetingsArtsData.art = artDetailData;
                auctionDetailVC.artsData = meetingsArtsData;
                [weakSelf.navigationController pushViewController:auctionDetailVC animated:YES];
            } else {
                JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
                artDetailVC.marketLevel = 2;
                artDetailVC.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
                artDetailVC.artDetailData = artDetailData;
                [weakSelf.navigationController pushViewController:artDetailVC animated:YES];
            }
        };
    }
    return _popularOriginalView;
}

- (MJRefreshAutoNormalFooter *)footer {
    if (!_footer) {
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // TODO:
        }];
        _footer.refreshingTitleHidden = YES;
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:@"" forState:MJRefreshStatePulling];
        [_footer setTitle:@"" forState:MJRefreshStateRefreshing];
        [_footer setTitle:@"更多作品，请到市场查看~" forState:MJRefreshStateNoMoreData];
        _footer.stateLabel.textColor = JL_color_gray_999999;
        _footer.stateLabel.font = kFontPingFangSCRegular(12);
    }
    return _footer;
}

#pragma mark NewPagedFlowView Datasource
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(kScreenWidth - 36.0f * 2, scrollPageHeight - 23.0f * 2);
}

- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.bannerArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.layer.masksToBounds = YES;
        bannerView.layer.cornerRadius = 9.0f;
    }
    //在这里下载网络图片
    Model_banners_Data *bannerModel = nil;
    if (index < self.bannerArray.count) {
        bannerModel = self.bannerArray[index];
    }
    if (![NSString stringIsEmpty:bannerModel.img_min]) {
        [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:bannerModel.img_min] placeholderImage:nil];
        bannerView.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return bannerView;
}

#pragma mark NewPagedFlowView Delegate
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    Model_banners_Data *bannerModel= self.bannerArray[subIndex];
    if (!bannerModel.url.length || !bannerModel.url) {
        return;
    }
    JLBaseWebViewController * webVC = [[JLBaseWebViewController alloc] initWithWebUrl:bannerModel.url naviTitle:bannerModel.title];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark 查询用户是否有未读消息
- (void)requestHasUnreadMessages {
    WS(weakSelf)
    Model_messages_has_unread_Req *request = [[Model_messages_has_unread_Req alloc] init];
    Model_messages_has_unread_Rsp *response = [[Model_messages_has_unread_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.messageUnreadNumber = response.body.has_unread;
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:weakSelf.messageUnreadNumber];
            [GeTuiSdk setBadge:weakSelf.messageUnreadNumber];
            [weakSelf.homeNaviView refreshHasMessagesUnread:(weakSelf.messageUnreadNumber != 0)];
        } else {
            [weakSelf.homeNaviView refreshHasMessagesUnread:NO];
        }
    }];
}

#pragma mark 请求banner数据
- (void)requestBannersData {
    WS(weakSelf)
    Model_banners_Req *request = [[Model_banners_Req alloc] init];
    request.platform = @"1";
    Model_banners_Rsp *response = [[Model_banners_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            [weakSelf.bannerArray removeAllObjects];
            [weakSelf.bannerArray addObjectsFromArray:response.body];
            // 判断是否添加pageControl
            if (weakSelf.bannerArray.count > 1) {
                weakSelf.pageFlowView.pageControl = weakSelf.pageControl;
                [weakSelf.pageFlowView addSubview:weakSelf.pageControl];
            } else {
                weakSelf.pageFlowView.pageControl = nil;
                [weakSelf.pageControl removeFromSuperview];
            }
            [weakSelf.pageFlowView reloadData];
        } else {
            if ([weakSelf.scrollView.mj_header isRefreshing]) {
                [weakSelf.scrollView.mj_header endRefreshing];
            }
        }
    }];
}

#pragma mark 请求热门原创列表
- (void)requestPopularList {
    WS(weakSelf)
    Model_arts_popular_Req *request = [[Model_arts_popular_Req alloc] init];
    request.page = 1;
    request.per_page = 10;
    Model_arts_popular_Rsp *response = [[Model_arts_popular_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            [weakSelf.popularArray removeAllObjects];
            [weakSelf.popularArray addObjectsFromArray:response.body];
            
            weakSelf.popularOriginalView.popularArray = [weakSelf.popularArray copy];
            
            if ([weakSelf.scrollView.mj_header isRefreshing]) {
                [weakSelf.scrollView.mj_header endRefreshing];
            }
            [weakSelf.scrollView.mj_footer endRefreshingWithNoMoreData];
        } else {
            if ([weakSelf.scrollView.mj_header isRefreshing]) {
                [weakSelf.scrollView.mj_header endRefreshing];
            }
            NSLog(@"error: %@", errorStr);
        }
    }];
}

#pragma mark 请求主题推荐列表
- (void)requestThemeList {
    WS(weakSelf)
    Model_arts_topic_Req *request = [[Model_arts_topic_Req alloc] init];
    request.page = 1;
    Model_arts_topic_Rsp *response = [[Model_arts_topic_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            [weakSelf.themeArray removeAllObjects];
            [weakSelf.themeArray addObjectsFromArray:response.body];
            
            if (weakSelf.themeArray.count) {
                [weakSelf createThemeViews];
            }
        }else {
            if ([weakSelf.scrollView.mj_header isRefreshing]) {
                [weakSelf.scrollView.mj_header endRefreshing];
            }
        }
        [weakSelf requestPopularList];
    }];
}

- (void)createThemeViews {
    
    [self.themeRecommendView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    CGFloat themeRecommendViewHeight = 401.0f;
    for (int i = 0; i < self.themeArray.count; i++) {
        JLThemeRecommendView *themeView = [[JLThemeRecommendView alloc] initWithFrame:CGRectMake(0.0f, (themeRecommendViewHeight) * i, kScreenWidth, themeRecommendViewHeight)];
        themeView.topicData = self.themeArray[i];
        themeView.themeRecommendBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
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
                artDetailVC.marketLevel = 1;
                artDetailVC.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
                artDetailVC.artDetailData = artDetailData;
                [self.navigationController pushViewController:artDetailVC animated:YES];
            }
        };
        themeView.seeMoreBlock = ^(NSString * _Nonnull ID) {
            UITabBarController *tabBarController = [[AppSingleton sharedAppSingleton].globalNavController.viewControllers objectAtIndex:0];
            JLNavigationViewController *nav = tabBarController.viewControllers[1];
            if (nav.viewControllers.count && [nav.viewControllers.firstObject isMemberOfClass:JLCategoryViewController.class]) {
                ((JLCategoryViewController *)nav.viewControllers.firstObject).themeId = ID;
            }
            tabBarController.selectedIndex = 1;
        };
        [self.themeRecommendView addSubview:themeView];
        [themeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.themeRecommendView);
            make.top.equalTo(self.themeRecommendView).offset(themeRecommendViewHeight * i);
            make.height.mas_equalTo(themeRecommendViewHeight);
            if (i == self.themeArray.count - 1) {
                make.bottom.equalTo(self.themeRecommendView);
            }
        }];
    }
}

#pragma mark 懒加载初始化
- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)popularArray {
    if (!_popularArray) {
        _popularArray = [NSMutableArray array];
    }
    return _popularArray;
}

- (NSMutableArray *)themeArray {
    if (!_themeArray) {
        _themeArray = [NSMutableArray array];
    }
    return _themeArray;
}
@end
