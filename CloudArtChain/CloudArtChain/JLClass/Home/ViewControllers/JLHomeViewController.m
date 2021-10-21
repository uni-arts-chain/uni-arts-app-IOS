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
#import "JLAuctionDetailViewController.h"
#import "JLBaseWebViewController.h"
#import "JLAuctionArtDetailViewController.h"
#import "JLNewsDetailViewController.h"
#import "JLHomeHotViewController.h"
#import "JLNewAuctionArtDetailViewController.h"

#import "JLHoveringView.h"
#import "NewPagedFlowView.h"
#import "JLHomeAppView.h"
#import "SDCycleScrollView.h"
#import "JLPopularOriginalView.h"
#import "JLHomeNaviView.h"
#import "JLThemeRecommendView.h"
#import "JLAnnounceCollectionViewCell.h"
#import "JLAuctionSectionView.h"
#import "JLHudActivityView.h"

#define scrollPageHeight 190.0f

@interface JLHomeViewController ()<JLHoveringListViewDelegate, NewPagedFlowViewDelegate, NewPagedFlowViewDataSource, SDCycleScrollViewDelegate>
@property (nonatomic, strong) JLHomeNaviView *homeNaviView;

@property (nonatomic, strong) JLHoveringView *hoveringView;
@property (nonatomic, strong) UIView *topBgView;

@property (nonatomic, strong) NewPagedFlowView *pageFlowView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) JLHomeAppView *appView;
@property (nonatomic, strong) UIView *announceView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) JLAuctionSectionView *auctionSectionView;
@property (nonatomic, strong) JLPopularOriginalView *popularOriginalView;
@property (nonatomic, strong) UIView *themeRecommendView;

// banner
@property (nonatomic, strong) NSMutableArray *bannerArray;
// 公告
@property (nonatomic, strong) NSMutableArray *announceArray;
// 拍卖
@property (nonatomic, strong) NSMutableArray *auctionArray;
// 热门原创
@property (nonatomic, strong) NSMutableArray *popularArray;
// 主题推荐
@property (nonatomic, strong) NSMutableArray *themeArray;
@property (nonatomic, assign) NSInteger messageUnreadNumber;

@property (nonatomic,   copy) NSArray <UIViewController *> *viewControllers;
@property (nonatomic,   copy) NSArray <NSString *> *titles;
@end

@implementation JLHomeViewController
#pragma mark - life cycle
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
//        [self requestHasUnreadMessages];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"释放了: %@", self.class);
}

#pragma mark - setupUI
- (void)createView {
    [self.view addSubview:self.homeNaviView];
    
    // 头部视图
    [self.topBgView addSubview:self.pageFlowView];
    [self.topBgView addSubview:self.announceView];
    [self.topBgView addSubview:self.themeRecommendView];
    self.topBgView.frame = CGRectMake(0, 0, kScreenWidth, self.themeRecommendView.frameBottom + 22);
    
    [self.view addSubview:self.hoveringView];
}

- (void)updateThemeRecommandViews {
    WS(weakSelf)
    CGFloat themeRecommendViewHeight = 397.0f;
    if (self.themeArray.count > 0) {
        self.themeRecommendView.frame = CGRectMake(0.0f, self.announceView.frameBottom, kScreenWidth, themeRecommendViewHeight * self.themeArray.count + 16.0f * (self.themeArray.count - 1));
    }
    for (int i = 0; i < self.themeArray.count; i++) {
        JLThemeRecommendView *themeView = [[JLThemeRecommendView alloc] initWithFrame:CGRectMake(0.0f, (themeRecommendViewHeight + 16.0f) * i, kScreenWidth, themeRecommendViewHeight)];
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
                artDetailVC.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
                artDetailVC.artDetailData = artDetailData;
                [weakSelf.navigationController pushViewController:artDetailVC animated:YES];
            }
        };
        themeView.seeMoreBlock = ^{
            UITabBarController *tabBarController = [[AppSingleton sharedAppSingleton].globalNavController.viewControllers objectAtIndex:0];
            tabBarController.selectedIndex = 1;
        };
        [self.themeRecommendView addSubview:themeView];
    }
    
    self.topBgView.frame = CGRectMake(0, 0, kScreenWidth, self.themeRecommendView.frameBottom + 22);
    [self.hoveringView reloadView];
}

