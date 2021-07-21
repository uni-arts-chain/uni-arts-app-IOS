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

@interface JLNewAuctionArtDetailViewController ()<JLNewAuctionArtDetailContentViewDelegate>

@property (nonatomic, strong) JLNewAuctionArtDetailContentView *contentView;

@property (nonatomic, assign) NSInteger networkStatus;

@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;

/// live2d下载 task
@property (nonatomic, strong) NSURLSessionTask *live2DDownloadTask;

@end

@implementation JLNewAuctionArtDetailViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    [self addBackItem];
    
    [self.view addSubview:self.contentView];
    
    self.networkStatus = [[NSUserDefaults standardUserDefaults] integerForKey:LOCALNOTIFICATION_JL_NETWORK_STATUS_CHANGED];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:LOCALNOTIFICATION_JL_NETWORK_STATUS_CHANGED object:nil];
    
    [self loadArtDatas];
}

#pragma mark - JLNewAuctionArtDetailContentViewDelegate
/// 刷新数据
- (void)refreshData {
    [self loadArtDatas];
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
    
//    [self offer];
    [self cancelAuction];
//    [self payDeposit];
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
    NSString *contentText = @"一、本《拍卖须知》根据《中华人民共和国民事诉讼法》等相关法律规定所制订，竞买人应认真仔细阅读，了解本须知的全部内容。\r\n二、本次拍卖活动遵循“公开、公平、公正、诚实守信”的原则，拍卖活动具备法律效力。参加本次拍卖活动的当事人和竞买人必须遵守本须知的各项条款，并对自己的行为承担法律责任。\r\n三、优先购买权人参加竞买的，应于2018年7月28日前向本院提交合法有效的证明，资格经法院确认后才能参与竞买，逾期不提交的，视为放弃对本标的物享有优先购买权。\r\n四、拍卖成交后，买受人应在拍卖结束后7日内缴纳拍卖余款，可通过银行付款或者支付宝网上支付，详细请咨询法院，并在2018年8月15日前（遇节假日顺延）（凭付款凭证及相关身份材料）到江西省乐平市人民法院签署《拍卖成交确认书》，办理拍卖标的物交付手续。";
    JLAuctionRuleViewController *vc = [[JLAuctionRuleViewController alloc] init];
    vc.contentText = contentText;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 查看更多出价列表
- (void)offerRecordList {
    NSLog(@"查看更多出价列表");
    
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
            weakSelf.artDetailData.author = authorData;
            
            weakSelf.contentView.artDetailData = weakSelf.artDetailData;
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

#pragma mark - loadDatas
- (void)loadArtDatas {
    WS(weakSelf)
    Model_arts_detail_Req *reqeust = [[Model_arts_detail_Req alloc] init];
    reqeust.art_id = self.artDetailId;
    Model_arts_detail_Rsp *response = [[Model_arts_detail_Rsp alloc] init];
    response.request = reqeust;
    
    if (!self.artDetailData) {
        [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    }
    [JLNetHelper netRequestGetParameters:reqeust respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            weakSelf.artDetailData = response.body;
            
            weakSelf.contentView.artDetailData = weakSelf.artDetailData;
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
                    weakSelf.artDetailData = response.body;
                    weakSelf.contentView.artDetailData = weakSelf.artDetailData;
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
                    weakSelf.artDetailData = response.body;
                    weakSelf.contentView.artDetailData = weakSelf.artDetailData;
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
                    weakSelf.artDetailData = response.body;
                    weakSelf.contentView.artDetailData = weakSelf.artDetailData;
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
                    weakSelf.artDetailData = response.body;
                    weakSelf.contentView.artDetailData = weakSelf.artDetailData;
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
                    weakSelf.artDetailData = response.body;
                    weakSelf.contentView.artDetailData = weakSelf.artDetailData;
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
                    weakSelf.artDetailData = response.body;
                    weakSelf.contentView.artDetailData = weakSelf.artDetailData;
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }
    }
}

#pragma mark - private methods
/// 支付保证金
- (void)payDeposit {
    [JLAuctionDepositPayView showWithTitle:@"买家保证金" tipTitle:@"竞拍不成功，保证金将在拍卖结束3-7个工作日内退回" payMoney:@"150.0" cashAccountBalance:@"160.0" complete:^(JLAuctionDepositPayViewPayType payType) {
        if (payType == JLAuctionDepositPayViewPayTypeCashAccount) {
            // 账户支付 验证密码
            [JLCashAccountPasswordAuthorizeView showWithTitle:@"输入饭团密码完成支付" complete:^(NSString * _Nonnull passwords) {
                [[JLViewControllerTool appDelegate].walletTool authorizeWithPasswords:passwords with:^(BOOL success) {
                    if (success) {
                        NSLog(@"密码验证成功");
                    }else {
                        NSLog(@"密码验证失败");
                        [[JLLoading sharedLoading] showMBFailedTipMessage:@"密码验证失败！" hideTime:KToastDismissDelayTimeInterval];
                    }
                }];
            } cancel:nil];
        }else if (payType == JLAuctionDepositPayViewPayTypeWechat) {
            // 打开支付页面
//            JLWechatPayWebViewController *payWebVC = [[JLWechatPayWebViewController alloc] init];
//            payWebVC.payUrl = payUrl;
//            [weakSelf.navigationController pushViewController:payWebVC animated:YES];
        }else {
//            JLAlipayWebViewController *payWebVC = [[JLAlipayWebViewController alloc] init];
//            payWebVC.payUrl = payUrl;
//            [weakSelf.navigationController pushViewController:payWebVC animated:YES];
        }
    }];
}

/// 出价
- (void)offer {
    [JLAuctionOfferView showWithCurrentPrice:@"1000.0" offerPrice:@"800.0" addPrice:@"200.0" done:^(NSString * _Nonnull offer) {
        NSLog(@"出价: %@", offer);
    }];
}

/// 取消拍卖
- (void)cancelAuction {
    [JLAlertView alertWithTitle:@"提示" message:@"是否确认取消拍卖？" doneTitle:@"确认" cancelTitle:@"取消" done:^{
        NSLog(@"取消拍卖");
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
