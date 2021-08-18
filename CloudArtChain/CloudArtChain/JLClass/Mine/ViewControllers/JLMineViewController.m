//
//  JLMineViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLMineViewController.h"
#import "JLHomePageViewController.h"
#import "JLSettingViewController.h"
#import "JLMessageViewController.h"
#import "JLCustomerServiceViewController.h"
#import "JLUploadWorkViewController.h"
#import "JLSinglePurchaseOrderViewController.h"
#import "JLSingleSellOrderViewController.h"
#import "JLReceiveAddressViewController.h"
#import "JLCollectViewController.h"
#import "JLFocusViewController.h"
#import "JLFansViewController.h"
#import "JLFeedBackViewController.h"
#import "UIAlertController+Alert.h"
#import "JLBindPhoneWithoutPwdViewController.h"
#import "JLExchangeNFTViewController.h"
#import "JLCashAccountViewController.h"
#import "JLAuctionHistoryViewController.h"

#import "JLMineNaviView.h"
#import "JLMineOrderView.h"
#import "JLMineAppView.h"

@interface JLMineViewController ()
@property (nonatomic, strong) JLMineNaviView *mineNaviView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JLMineOrderView *orderView;
@property (nonatomic, strong) JLMineAppView *mineAppView;
@property (nonatomic, assign) NSInteger messageUnreadNumber;
@property (nonatomic, copy) NSArray<Model_account_Data *> *cashAccountArray;
@property (nonatomic, assign) BOOL isWinAuctions;
@end

@implementation JLMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    WS(weakSelf)
    // 请求用户信息
    [AppSingleton loginInfonWithBlock:^{
        [weakSelf.mineNaviView refreshInfo];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    WS(weakSelf)
    [[JLViewControllerTool appDelegate].walletTool getAccountBalanceWithBalanceBlock:^(NSString *amount) {
        [weakSelf.orderView setCurrentAccountBalance:amount];
    }];
    [self requestHasUnreadMessages];
    [self loadCashAccount];
    [self loadAuctionsWinsDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self createView];
}

- (void)createView {
    [self.view addSubview:self.mineNaviView];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mineNaviView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    [self.scrollView addSubview:self.orderView];
    [self.scrollView addSubview:self.mineAppView];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.mineAppView.frameBottom);
}

- (JLMineNaviView *)mineNaviView {
    if (!_mineNaviView) {
        WS(weakSelf)
        _mineNaviView = [[JLMineNaviView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, KStatus_Bar_Height + 108.0f)];
        _mineNaviView.avatarBlock = ^{
            if (![JLLoginUtil haveSelectedAccount]) {
                [JLLoginUtil presentCreateWallet];
            } else {
                JLHomePageViewController *homePageVC = [[JLHomePageViewController alloc] init];
                [weakSelf.navigationController pushViewController:homePageVC animated:YES];
            }
        };
        _mineNaviView.settingBlock = ^{
            JLSettingViewController *settingVC = [[JLSettingViewController alloc] init];
            [weakSelf.navigationController pushViewController:settingVC animated:YES];
        };
        _mineNaviView.focusBlock = ^{
            JLFocusViewController *focusVC = [[JLFocusViewController alloc] init];
            [weakSelf.navigationController pushViewController:focusVC animated:YES];
        };
        _mineNaviView.fansBlock = ^{
            JLFansViewController *fansVC = [[JLFansViewController alloc] init];
            [weakSelf.navigationController pushViewController:fansVC animated:YES];
        };
    }
    return _mineNaviView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = JL_color_white_ffffff;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
//            [weakSelf.scrollView.mj_header endRefreshing];
//        }];
    }
    return _scrollView;
}