#pragma mark - JLHoveringListViewDelegate
- (NSArray *)listView {
    NSMutableArray *tableViewArray = [NSMutableArray array];
    for (JLHomeHotViewController *populerVC in self.viewControllers) {
        [tableViewArray addObject:populerVC.collectionView];
    }
    return [tableViewArray copy];
}

- (UIView *)headView {
    return self.topBgView;
}

- (NSArray<UIViewController *> *)listCtroller {
    return self.viewControllers;
}

- (NSArray<NSString *> *)listTitle {
    return self.titles;
}

#pragma mark - NewPagedFlowView Datasource
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(kScreenWidth - 25.0f * 2, scrollPageHeight - 10.0f * 2);
}

- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.bannerArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.layer.masksToBounds = YES;
        bannerView.layer.cornerRadius = 5.0f;
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

#pragma mark - NewPagedFlowView Delegate
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    Model_banners_Data *bannerModel= self.bannerArray[subIndex];
    if (!bannerModel.url.length || !bannerModel.url) {
        return;
    }
    JLBaseWebViewController * webVC = [[JLBaseWebViewController alloc] initWithWebUrl:bannerModel.url naviTitle:bannerModel.title];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    return [JLAnnounceCollectionViewCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    WS(weakSelf)
    JLAnnounceCollectionViewCell *annonuceCell = (JLAnnounceCollectionViewCell *)cell;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:self.cycleScrollView.titlesGroup[index]];
    if (index == self.cycleScrollView.titlesGroup.count - 1) {
        [array addObject:self.cycleScrollView.titlesGroup[0]];
    } else {
        [array addObject:self.cycleScrollView.titlesGroup[index + 1]];
    }
    annonuceCell.announceArray = [array copy];
    annonuceCell.announceBlock = ^(NSInteger subIndex) {
        Model_news_Data *annouceData = weakSelf.announceArray[index];
        if (subIndex == 1) {
            if (index == weakSelf.cycleScrollView.titlesGroup.count - 1) {
                annouceData = weakSelf.announceArray[0];
            } else {
                annouceData = weakSelf.announceArray[index + 1];
            }
        }
        JLNewsDetailViewController *newsDetailVC = [[JLNewsDetailViewController alloc] init];
        newsDetailVC.newsData = annouceData;
        [weakSelf.navigationController pushViewController:newsDetailVC animated:YES];
    };
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    Model_news_Data *annouceData = self.announceArray[index];
//    JLNewsDetailViewController *newsDetailVC = [[JLNewsDetailViewController alloc] init];
//    newsDetailVC.newsData = annouceData;
//    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

#pragma mark - loadDatas
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
            [weakSelf.hoveringView.scrollView.mj_header endRefreshing];
        }
    }];
}

#pragma mark 请求公告数据
- (void)requestAnnounceData {
    WS(weakSelf)
    Model_news_Req *request = [[Model_news_Req alloc] init];
    request.page = 1;
    request.type = @"New::Announcement";
    Model_news_Rsp *response = [[Model_news_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
//        [[JLLoading sharedLoading] hideLoading];
        [weakSelf.hoveringView.scrollView.mj_header endRefreshing];
        if (netIsWork) {
            [weakSelf.announceArray removeAllObjects];
            [weakSelf.announceArray addObjectsFromArray:response.body];
            NSMutableArray *titleArray = [NSMutableArray array];
            for (Model_news_Data *annouceData in weakSelf.announceArray) {
                if (![NSString stringIsEmpty:annouceData.title]) {
                    [titleArray addObject:annouceData.title];
                }
            }
            weakSelf.cycleScrollView.titlesGroup = titleArray;
        }
    }];
}

#pragma mark 主题推荐数据
- (void)requestThemeList {
    WS(weakSelf)
    Model_arts_topic_Req *request = [[Model_arts_topic_Req alloc] init];
    request.page = 1;
    Model_arts_topic_Rsp *response = [[Model_arts_topic_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            [weakSelf.themeArray removeAllObjects];
            [weakSelf.themeArray addObjectsFromArray:response.body];
            
            [weakSelf updateThemeRecommandViews];
        }
        // 加载热门原创/拍卖数据
        [weakSelf hotHeadRefresh];
    }];
}

