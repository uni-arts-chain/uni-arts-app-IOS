//
//  JLNewAuctionArtDetailViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/19.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLNewAuctionArtDetailViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JLNewAuctionArtDetailContentView.h"
#import "WMPhotoBrowser.h"
#import "JLLive2DCacheManager.h"
#import "JLAuctionDepositPayView.h"
#import "JLCashAccountPasswordAuthorizeView.h"
#import "JLAuctionOfferView.h"

#import "JLHomePageViewController.h"
#import "JLCreatorPageViewController.h"
#import "JLWechatPayWebViewController.h"
#import "JLAlipayWebViewController.h"
#import "JLAuctionRuleViewController.h"
#import "JLLaunchAuctionViewController.h"
#import "JLAuctionOrderDetailViewController.h"
#import "JLAuctionOfferRecordViewController.h"
#import "JLAuctionSubmitOrderViewController.h"

@interface JLNewAuctionArtDetailViewController ()<JLNewAuctionArtDetailContentViewDelegate>

@property (nonatomic, strong) JLNewAuctionArtDetailContentView *contentView;

@property (nonatomic, assign) NSInteger networkStatus;

@property (nonatomic, strong) Model_auctions_Data *auctionsData;

@property (nonatomic, strong) Model_account_Data *accountData;

@property (nonatomic, copy) NSArray *bidHistoryArray;

/// live2d下载 task
@property (nonatomic, strong) NSURLSessionTask *live2DDownloadTask;

@end

@implementation JLNewAuctionArtDetailViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadCashAccount];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    [self addBackItem];
    
    [self fihishViewControllers];
    
    [self.view addSubview:self.contentView];
    
    self.networkStatus = [[NSUserDefaults standardUserDefaults] integerForKey:LOCALNOTIFICATION_JL_NETWORK_STATUS_CHANGED];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:LOCALNOTIFICATION_JL_NETWORK_STATUS_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(h5PayFinishedGoback:)
        name:LOCALNOTIFICATION_H5PAYFIHISHEDGOBACK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResultNotification:) name:LOCALNOTIFICATION_JL_ALIPAYRESULTNOTIFICATION object:nil];
    
    [self loadAuctionsData:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"释放了: %@", self.class);
}

/// 将视图控制器移除栈
- (void)fihishViewControllers {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isMemberOfClass:JLLaunchAuctionViewController.class]) {
            [arr removeObject:vc];
        }
    }
    self.navigationController.viewControllers = [arr copy];
}

#pragma mark - JLNewAuctionArtDetailContentViewDelegate
/// 刷新数据
- (void)refreshData {
    [self loadAuctionsData:nil];
}

/// 喜欢
/// @param isLike 是否喜欢
/// @param artId 艺术品id
- (void)like: (BOOL)isLike artId: (NSString *)artId {
    [self likeToService:isLike artId:artId];
}

/// 踩
/// @param isTread 是否踩
/// @param artId 艺术品id
- (void)tread: (BOOL)isTread artId: (NSString *)artId {
    [self treadToService:isTread artId:artId];
}

/// 收藏
/// @param isCollect 是否收藏
/// @param artId 艺术品id
- (void)collected: (BOOL)isCollect artId: (NSString *)artId {
    [self collectToService:isCollect artId:artId];
}

