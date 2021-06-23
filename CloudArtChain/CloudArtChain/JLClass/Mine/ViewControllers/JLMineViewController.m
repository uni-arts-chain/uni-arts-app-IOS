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

#import "JLMineContentView.h"

@interface JLMineViewController ()<JLMineContentViewDelegate>

@property (nonatomic, strong) JLMineContentView *contentView;

@property (nonatomic, assign) NSInteger messageUnreadNumber;

@end

@implementation JLMineViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    WS(weakSelf)
    // 请求用户信息
    [AppSingleton loginInfonWithBlock:^{
        [weakSelf.contentView refreshInfo];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    WS(weakSelf)
    [[JLViewControllerTool appDelegate].walletTool getAccountBalanceWithBalanceBlock:^(NSString *amount) {
        weakSelf.contentView.amount = amount;
    }];
    [self requestHasUnreadMessages];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
    [self.view addSubview:self.contentView];
}

#pragma mark - JLMineContentViewDelegate
/// 跳转页面
- (void)jumpToVC: (JLMineContentViewItemType)itemType {
    if (itemType == JLMineContentViewItemTypeHomePage) {
        [self lookHomePage];
    }else if (itemType == JLMineContentViewItemTypeIntegral) {
        [self lookWallet];
    }else if (itemType == JLMineContentViewItemTypeSetting) {
        [self lookSetting];
    }else if (itemType == JLMineContentViewItemTypeBuyOrder) {
        [self lookBuyOrder];
    }else if (itemType == JLMineContentViewItemTypeSellOrder) {
        [self lookSellOrder];
    }else if (itemType == JLMineContentViewItemTypeMessage) {
        [self lookMessage];
    }else if (itemType == JLMineContentViewItemTypeCustomerService) {
        [self lookCustomerService];
    }else if (itemType == JLMineContentViewItemTypeUploadWork) {
        [self uploadWork];
    }else if (itemType == JLMineContentViewItemTypeCollect) {
        [self lookCollect];
    }
}

#pragma mark - private methods
- (void)lookHomePage {
    if (![JLLoginUtil haveSelectedAccount]) {
        [JLLoginUtil presentCreateWallet];
    } else {
        JLHomePageViewController *homePageVC = [[JLHomePageViewController alloc] init];
        [self.navigationController pushViewController:homePageVC animated:YES];
    }
}

- (void)lookSetting {
    JLSettingViewController *settingVC = [[JLSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)lookWallet {
    NSString *userAvatar = [NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]] ? nil : [AppSingleton sharedAppSingleton].userBody.avatar[@"url"];
    [[JLViewControllerTool appDelegate].walletTool presenterLoadOnLaunchWithNavigationController:[AppSingleton sharedAppSingleton].globalNavController userAvatar:userAvatar];
}

- (void)lookBuyOrder {
    JLSinglePurchaseOrderViewController *purchaseOrderVC = [[JLSinglePurchaseOrderViewController alloc] init];
    [self.navigationController pushViewController:purchaseOrderVC animated:YES];
}

- (void)lookSellOrder {
    JLSingleSellOrderViewController *sellOrderVC = [[JLSingleSellOrderViewController alloc] init];
    [self.navigationController pushViewController:sellOrderVC animated:YES];
}

- (void)lookMessage {
    JLMessageViewController *messageVC = [[JLMessageViewController alloc] init];
    messageVC.messageUnreadNumber = self.messageUnreadNumber;
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)lookCustomerService {
    JLCustomerServiceViewController *customerServiceVC = [[JLCustomerServiceViewController alloc] init];
    [self.navigationController pushViewController:customerServiceVC animated:YES];
}

- (void)uploadWork {
    WS(weakSelf)
    JLUploadWorkViewController *uploadWorkVC = [[JLUploadWorkViewController alloc] init];
    __weak typeof(uploadWorkVC) weakUploadWorkVC = uploadWorkVC;
    uploadWorkVC.checkProcessBlock = ^{
        [weakUploadWorkVC.navigationController popViewControllerAnimated:NO];
        JLHomePageViewController *homePageVC = [[JLHomePageViewController alloc] init];
        [weakSelf.navigationController pushViewController:homePageVC animated:YES];
    };
    [self.navigationController pushViewController:uploadWorkVC animated:YES];
}

- (void)lookCollect {
    JLCollectViewController *collectVC = [[JLCollectViewController alloc] init];
    [self.navigationController pushViewController:collectVC animated:YES];
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

#pragma mark - setters and getters
- (JLMineContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLMineContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KTabBar_Height)];
        _contentView.delegate = self;
    }
    return _contentView;
}

@end