#pragma mark - private methods
- (void)reloadAllService {
    [self requestHasUnreadMessages];
    [self requestBannersData];
    [self requestAnnounceData];
}

- (void)headRefreshService {
    [self requestHasUnreadMessages];
    [self requestBannersData];
    [self requestAnnounceData];
    [self requestThemeList];
}

// 刷新热门原创/拍卖数据
- (void)hotHeadRefresh {
    JLHomeHotViewController *populerVC = (JLHomeHotViewController *)self.viewControllers[self.hoveringView.pageView.currentSelectedIndex];
    [populerVC headRefresh];
}

- (void)createOrImportWalletNotification:(NSNotification *)notification {
    if (!JLEthereumTool.shared.currentWalletInfo) {
        [self initEthereumWallet];
    }else {
        [self initServer];
    }
}

- (void)userLoginNotification:(NSNotification *)notification {
    [self headRefreshService];
}

- (void)initServer {
    [[JLViewControllerTool appDelegate].walletTool reloadContacts];
    // 登录
    [JLLoginUtil loginWallet];
}

/// 创建以太坊钱包(与polkadot共用一套助记词)
- (void)initEthereumWallet {
    [[JLLoading sharedLoading] showLoadingWithMessage:@"初始化中..." onView:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[JLViewControllerTool appDelegate].walletTool exportMnemonicWithAddress:[[JLViewControllerTool appDelegate].walletTool getCurrentAccount].address completion:^(NSArray<NSString *> * _Nonnull words) {
            JLLog(@"ethereum & polkadot mnemonic words: %@", [words componentsJoinedByString:@" "]);
            if (words.count) {
                [JLEthereumTool.shared importWalletWithMnemonics:words completion:^(NSString * _Nullable address, NSString * _Nullable errorMsg) {
                    [[JLLoading sharedLoading] hideLoading];
                    if (![NSString stringIsEmpty:address]) {
                        [[JLLoading sharedLoading] showMBSuccessTipMessage:@"初始化完成!" hideTime:KToastDismissDelayTimeInterval];
                    }
                    JLLog(@"ethereum importWalletWithMnemonics address: %@, errorMsg: %@", address, errorMsg);
                    
                    [self initServer];
                }];
            }
        }];
    });
}

