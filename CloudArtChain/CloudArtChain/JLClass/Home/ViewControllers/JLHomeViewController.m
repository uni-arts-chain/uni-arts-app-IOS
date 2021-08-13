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
#import "JLNewHomeViewController.h"

#import "NewPagedFlowView.h"
#import "JLHomeAppView.h"
#import "SDCycleScrollView.h"
#import "JLPopularOriginalView.h"
#import "JLHomeNaviView.h"
#import "JLThemeRecommendView.h"
#import "JLAnnounceCollectionViewCell.h"
#import "JLAuctionSectionView.h"

#define scrollPageHeight 190.0f

@interface JLHomeViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource, SDCycleScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JLHomeNaviView *homeNaviView;
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
//        [self requestHasUnreadMessages];
    }
}

- (void)reloadAllService {
    [self requestHasUnreadMessages];
    [self requestBannersData];
    [self requestAnnounceData];
//    [self requestAuctionMeetingList];
//    [self requestThemeList];
}

- (void)headRefreshService {
    [self requestHasUnreadMessages];
    [self requestBannersData];
    [self requestAnnounceData];
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
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.homeNaviView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    // banner
    [self.scrollView addSubview:self.pageFlowView];
    // 应用列表
//    [self.scrollView addSubview:self.appView];
    // 公告
    [self.scrollView addSubview:self.announceView];
    // 拍卖列表
//    [self.scrollView addSubview:self.auctionSectionView];
    // 主题推荐
    [self.scrollView addSubview:self.themeRecommendView];
    // 热门原创
    [self.scrollView addSubview:self.popularOriginalView];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.popularOriginalView.frameBottom);
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
    }
    return _scrollView;
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
//            JLMessageViewController *messageVC = [[JLMessageViewController alloc] init];
//            messageVC.messageUnreadNumber = weakSelf.messageUnreadNumber;
//            [weakSelf.navigationController pushViewController:messageVC animated:YES];
            
            JLNewHomeViewController *vc = [[JLNewHomeViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _homeNaviView;
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

- (JLPopularOriginalView *)popularOriginalView {
    if (!_popularOriginalView) {
        WS(weakSelf)
        _popularOriginalView = [[JLPopularOriginalView alloc] initWithFrame:CGRectMake(0.0f, self.themeRecommendView.frameBottom, kScreenWidth, 80.0f)];
        _popularOriginalView.backgroundColor = JL_color_white_ffffff;
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
                artDetailVC.artDetailType = artDetailData.is_owner ? JLArtDetailTypeSelfOrOffShelf : JLArtDetailTypeDetail;
                artDetailVC.artDetailData = artDetailData;
                [weakSelf.navigationController pushViewController:artDetailVC animated:YES];
            }
        };
    }
    return _popularOriginalView;
}

#pragma mark NewPagedFlowView Datasource
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

#pragma mark NewPagedFlowView Delegate
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
            [weakSelf.scrollView.mj_header endRefreshing];
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
        [[JLLoading sharedLoading] hideLoading];
        [weakSelf.scrollView.mj_header endRefreshing];
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