- (JLMineOrderView *)orderView {
    if (!_orderView) {
        _orderView = [[JLMineOrderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 131.0f)];
        WS(weakSelf)
        _orderView.walletBlock = ^{
            NSString *userAvatar = [NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]] ? nil : [AppSingleton sharedAppSingleton].userBody.avatar[@"url"];
            [[JLViewControllerTool appDelegate].walletTool presenterLoadOnLaunchWithNavigationController:[AppSingleton sharedAppSingleton].globalNavController userAvatar:userAvatar];
        };
        _orderView.cashAccountBlock = ^{
            JLCashAccountViewController *vc = [[JLCashAccountViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _orderView;
}

- (JLMineAppView *)mineAppView {
    if (!_mineAppView) {
        WS(weakSelf)
        _mineAppView = [[JLMineAppView alloc] initWithFrame:CGRectMake(0.0f, self.orderView.frameBottom + 20.0f, kScreenWidth, 180.0f)];
        _mineAppView.appClickBlock = ^(NSInteger index) {
            switch (index) {
                case 0:
                {
                    // 我的主页
                    JLHomePageViewController *homePageVC = [[JLHomePageViewController alloc] init];
                    [weakSelf.navigationController pushViewController:homePageVC animated:YES];
                }
                    break;
                case 1:
                {
                    // 上传作品
                    JLUploadWorkViewController *uploadWorkVC = [[JLUploadWorkViewController alloc] init];
                    __weak typeof(uploadWorkVC) weakUploadWorkVC = uploadWorkVC;
                    uploadWorkVC.checkProcessBlock = ^{
                        [weakUploadWorkVC.navigationController popViewControllerAnimated:NO];
                        JLHomePageViewController *homePageVC = [[JLHomePageViewController alloc] init];
                        [weakSelf.navigationController pushViewController:homePageVC animated:YES];
                    };
                    [weakSelf.navigationController pushViewController:uploadWorkVC animated:YES];
                }
                    break;
                case 2:
                {
                    // 买入订单
                    JLSinglePurchaseOrderViewController *purchaseOrderVC = [[JLSinglePurchaseOrderViewController alloc] init];
                    [weakSelf.navigationController pushViewController:purchaseOrderVC animated:YES];
                }
                    break;
                case 3:
                {
                    // 卖出订单
                    JLSingleSellOrderViewController *sellOrderVC = [[JLSingleSellOrderViewController alloc] init];
                    [weakSelf.navigationController pushViewController:sellOrderVC animated:YES];
                }
                    break;
                case 4:
                {
                    // 拍卖纪录
                    JLAuctionHistoryViewController *vc = [[JLAuctionHistoryViewController alloc] init];
                    if (weakSelf.isWinAuctions) {
                        vc.defaultType = JLAuctionHistoryTypeWins;
                    }
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 5:
                {
                    // 作品收藏
                    JLCollectViewController *collectVC = [[JLCollectViewController alloc] init];
                    [weakSelf.navigationController pushViewController:collectVC animated:YES];
                }
                    break;
                case 6:
                {
                    // 兑换NFT 判断用户是否绑定手机号码
                    if ([NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.phone_number]) {
                        UIAlertController *alert = [UIAlertController alertShowWithTitle:@"提示" message:@"请先绑定手机号" cancel:@"取消" cancelHandler:^{
                            
                        } confirm:@"去绑定" confirmHandler:^{
                            JLBindPhoneWithoutPwdViewController *bindPhoneVC = [[JLBindPhoneWithoutPwdViewController alloc] init];
                            bindPhoneVC.bindPhoneSuccessBlock = ^(NSString * _Nonnull bindPhone) {
                                [AppSingleton sharedAppSingleton].userBody.phone_number = bindPhone;
                            };
                            [weakSelf.navigationController pushViewController:bindPhoneVC animated:YES];
                        }];
                        [weakSelf presentViewController:alert animated:YES completion:nil];
                    } else {
                        // 兑换NFT
                        JLExchangeNFTViewController *exchangeNFTVC = [[JLExchangeNFTViewController alloc] init];
                        [weakSelf.navigationController pushViewController:exchangeNFTVC animated:YES];
                    }
                }
                    break;
                case 7:
                {
                    // 消息
                    JLMessageViewController *messageVC = [[JLMessageViewController alloc] init];
                    messageVC.messageUnreadNumber = weakSelf.messageUnreadNumber;
                    [weakSelf.navigationController pushViewController:messageVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _mineAppView;
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
        }
    }];
}

#pragma mark - 获取现金账户余额
- (void)loadCashAccount {
    WS(weakSelf)
    Model_accounts_Req *request = [[Model_accounts_Req alloc] init];
    Model_accounts_Rsp *response = [[Model_accounts_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.cashAccountArray = response.body;
            for (Model_account_Data *model in weakSelf.cashAccountArray) {
                if ([model.currency_code isEqualToString:@"rmb"]) {
                    [weakSelf.orderView setCashAccountBalance:model.balance];
                }
            }
        }
    }];
}

#pragma mark - 获取拍卖中标数
- (void)loadAuctionsWinsDatas {
    Model_auctions_history_Req *request = [[Model_auctions_history_Req alloc] init];
    request.page = 1;
    request.per_page = kPageSize;
    request.historyType = JLAuctionHistoryTypeWins;
    Model_auctions_history_Rsp *response = [[Model_auctions_history_Rsp alloc] init];
    response.request = request;
    
    WS(weakSelf)
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (response.body.count) {
                weakSelf.isWinAuctions = YES;
                weakSelf.mineAppView.isWinAuction = YES;
            }
        }
    }];
}

@end