#pragma mark - 懒加载视图
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
- (void)create {
    WS(weakSelf)
    // 所有账户
//    NSArray *arr = [JLEthereumTool.shared allWalletInfos];
//    for (JLEthereumWalletInfo *walletInfo in arr) {
//        JLLog(@"ethereum wallet %@", walletInfo);
//    }
//    // 选择一个账户
//    JLEthereumWalletInfo *walletInfo = arr[3];
//    [JLEthereumTool.shared chooseAccountWithWalletInfo:walletInfo completion:^(BOOL isSuccess, NSString * _Nullable errorMsg) {
//        JLLog(@"ethereum isSuccess: %d, errorMsg: %@", isSuccess, errorMsg);
//    }];
    JLLog(@"current choose wallet: %@", [JLEthereumTool.shared currentWalletInfo]);
    NSString *password = [JLEthereumTool.shared getCurrentPassword];
    JLLog(@"ethereum password: %@", password);
    
    // 获取当前以太坊钱包余额
//    [JLEthereumTool.shared getCurrentWalletBalanceWithCompletion:^(NSString * _Nullable amount, NSString * _Nullable errorMsg) {
//        JLLog(@"ethereum wallet balance: %@, errorMsg: %@", amount, errorMsg);
//    }];
//    [JLEthereumTool.shared getGasPriceWithCompletion:^(NSString * _Nullable amount, NSString * _Nullable errorMsg) {
//        JLLog(@"ethereum wallet gasPrice: %@, errorMsg: %@", amount, errorMsg);
//    }];
    
//    [JLEthereumTool.shared createInstantWalletWithCompletion:^(NSString * _Nullable address, NSString * _Nullable errorMsg) {
//        JLLog(@"ethereum address: %@, errorMsg: %@", address, errorMsg);
//        [weakSelf export];
//    }];
    
//    NSArray *arr2 = [@"differ pioneer matrix display minimum usage hazard orbit fluid oil peasant cushion" componentsSeparatedByString:@" "];
//    [JLEthereumTool.shared importWalletWithMnemonics:arr2 completion:^(NSString * _Nullable address, NSString * _Nullable errorMsg) {
//        JLLog(@"ethereum importWalletWithMnemonics address: %@, errorMsg: %@", address, errorMsg);
//        [weakSelf export];
//    }];
            
//    // 164e9500eaca3f697e933c5bcc8167f420f861edb580438205a6a53cd5ab2924
//    [JLEthereumTool.shared importWalletWithPrivateKey:@"9bdc843de616081a77351b2e2ab4fcdc6c8b431f775f185acb1455882ef102d1" completion:^(NSString * _Nullable address, NSString * _Nullable errorMsg) {
//        JLLog(@"ethereum importWalletWithPrivateKey address: %@, errorMsg: %@", address, errorMsg);
//        [weakSelf export];
//    }];
            
//    NSString *str = @"{\"id\":\"e3032f3b-18f7-4c52-9a2a-ec58a39bb1de\",\"crypto\":{\"ciphertext\":\"acfed4d023371fec052260382a95fa8b949c48c2cf5dcf20a808be099973de9e\",\"cipherparams\":{\"iv\":\"0a4f33b1da0eafbd1587a6a5b8e659d0\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"r\":8,\"p\":6,\"n\":4096,\"dklen\":32,\"salt\":\"80b1ece6d2daa092674887c96f8f29e0c6709d12de58e3ec6a15d61e195fa7e6\"},\"mac\":\"b1a5a0c929ae5349e4e56212c3de9cfaeb5638ac728baf4588a84dfbac51d80e\",\"cipher\":\"aes-128-ctr\"},\"type\":\"private-key\",\"activeAccounts\":[],\"version\":3}";
//    [JLEthereumTool.shared importWalletWithKeystoreJson:str password:@"hahaha" completion:^(NSString * _Nullable address, NSString * _Nullable errorMsg) {
//            JLLog(@"ethereum importWalletWithKeystoreJson address: %@, errorMsg: %@", address, errorMsg);
//            [weakSelf export];
//    }];
    
//    [JLEthereumTool.shared importWalletWithAddress:@"0x028A7F4cCe06F8c2C342e2712edb72726020b602" completion:^(NSString * _Nullable address, NSString * _Nullable errorMsg) {
//        JLLog(@"ethereum importWalletWithAddress address: %@, errorMsg: %@", address, errorMsg);
//        [weakSelf export];
//    }];
}
- (void)export {
    [JLEthereumTool.shared exportMnemonicWithCompletion:^(NSArray<NSString *> *  _Nonnull mnemonics, NSString * _Nullable errorMsg) {
        JLLog(@"ethereum mnemonics: %@, errorMsg: %@", [mnemonics componentsJoinedByString:@" "], errorMsg);
    }];
    [JLEthereumTool.shared exportPrivateKeyWithCompletion:^(NSString * _Nullable privateKey, NSString * _Nullable errorMsg) {
        JLLog(@"ethereum privateKey: %@, errorMsg: %@",privateKey, errorMsg);
    }];
    [JLEthereumTool.shared exportKeystoreJsonWithExportedKey:@"hahaha" completion:^(NSString * _Nullable keystoreJson, NSString * _Nullable errorMsg) {
        JLLog(@"ethereum keystoreJson: %@, errorMsg: %@",keystoreJson, errorMsg);
    }];
}
- (JLHoveringView *)hoveringView {
    if (!_hoveringView) {
        _hoveringView = [[JLHoveringView alloc] initWithFrame:CGRectMake(0.0f, self.homeNaviView.frameBottom, kScreenWidth, kScreenHeight - self.homeNaviView.frameHeight - KTabBar_Height) deleaget:self];
        _hoveringView.isMidRefresh = NO;

        _hoveringView.pageView.defaultTitleColor = JL_color_gray_101010;
        _hoveringView.pageView.selectTitleColor = JL_color_gray_101010;
        _hoveringView.pageView.lineColor = JL_color_gray_333333;
        _hoveringView.pageView.lineWitdhScale = 0.26f;
        _hoveringView.pageView.defaultTitleFont = kFontPingFangSCRegular(18.0f);
        _hoveringView.pageView.selectTitleFont = kFontPingFangSCSCSemibold(19.0f);
            
        WS(weakSelf)
        //设置头部刷新的方法。头部刷新的话isMidRefresh 必须为NO
        _hoveringView.scrollView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf headRefreshService];
        }];
    }
    return _hoveringView;
}

