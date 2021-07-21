//
//  JLAuctionOrderDetailViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/20.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionOrderDetailViewController.h"
#import "JLAuctionOrderDetailContentView.h"
#import "JLAuctionDepositPayView.h"
#import "JLCashAccountPasswordAuthorizeView.h"

@interface JLAuctionOrderDetailViewController ()<JLAuctionOrderDetailContentViewDelegate>

@property (nonatomic, strong) JLAuctionOrderDetailContentView *contentView;

@end

@implementation JLAuctionOrderDetailViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    [self addBackItem];
    
    [self.view addSubview:self.contentView];
}

#pragma mark -  JLAuctionOrderDetailContentViewDelegate
/// 支付订单
- (void)payOrder:(NSString *)payMoney {
    
    [JLAuctionDepositPayView showWithTitle:@"订单支付" tipTitle:@"已中标，订单超时未支付将会扣除保证金" payMoney:payMoney cashAccountBalance:@"1000.0" complete:^(JLAuctionDepositPayViewPayType payType) {
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

/// 刷新数据
- (void)refreshData {
    NSLog(@"刷新数据");
}

#pragma mark - setters and getters
- (JLAuctionOrderDetailContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLAuctionOrderDetailContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
        _contentView.type = _type;
    }
    return _contentView;
}

@end