//#pragma mark 请求拍卖会列表
//- (void)requestAuctionMeetingList {
//    WS(weakSelf)
//    Model_auction_meetings_Req *request = [[Model_auction_meetings_Req alloc] init];
//    request.page = 1;
//    request.per_page = 9999;
//    Model_auction_meetings_Rsp *response = [[Model_auction_meetings_Rsp alloc] init];
//
//    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
//        if (netIsWork) {
//            [weakSelf.auctionArray removeAllObjects];
//            [weakSelf.auctionArray addObjectsFromArray:response.body];
//
//            NSInteger popularOriginalViewRow = weakSelf.popularArray.count / 2;
//            if (weakSelf.popularArray.count % 2 != 0) {
//                popularOriginalViewRow += 1;
//            }
//            CGFloat themeRecommendViewHeight = 380.0f;
//            if (weakSelf.auctionArray.count == 0) {
//                // 没有拍卖数据
//                weakSelf.themeRecommendView.frame = CGRectMake(0.0f, self.announceView.frameBottom, kScreenWidth, themeRecommendViewHeight * self.themeArray.count + 16.0f * (self.themeArray.count - 1));
//                weakSelf.popularOriginalView.frame = CGRectMake(0.0f, self.themeRecommendView.frameBottom, kScreenWidth, 80.0f + [self getPopularViewHeight:popularOriginalViewRow]);
//                [weakSelf.popularOriginalView refreshFrame:CGRectMake(0.0f, self.themeRecommendView.frameBottom, kScreenWidth, 80.0f + [self getPopularViewHeight:popularOriginalViewRow])];
//                weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, self.popularOriginalView.frameBottom);
//            } else {
////                weakSelf.auctionSectionView.frame = CGRectMake(0.0f, self.announceView.frameBottom, kScreenWidth, 370.0f);
//                weakSelf.themeRecommendView.frame = CGRectMake(0.0f, self.announceView.frameBottom, kScreenWidth, themeRecommendViewHeight * self.themeArray.count + 16.0f * (self.themeArray.count - 1));
//                weakSelf.popularOriginalView.frame = CGRectMake(0.0f, self.themeRecommendView.frameBottom, kScreenWidth, 80.0f + [self getPopularViewHeight:popularOriginalViewRow]);
//                [weakSelf.popularOriginalView refreshFrame:CGRectMake(0.0f, self.themeRecommendView.frameBottom, kScreenWidth, 80.0f + [self getPopularViewHeight:popularOriginalViewRow])];
//                weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, self.popularOriginalView.frameBottom);
//            }
//            weakSelf.auctionSectionView.auctionArray = [weakSelf.auctionArray copy];
//        } else {
//            NSLog(@"error: %@", errorStr);
//        }
//    }];
//}

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
            
            NSInteger popularOriginalViewRow = weakSelf.popularArray.count / 2;
            if (weakSelf.popularArray.count % 2 != 0) {
                popularOriginalViewRow += 1;
            }
            CGFloat themeRecommendViewHeight = 397.0f;
            if (weakSelf.auctionArray.count == 0) {
                if (self.themeArray.count > 0) {
                    weakSelf.themeRecommendView.frame = CGRectMake(0.0f, self.announceView.frameBottom, kScreenWidth, themeRecommendViewHeight * self.themeArray.count + 16.0f * (self.themeArray.count - 1));
                }
                weakSelf.popularOriginalView.frame = CGRectMake(0.0f, self.themeRecommendView.frameBottom, kScreenWidth, 80.0f + [self getPopularViewHeight:popularOriginalViewRow]);
                [weakSelf.popularOriginalView refreshFrame:CGRectMake(0.0f, self.themeRecommendView.frameBottom, kScreenWidth, 80.0f + [self getPopularViewHeight:popularOriginalViewRow])];
                weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, self.themeRecommendView.frameBottom + 80.0f + [self getPopularViewHeight:popularOriginalViewRow]);
            } else {
                if (self.themeArray.count > 0) {
                    weakSelf.themeRecommendView.frame = CGRectMake(0.0f, self.announceView.frameBottom, kScreenWidth, themeRecommendViewHeight * self.themeArray.count + 16.0f * (self.themeArray.count - 1));
                }
                weakSelf.popularOriginalView.frame = CGRectMake(0.0f, self.themeRecommendView.frameBottom, kScreenWidth, 80.0f + [self getPopularViewHeight:popularOriginalViewRow]);
                [weakSelf.popularOriginalView refreshFrame:CGRectMake(0.0f, self.themeRecommendView.frameBottom, kScreenWidth, 80.0f + [self getPopularViewHeight:popularOriginalViewRow])];
                weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, self.themeRecommendView.frameBottom + 80.0f + [self getPopularViewHeight:popularOriginalViewRow]);
            }
            weakSelf.popularOriginalView.popularArray = [weakSelf.popularArray copy];
        } else {
            NSLog(@"error: %@", errorStr);
        }
    }];
}

- (CGFloat)getPopularViewHeight:(NSInteger)row {
    CGFloat columnFirstHeight = 0.0f;
    CGFloat columnSecondHeight = 0.0f;
    CGFloat itemW = (kScreenWidth - 15.0f * 2 - 14.0f) / 2;
    for (int i = 0; i < self.popularArray.count; i++) {
        Model_art_Detail_Data *iconModel = self.popularArray[i];
        //计算每个cell的高度
        float itemH = [self getcellHWithOriginSize:CGSizeMake(itemW, 45.0f + iconModel.imgHeight) itemW:itemW] + 14.0f;
        if (columnFirstHeight <= columnSecondHeight) {
            columnFirstHeight += itemH;
        } else {
            columnSecondHeight += itemH;
        }
    }
    return MAX(columnFirstHeight + 14.0f, columnSecondHeight + 14.0f);
}

//计算cell的高度
- (float)getcellHWithOriginSize:(CGSize)originSize itemW:(float)itemW {
    return itemW * originSize.height / originSize.width;
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
            
            CGFloat themeRecommendViewHeight = 397.0f;
            if (weakSelf.themeArray.count > 0) {
                weakSelf.themeRecommendView.frame = CGRectMake(0.0f, self.announceView.frameBottom, kScreenWidth, themeRecommendViewHeight * self.themeArray.count + 16.0f * (self.themeArray.count - 1));
            }
//            weakSelf.scrollView.contentSize = CGSizeMake(kScreenWidth, self.themeRecommendView.frameBottom);
            for (int i = 0; i < weakSelf.themeArray.count; i++) {
                JLThemeRecommendView *themeView = [[JLThemeRecommendView alloc] initWithFrame:CGRectMake(0.0f, (themeRecommendViewHeight + 16.0f) * i, kScreenWidth, themeRecommendViewHeight)];
                themeView.topicData = weakSelf.themeArray[i];
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
        }
        [weakSelf requestPopularList];
    }];
}

#pragma mark 懒加载初始化
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
@end
