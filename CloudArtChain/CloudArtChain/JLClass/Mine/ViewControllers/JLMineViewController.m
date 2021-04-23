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

#import "JLMineNaviView.h"
#import "JLMineOrderView.h"
#import "JLMineAppView.h"

@interface JLMineViewController ()
@property (nonatomic, strong) JLMineNaviView *mineNaviView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JLMineOrderView *orderView;
@property (nonatomic, strong) JLMineAppView *mineAppView;
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
        _orderView.walletBlock = ^{
            NSString *userAvatar = [NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]] ? nil : [AppSingleton sharedAppSingleton].userBody.avatar[@"url"];
            [[JLViewControllerTool appDelegate].walletTool presenterLoadOnLaunchWithNavigationController:[AppSingleton sharedAppSingleton].globalNavController userAvatar:userAvatar];
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
                    // 作品收藏
                    JLCollectViewController *collectVC = [[JLCollectViewController alloc] init];
                    [weakSelf.navigationController pushViewController:collectVC animated:YES];
                }
                    break;
                case 5:
                {
                    // 关于我们
                }
                    break;
                case 6:
                {
                    // 消息
                    JLMessageViewController *messageVC = [[JLMessageViewController alloc] init];
                    [weakSelf.navigationController pushViewController:messageVC animated:YES];
                }
                    break;
                case 7:
                {
                    // 客服
                    JLCustomerServiceViewController *customerServiceVC = [[JLCustomerServiceViewController alloc] init];
                    [weakSelf.navigationController pushViewController:customerServiceVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _mineAppView;
}
@end