/// 右侧按钮点击事件
/// @param status 取消拍卖/缴纳保证金/出价/中标支付
- (void)doneStatus: (JLNewAuctionArtDetailBottomViewStatus)status {
    if (status == JLNewAuctionArtDetailBottomViewStatusCancelAuction) {
        [self cancelAuction];
    }else if (status == JLNewAuctionArtDetailBottomViewStatusPayEarnestMoney) {
        [self payDeposit];
    }else if (status == JLNewAuctionArtDetailBottomViewStatusOffer) {
        [self offer];
    }else if (status == JLNewAuctionArtDetailBottomViewStatusWinBidding) {
        JLAuctionSubmitOrderViewController *vc = [[JLAuctionSubmitOrderViewController alloc] init];
        vc.auctionsId = self.auctionsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/// 播放视频
/// @param videoUrl 视频url
- (void)playVideo: (NSString *)videoUrl {
    [self playVideoWithUrl:videoUrl];
}

/// 查看图片或live2d
/// @param artDetailData 艺术品信息
/// @param currentIndex 当前图片索引
- (void)lookPageFlow: (Model_art_Detail_Data *)artDetailData currentIndex: (NSInteger)currentIndex {
    [self lookImageOrLive2d:artDetailData currentIndex:currentIndex];
}

/// 竞拍须知
- (void)auctionRule {
    JLAuctionRuleViewController *vc = [[JLAuctionRuleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/// 查看更多出价列表
- (void)offerRecordList: (NSArray *)bidHistoryArray {
    JLAuctionOfferRecordViewController *vc = [[JLAuctionOfferRecordViewController alloc] init];
    vc.bidHistoryArray = bidHistoryArray;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 查看作者信息
/// @param authorData 作者信息
/// @param isSelf 是否是自己
- (void)lookCreaterHomePage: (Model_art_author_Data *)authorData isSelf: (BOOL)isSelf {
    WS(weakSelf)
    if (isSelf) {
        JLHomePageViewController *homePageVC = [[JLHomePageViewController alloc] init];
        [self.navigationController pushViewController:homePageVC animated:YES];
    } else {
        JLCreatorPageViewController *creatorPageVC = [[JLCreatorPageViewController alloc] init];
        creatorPageVC.authorData = authorData;
        creatorPageVC.followOrCancelBlock = ^(Model_art_author_Data * _Nonnull authorData) {
            weakSelf.auctionsData.art.author = authorData;
            
            weakSelf.contentView.auctionsData = weakSelf.auctionsData;
        };
        [self.navigationController pushViewController:creatorPageVC animated:YES];
    }
}

/// 查看作品信息图片
/// @param imageArray 图片数组
/// @param currentIndex 当前图片索引
- (void)lookInfoImage: (NSArray *)imageArray currentIndex: (NSInteger)currentIndex {
    WMPhotoBrowser *browser = [WMPhotoBrowser new];
    browser.dataSource = [imageArray mutableCopy];
    browser.downLoadNeeded = YES;
    browser.currentPhotoIndex = currentIndex;
    browser.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:browser animated:YES completion:nil];
}

#pragma mark - Notification
- (void)networkStatusChanged: (NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    self.networkStatus = [dict[@"status"] integerValue];
}

- (void)alipayResultNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSDictionary *result = userInfo[@"result"];
    NSString *resultStatus = result[@"ResultStatus"];
    if (resultStatus.intValue == 9000) {
        [self loadAuctionsData:nil];
    }
}

- (void)h5PayFinishedGoback:(NSNotification *)notification {
    [self loadAuctionsData:nil];
}

#pragma mark - loadDatas
- (void)loadAuctionsData: (void(^)(BOOL isSuccess))complete {
    WS(weakSelf)
    Model_auctions_id_Req *reqeust = [[Model_auctions_id_Req alloc] init];
    reqeust.ID = self.auctionsId;
    Model_auctions_id_Rsp *response = [[Model_auctions_id_Rsp alloc] init];
    response.request = reqeust;
    
    if (!self.auctionsData) {
        [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    }
    [JLNetHelper netRequestGetParameters:reqeust respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.auctionsData = response.body;
            
            weakSelf.contentView.auctionsData = weakSelf.auctionsData;
            
            if (weakSelf.auctionsData.server_timestamp.integerValue >= weakSelf.auctionsData.end_time.integerValue) {
                // 拍卖时间结束
                [[NSNotificationCenter defaultCenter] postNotificationName:LOCALNOTIFICATION_JL_END_AUCTION object:nil];
            }
            
            [weakSelf loadAuctionBidHistoriesData:complete];
        }
    }];
}

/// 出价列表
- (void)loadAuctionBidHistoriesData: (void(^)(BOOL isSuccess))complete {
    WS(weakSelf)
    Model_auctions_id_bid_histories_Req *reqeust = [[Model_auctions_id_bid_histories_Req alloc] init];
    reqeust.ID = self.auctionsId;
    Model_auctions_id_bid_histories_Rsp *response = [[Model_auctions_id_bid_histories_Rsp alloc] init];
    response.request = reqeust;
    
    [JLNetHelper netRequestGetParameters:reqeust respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            weakSelf.bidHistoryArray = response.body;
            weakSelf.contentView.bidHistoryArray = weakSelf.bidHistoryArray;
            if (complete) {
                complete(YES);
            }
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
            if (complete) {
                complete(NO);
            }
        }
    }];
}

/// 支付保证金
- (void)payDepositToService: (JLAuctionDepositPayViewPayType)payType {
    WS(weakSelf)
    Model_auction_deposits_Req *reqeust = [[Model_auction_deposits_Req alloc] init];
    reqeust.auction_id = self.auctionsId;
    reqeust.order_from = @"ios";
    if (payType == JLAuctionDepositPayViewPayTypeCashAccount) {
        reqeust.pay_type = @"account";
    }else if (payType == JLAuctionDepositPayViewPayTypeAlipay) {
        reqeust.pay_type = @"alipay";
    }else if (payType == JLAuctionDepositPayViewPayTypeWechat) {
        reqeust.pay_type = @"wepay";
    }
    Model_auction_deposits_Rsp *response = [[Model_auction_deposits_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestPostParameters:reqeust responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (payType == JLAuctionDepositPayViewPayTypeAlipay) {
                JLAlipayWebViewController *payWebVC = [[JLAlipayWebViewController alloc] init];
                payWebVC.payUrl = response.body[@"url"];
                [weakSelf.navigationController pushViewController:payWebVC animated:YES];
            }else if (payType == JLAuctionDepositPayViewPayTypeWechat) {
                JLWechatPayWebViewController *payWebVC = [[JLWechatPayWebViewController alloc] init];
                payWebVC.payUrl = response.body[@"url"];
                [weakSelf.navigationController pushViewController:payWebVC animated:YES];
            }else {
                [[JLLoading sharedLoading] showMBSuccessTipMessage:@"保证金缴纳成功" hideTime:KToastDismissDelayTimeInterval];
                [self loadAuctionsData:nil];
            }
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

/// 举牌出价
- (void)offerToService: (NSString *)price {
    WS(weakSelf)
    Model_auctions_id_bid_Req *reqeust = [[Model_auctions_id_bid_Req alloc] init];
    reqeust.ID = self.auctionsId;
    reqeust.price = price;
    Model_auctions_id_bid_Rsp *response = [[Model_auctions_id_bid_Rsp alloc] init];
    response.request = reqeust;
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestPostParameters:reqeust responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            [[JLLoading sharedLoading] showMBSuccessTipMessage:@"出价成功" hideTime:KToastDismissDelayTimeInterval];
            [weakSelf loadAuctionsData:nil];
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

// 取消拍卖
- (void)cancelAuctionToService {
    WS(weakSelf)
    Model_auctions_id_cancel_Req *request = [[Model_auctions_id_cancel_Req alloc] init];
    request.ID = self.auctionsId;
    Model_auctions_id_cancel_Rsp *response = [[Model_auctions_id_cancel_Rsp alloc] init];
    response.request = request;
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LOCALNOTIFICATION_JL_CANCEL_AUCTION object:nil];
            [[JLLoading sharedLoading] showMBSuccessTipMessage:@"已取消" hideTime:KToastDismissDelayTimeInterval];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

- (void)likeToService: (BOOL)isLike artId: (NSString *)artId {
    WS(weakSelf)
    if (![JLLoginUtil haveSelectedAccount]) {
        [JLLoginUtil presentCreateWallet];
    } else {
        if (!isLike) {
            // 取消赞
            Model_art_cancel_like_Req *request = [[Model_art_cancel_like_Req alloc] init];
            request.art_id = artId;
            Model_art_cancel_like_Rsp *response = [[Model_art_cancel_like_Rsp alloc] init];
            response.request = request;
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                if (netIsWork) {
                    weakSelf.auctionsData.art = response.body;
                    weakSelf.contentView.auctionsData = weakSelf.auctionsData;
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        } else {
            // 赞
            Model_arts_like_Req *request = [[Model_arts_like_Req alloc] init];
            request.art_id = artId;
            Model_arts_like_Rsp *response = [[Model_arts_like_Rsp alloc] init];
            response.request = request;
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                if (netIsWork) {
                    weakSelf.auctionsData.art = response.body;
                    weakSelf.contentView.auctionsData = weakSelf.auctionsData;
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }
    }
}

- (void)treadToService: (BOOL)isTread artId: (NSString *)artId {
    WS(weakSelf)
    if (![JLLoginUtil haveSelectedAccount]) {
        [JLLoginUtil presentCreateWallet];
    } else {
        if (!isTread) {
            // 取消踩
            Model_art_cancel_dislike_Req *request = [[Model_art_cancel_dislike_Req alloc] init];
            request.art_id = artId;
            Model_art_cancel_dislike_Rsp *response = [[Model_art_cancel_dislike_Rsp alloc] init];
            response.request = request;
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                if (netIsWork) {
                    weakSelf.auctionsData.art = response.body;
                    weakSelf.contentView.auctionsData = weakSelf.auctionsData;
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        } else {
            // 踩
            Model_art_dislike_Req *request = [[Model_art_dislike_Req alloc] init];
            request.art_id = artId;
            Model_art_dislike_Rsp *response = [[Model_art_dislike_Rsp alloc] init];
            response.request = request;
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                if (netIsWork) {
                    weakSelf.auctionsData.art = response.body;
                    weakSelf.contentView.auctionsData = weakSelf.auctionsData;
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }
    }
}

- (void)collectToService: (BOOL)isCollect artId: (NSString *)artId {
    WS(weakSelf)
    if (![JLLoginUtil haveSelectedAccount]) {
        [JLLoginUtil presentCreateWallet];
    } else {
        if (!isCollect) {
            // 取消收藏作品
            Model_art_unfavorite_Req *request = [[Model_art_unfavorite_Req alloc] init];
            request.art_id = artId;
            Model_art_unfavorite_Rsp *response = [[Model_art_unfavorite_Rsp alloc] init];
            response.request = request;
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                if (netIsWork) {
                    weakSelf.auctionsData.art = response.body;
                    weakSelf.contentView.auctionsData = weakSelf.auctionsData;
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        } else {
            // 收藏作品
            Model_art_favorite_Req *request = [[Model_art_favorite_Req alloc] init];
            request.art_id = artId;
            Model_art_favorite_Rsp *response = [[Model_art_favorite_Rsp alloc] init];
            response.request = request;
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                if (netIsWork) {
                    weakSelf.auctionsData.art = response.body;
                    weakSelf.contentView.auctionsData = weakSelf.auctionsData;
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }
    }
}

#pragma mark - 获取现金账户余额
- (void)loadCashAccount {
    WS(weakSelf)
    Model_accounts_Req *request = [[Model_accounts_Req alloc] init];
    Model_accounts_Rsp *response = [[Model_accounts_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            for (Model_account_Data *model in response.body) {
                if ([model.currency_code isEqualToString:@"rmb"]) {
                    weakSelf.accountData = model;
                }
            }
        }
    }];
}

#pragma mark - private methods
/// 支付保证金
- (void)payDeposit {
    WS(weakSelf)
    [JLAuctionDepositPayView showWithTitle:@"买家保证金" tipTitle:@"竞拍不成功，保证金将在拍卖结束3-7个工作日内退回" payMoney:self.auctionsData.deposit_amount cashAccountBalance:self.accountData.balance complete:^(JLAuctionDepositPayViewPayType payType) {
        if (payType == JLAuctionDepositPayViewPayTypeCashAccount) {
            // 账户支付 验证密码
            [JLCashAccountPasswordAuthorizeView showWithTitle:@"输入饭团密码完成支付" complete:^(NSString * _Nonnull passwords) {
                [[JLViewControllerTool appDelegate].walletTool authorizeWithPasswords:passwords with:^(BOOL success) {
                    if (success) {
                        NSLog(@"密码验证成功");
                        [weakSelf payDepositToService:payType];
                    }else {
                        NSLog(@"密码验证失败");
                        [[JLLoading sharedLoading] showMBFailedTipMessage:@"密码验证失败！" hideTime:KToastDismissDelayTimeInterval];
                    }
                }];
            } cancel:nil];
        }else {
            [self payDepositToService:payType];
        }
    }];
}

/// 出价
- (void)offer {
    WS(weakSelf)
    // 获取最新数据
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [self loadAuctionsData:^(BOOL isSuccess) {
        if (isSuccess) {
            NSString *currentPrice = weakSelf.auctionsData.current_price;
            NSString *addPrice = weakSelf.auctionsData.price_increment;
            NSString *offerPrice = @"0.0";
            if ([NSString stringIsEmpty:weakSelf.auctionsData.current_price]) {
                currentPrice = @"0.0";
                addPrice = weakSelf.auctionsData.start_price;
            }else {
                for (Model_auctions_bid_Data *data in self.bidHistoryArray) {
                    if ([data.member.ID isEqualToString:[AppSingleton sharedAppSingleton].userBody.ID]) {
                        offerPrice = data.price;
                        break;
                    }
                }
            }
            
            [JLAuctionOfferView showWithCurrentPrice:currentPrice offerPrice:offerPrice addPrice:addPrice done:^(NSString * _Nonnull offer) {
                NSLog(@"出价: ￥%@", offer);
                [weakSelf offerToService:offer];
            }];
        }
    }];
}

/// 取消拍卖
- (void)cancelAuction {
    [JLAlertView alertWithTitle:@"提示" message:@"是否确认取消拍卖？" doneTitle:@"确认" cancelTitle:@"取消" done:^{
        [self cancelAuctionToService];
    } cancel:nil];
}

- (void)playVideoWithUrl: (NSString *)url {
    if (self.networkStatus == AFNetworkReachabilityStatusUnknown ||
        self.networkStatus == AFNetworkReachabilityStatusNotReachable) {
        [JLAlert jlalertDefaultView:@"当前无网络或网络不可用，请稍后再试!" cancel:@"好的"];
        return;
    }else if (self.networkStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        [JLAlert jlalertView:@"提示" message:@"当前网络不是Wifi，继续播放将消耗数据流量，是否继续播放？" cancel:@"取消" cancelBlock:^{
            
        } confirm:@"播放" confirmBlock:^{
            AVPlayerViewController *aVPlayerViewController = [[AVPlayerViewController alloc] init];
            aVPlayerViewController.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:url]];
            [self presentViewController:aVPlayerViewController animated:YES completion:^{
                [aVPlayerViewController.player play];
            }];
        }];
    }else {
        AVPlayerViewController *aVPlayerViewController = [[AVPlayerViewController alloc] init];
        aVPlayerViewController.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:url]];
        [self presentViewController:aVPlayerViewController animated:YES completion:^{
            [aVPlayerViewController.player play];
        }];
    }
}

- (void)lookImageOrLive2d: (Model_art_Detail_Data *)artDetailData currentIndex: (NSInteger)currentIndex {
    WS(weakSelf)
    if ([NSString stringIsEmpty:artDetailData.live2d_file]) {
        NSArray *imageArray = [self imageArrayForArtDetailData:artDetailData];
        if (imageArray.count > 0) {
            //图片查看
            WMPhotoBrowser *browser = [WMPhotoBrowser new];
            //数据源
            browser.dataSource = [imageArray mutableCopy];
            browser.downLoadNeeded = YES;
            browser.currentPhotoIndex = currentIndex;
            browser.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:browser animated:YES completion:nil];
        }
    } else {
        NSString *live2d_file = artDetailData.live2d_file;
        NSString *live2d_ipfs_url = artDetailData.live2d_ipfs_zip_url;
        NSString *cacheFolder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Live2DFiles"];
        NSString *path = [cacheFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@.model3.json", artDetailData.ID, live2d_file, live2d_file]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            // 查找是否有背景图片
            NSString *jsonDirPath = [cacheFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/", artDetailData.ID, live2d_file]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *contents = [fileManager contentsOfDirectoryAtPath:jsonDirPath error:nil];
            NSEnumerator *e = [contents objectEnumerator];
            NSString *fileName;
            NSString *backImageName = @"";
            while (fileName = [e nextObject]) {
                if ([fileName containsString:@"BG"] && ![fileName containsString:@"MACOS"]) {
                    backImageName = fileName;
                }
            }
            // 查看Live2D
            [self showLive2D:backImageName artDetailData:artDetailData];
        } else {
            [[JLLoading sharedLoading] showProgressWithView:self.view message:@"正在下载Live2D文件" progress:0.0f];
            self.live2DDownloadTask = [[JLLive2DCacheManager shareManager] downLive2DWithPath:live2d_ipfs_url fileID:artDetailData.ID fileKey:[NSString stringWithFormat:@"%@.zip", live2d_file] progressBlock:^(CGFloat progress) {
                [[JLLoading sharedLoading] showProgressWithView:weakSelf.view message:@"正在下载Live2D文件" progress:progress];
            } success:^(NSURL *URL, NSString *backImageName) {
                [[JLLoading sharedLoading] hideLoading];
                [weakSelf showLive2D: backImageName artDetailData:artDetailData];
            } fail:^(NSString *message) {
                [[JLLoading sharedLoading] hideLoading];
                [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
            }];
        }
    }
}

- (NSArray *)imageArrayForArtDetailData: (Model_art_Detail_Data *)artDetalData {
    NSMutableArray *arr = [NSMutableArray array];
    NSString *fileImage1 = artDetalData.img_main_file1[@"url"];
    NSString *fileImage2 = artDetalData.img_main_file2[@"url"];
    NSString *fileImage3 = artDetalData.img_main_file3[@"url"];
    if (![NSString stringIsEmpty:fileImage1]) {
        [arr addObject:fileImage1];
    }
    if (![NSString stringIsEmpty:fileImage2]) {
        [arr addObject:fileImage2];
    }
    if (![NSString stringIsEmpty:fileImage3]) {
        [arr addObject:fileImage3];
    }
    
    return [arr copy];
}

- (void)showLive2D:(NSString *)backImageName artDetailData: (Model_art_Detail_Data *)artDetailData {
    NSString *live2d_file = artDetailData.live2d_file;
    NSString *cacheFolder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Live2DFiles"];
    AppDelegate* delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [self presentViewController:(UIViewController *)delegate.lAppViewController animated:YES completion:nil];
    NSString *modelPath = [cacheFolder stringByAppendingString:[NSString stringWithFormat:@"/%@/%@/", artDetailData.ID, live2d_file]];
    NSString *modelJsonName = [NSString stringWithFormat:@"%@.model3.json", live2d_file];
    NSString *backImagePath = @"";
    if (![NSString stringIsEmpty:backImageName]) {
        backImagePath = [modelPath stringByAppendingPathComponent:backImageName];
    }
    [delegate initializeCubismWithBack:backImagePath];
    [delegate changeSence:modelPath jsonName:modelJsonName];
}

#pragma mark - setters and getters
- (JLNewAuctionArtDetailContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLNewAuctionArtDetailContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
    }
    return _contentView;
}

@end