- (UIView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
    }
    return _topBgView;
}

- (NewPagedFlowView *)pageFlowView {
    if (!_pageFlowView) {
        _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, scrollPageHeight)];
        _pageFlowView.backgroundColor = JL_color_white_ffffff;
        _pageFlowView.autoTime = 5.0f;
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.4f;
        _pageFlowView.isOpenAutoScroll = YES;
        [_pageFlowView reloadData];
    }
    return _pageFlowView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, self.pageFlowView.frame.size.height - 25.0f, kScreenWidth, 5.0f)];
        _pageControl.currentPageIndicatorTintColor = [JL_color_white_ffffff colorWithAlphaComponent:0.9f];
        _pageControl.pageIndicatorTintColor = [JL_color_white_ffffff colorWithAlphaComponent:0.5f];
    }
    return _pageControl;
}

- (JLHomeAppView *)appView {
    if (!_appView) {
        WS(weakSelf)
        _appView = [[JLHomeAppView alloc] initWithFrame:CGRectMake(0.0f, self.pageFlowView.frameBottom, kScreenWidth, 105.0f)];
        _appView.selectAppBlock = ^(NSInteger index) {
            if (index == 0) {
                JLChainQueryViewController *chainQueryVC = [[JLChainQueryViewController alloc] init];
                [weakSelf.navigationController pushViewController:chainQueryVC animated:YES];
            } else if (index == 1) {
                if (![JLLoginUtil haveSelectedAccount]) {
                    [JLLoginUtil presentCreateWallet];
                } else {
                    JLApplyCertListViewController *applyCertListVC = [[JLApplyCertListViewController alloc] init];
                    [weakSelf.navigationController pushViewController:applyCertListVC animated:YES];
                }
            } else {
                NSString *userAvatar = [NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]] ? nil : [AppSingleton sharedAppSingleton].userBody.avatar[@"url"];
                [[JLViewControllerTool appDelegate].walletTool presenterLoadOnLaunchWithNavigationController:[AppSingleton sharedAppSingleton].globalNavController userAvatar:userAvatar];
            }
        };
    }
    return _appView;
}

