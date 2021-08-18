//
//  JLAuctionSubmitOrderViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionSubmitOrderViewController.h"
#import "JLAuctionSubmitOrderContentView.h"
#import "JLCashAccountPasswordAuthorizeView.h"

#import "JLWechatPayWebViewController.h"
#import "JLAlipayWebViewController.h"
#import "JLNewAuctionArtDetailViewController.h"

@interface JLAuctionSubmitOrderViewController ()<JLAuctionSubmitOrderContentViewDelegate>

@property (nonatomic, strong) JLAuctionSubmitOrderContentView *contentView;

@property (nonatomic, strong) Model_auctions_Data *auctionsData;

@property (nonatomic, copy) NSString *cashAccountBalance;

@end

@implementation JLAuctionSubmitOrderViewController

#pragma mark - life cycles
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadCashAccount:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提交订单";
    [self addBackItem];

    [self.view addSubview:self.contentView];
    
    [self loadAuctionsData];
}

/// 将视图控制器移除栈
- (void)fihishViewControllers {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isMemberOfClass:JLNewAuctionArtDetailViewController.class]) {
            [arr removeObject:vc];
        }
    }
    self.navigationController.viewControllers = [arr copy];
}

#pragma mark - JLAuctionSubmitOrderContentViewDelegate
/// 刷新数据
- (void)refreshData {
    [self loadAuctionsData];
}
/// 超时未支付
- (void)overduePayment {
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCALNOTIFICATION_JL_OVERDUE_PAYMENT_AUCTION object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
/// 支付订单
/// @param payType 支付方式
/// @param money 付款金额
- (void)payOrder: (JLOrderPayTypeName)payType money:(NSString *)money {
    JLLog(@"payType: %@ money: %@", payType, money);
    WS(weakSelf)
    if (payType == JLOrderPayTypeNameAccount) {
        [JLCashAccountPasswordAuthorizeView showWithTitle:@"输入饭团密码完成支付" complete:^(NSString * _Nonnull passwords) {
            [[JLViewControllerTool appDelegate].walletTool authorizeWithPasswords:passwords with:^(BOOL success) {
                if (success) {
                    NSLog(@"密码验证成功");
                    [weakSelf submitOrderToService:payType];
                }else {
                    NSLog(@"密码验证失败");
                    [[JLLoading sharedLoading] showMBFailedTipMessage:@"密码验证失败！" hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        } cancel:nil];
    }else {
        [weakSelf submitOrderToService:payType];
    }
}

#pragma mark - loadDatas
/// 获取拍卖信息
- (void)loadAuctionsData {
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

            if ([NSString stringIsEmpty:weakSelf.cashAccountBalance]) {
                [weakSelf loadCashAccount:^(BOOL isSuccess) {
                    [weakSelf.contentView setAuctionsData:weakSelf.auctionsData cashAccountBalance:weakSelf.cashAccountBalance];
                }];
            }else {
                [weakSelf.contentView setAuctionsData:weakSelf.auctionsData cashAccountBalance:weakSelf.cashAccountBalance];
            }
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}
/// 获取现金账户余额
- (void)loadCashAccount: (void(^)(BOOL isSuccess))complete {
    WS(weakSelf)
    Model_accounts_Req *request = [[Model_accounts_Req alloc] init];
    Model_accounts_Rsp *response = [[Model_accounts_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            for (Model_account_Data *model in response.body) {
                if ([model.currency_code isEqualToString:@"rmb"]) {
                    weakSelf.cashAccountBalance = model.balance;
                    break;
                }
            }
            if (![NSString stringIsEmpty:weakSelf.cashAccountBalance]) {
                if (complete) {
                    complete(YES);
                }
            }else {
                if (complete) {
                    complete(NO);
                }
            }
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
            if (complete) {
                complete(NO);
            }
        }
    }];
}

/// 提交订单
- (void)submitOrderToService:(JLOrderPayTypeName)payType {
    WS(weakSelf)
    Model_art_trades_Req *request = [[Model_art_trades_Req alloc] init];
    request.auction_id = _auctionsId;
    request.order_from = @"ios";
    request.pay_type = payType;
    Model_art_trades_Rsp *response = [[Model_art_trades_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (payType == JLOrderPayTypeNameAccount) {
                [[JLLoading sharedLoading] showMBSuccessTipMessage:@"支付成功" hideTime:KToastDismissDelayTimeInterval];
                [[NSNotificationCenter defaultCenter] postNotificationName:LOCALNOTIFICATION_JL_CASHACCOUNT_PAY_SUCCESS_AUCTION object:nil];
                [self fihishViewControllers];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
                NSString *payUrl = response.body[@"url"];
                if (![NSString stringIsEmpty:payUrl]) {
                    if (payType == JLOrderPayTypeNameWepay) {
                        // 打开支付页面
                        JLWechatPayWebViewController *payWebVC = [[JLWechatPayWebViewController alloc] init];
                        payWebVC.payUrl = payUrl;
                        payWebVC.payGoodType = JLWechatPayWebViewControllerPayGoodTypeAuctionArt;
                        [weakSelf.navigationController pushViewController:payWebVC animated:YES];
                    } else if (payType == JLOrderPayTypeNameAlipay) {
                        JLAlipayWebViewController *payWebVC = [[JLAlipayWebViewController alloc] init];
                        payWebVC.payUrl = payUrl;
                        [weakSelf.navigationController pushViewController:payWebVC animated:YES];
                    }
                }else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:@"支付url为空，请重试" hideTime:KToastDismissDelayTimeInterval];
                }
            }
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

#pragma mark - setters and getters
- (JLAuctionSubmitOrderContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLAuctionSubmitOrderContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
    }
    return _contentView;
}

@end