- (UIView *)announceView {
    if (!_announceView) {
        _announceView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.pageFlowView.frameBottom , kScreenWidth, 100.0f)];
        _announceView.backgroundColor = JL_color_white_ffffff;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 10.0f, kScreenWidth - 15.0f * 2, _announceView.frameHeight - 10.0f * 2)];
        contentView.backgroundColor = JL_color_white_ffffff;
        contentView.layer.cornerRadius = 5.0f;
        contentView.layer.masksToBounds = NO;
        contentView.layer.shadowColor = JL_color_gray_CCCCCC.CGColor;
        contentView.layer.shadowOpacity = 0.5f;
        contentView.layer.shadowOffset = CGSizeZero;
        contentView.layer.shadowRadius = 5.0f;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:contentView.bounds];
        contentView.layer.shadowPath = path.CGPath;
        [_announceView addSubview:contentView];
        
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 18.0f, 72.0f, 49.0f)];
        backImageView.image = [UIImage imageNamed:@"icon_home_announce_back"];
        [contentView addSubview:backImageView];
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3.0f, 6.0f, 65.0f, 15.0f)];
        titleImageView.image = [UIImage imageNamed:@"icon_home_announce_title"];
        [backImageView addSubview:titleImageView];
        
        NSString *currentDateStr = [[NSDate date] dateWithCustomFormat:@"MM月dd日"];
        CGFloat dateLabelWidth = [JLTool getAdaptionSizeWithText:currentDateStr labelHeight:13.0f font:kFontPingFangSCMedium(9.0f)].width + 2.0f;
        UILabel *dateLabel = [JLUIFactory gradientLabelWithFrame:CGRectMake(backImageView.frameWidth - 4.0f - dateLabelWidth, backImageView.frameHeight - 5.0f - 13.0f, dateLabelWidth, 13.0f) colors:@[(__bridge id)[JL_color_blue_78A7FF colorWithAlphaComponent:1.0f].CGColor, (__bridge id)[JL_color_blue_3D75ED colorWithAlphaComponent:1.0f].CGColor] text:currentDateStr textColor:JL_color_white_ffffff font:kFontPingFangSCMedium(9.0f) textAlignment:NSTextAlignmentCenter cornerRadius:0.0f];
        [backImageView addSubview:dateLabel];
        
        [contentView addSubview:self.cycleScrollView];
    }
    return _announceView;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(96.0f, 20.0f, kScreenWidth - 15.0f * 2 - 96.0f - 10.0f, self.announceView.frameHeight - 10.0f * 2 - 20.0f * 2) delegate:self placeholderImage:nil];
        _cycleScrollView.backgroundColor = JL_color_clear;
        _cycleScrollView.onlyDisplayText = YES;
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _cycleScrollView.titleLabelBackgroundColor = JL_color_clear;
        _cycleScrollView.titleLabelTextColor = JL_color_gray_333333;
        _cycleScrollView.titleLabelTextFont = kFontPingFangSCRegular(13.0f);
        _cycleScrollView.titleLabelTextAlignment = NSTextAlignmentLeft;
        [_cycleScrollView disableScrollGesture];
        _cycleScrollView.autoScrollTimeInterval = 5.0f;
        _cycleScrollView.delegate = self;
    }
    return _cycleScrollView;
}

- (JLAuctionSectionView *)auctionSectionView {
    if (!_auctionSectionView) {
        WS(weakSelf)
        _auctionSectionView = [[JLAuctionSectionView alloc] initWithFrame:CGRectMake(0.0f, self.announceView.frameBottom, kScreenWidth, 370.0f)];
        _auctionSectionView.entryBlock = ^(NSInteger index) {
            JLAuctionDetailViewController *auctionDetailVC = [[JLAuctionDetailViewController alloc] init];
            auctionDetailVC.auctionMeetingData = weakSelf.auctionArray[index];
            [weakSelf.navigationController pushViewController:auctionDetailVC animated:YES];
        };
    }
    return _auctionSectionView;
}


- (UIView *)themeRecommendView {
    if (!_themeRecommendView) {
        _themeRecommendView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.announceView.frameBottom, kScreenWidth, 0.0f)];
        _themeRecommendView.backgroundColor = JL_color_white_ffffff;
    }
    return _themeRecommendView;
}

#pragma mark - 数据懒加载
- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)announceArray {
    if (!_announceArray) {
        _announceArray = [NSMutableArray array];
    }
    return _announceArray;
}

- (NSMutableArray *)auctionArray {
    if (!_auctionArray) {
        _auctionArray = [NSMutableArray array];
    }
    return _auctionArray;
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

- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"热门原创", @"精品拍卖"];
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
    NSMutableArray <UIViewController *> *populerVCArray = [NSMutableArray array];
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JLHomeHotViewController *populerVC = [[JLHomeHotViewController alloc] init];
        populerVC.type = idx;
        populerVC.lookArtDetailBlock = ^(Model_art_Detail_Data * _Nonnull artDetailData) {
            JLArtDetailViewController *vc = [[JLArtDetailViewController alloc] init];
            vc.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
            vc.artDetailData = artDetailData;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        populerVC.lookAuctionDetailBlock = ^(Model_auctions_Data * _Nonnull auctionsData) {
            JLNewAuctionArtDetailViewController *vc = [[JLNewAuctionArtDetailViewController alloc] init];
            vc.auctionsId = auctionsData.ID;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        [populerVCArray addObject:populerVC];
    }];
    return populerVCArray.copy;
}
@end
