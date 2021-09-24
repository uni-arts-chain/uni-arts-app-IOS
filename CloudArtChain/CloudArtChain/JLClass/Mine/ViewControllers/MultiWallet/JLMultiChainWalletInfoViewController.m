//
//  JLMultiChainWalletInfoViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletInfoViewController.h"
#import "JLMultiChainWalletInfoHeaderView.h"

#import "JLSegmentViewController.h"
#import "JLMultiChainWalletInfoListViewController.h"
#import "JLMultiChainWalletEditViewController.h"

@interface JLMultiChainWalletInfoViewController ()<JLSegmentViewControllerDelegate, JLMultiChainWalletInfoHeaderViewDelegate>

@property (nonatomic, strong) JLSegmentViewController *segmentVC;

@property (nonatomic, strong) JLMultiChainWalletInfoHeaderView *headerView;

@end

@implementation JLMultiChainWalletInfoViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _walletInfo.chainSymbol;
    [self addBackItem];
    
    JLMultiChainWalletInfoListViewController *tokenVC = [[JLMultiChainWalletInfoListViewController alloc] init];
    tokenVC.topInset = 260;
    tokenVC.style = JLMultiChainWalletInfoListContentViewStyleToken;
    tokenVC.walletInfo = _walletInfo;
    JLMultiChainWalletInfoListViewController *nftVC = [[JLMultiChainWalletInfoListViewController alloc] init];
    nftVC.topInset = 260;
    nftVC.style = JLMultiChainWalletInfoListContentViewStyleNFT;
    nftVC.walletInfo = _walletInfo;
    
    _segmentVC = [[JLSegmentViewController alloc] initWithFrame:self.view.bounds viewControllers:@[tokenVC, nftVC]];
    _segmentVC.delegate = self;
    [self addChildViewController:_segmentVC];
    [self.view addSubview:_segmentVC.view];
    
    [self.view addSubview:self.headerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMultiWalletName:) name:LOCALNOTIFICATION_JL_CHANGEMULTIWALLETNAMESUCCESS object:nil];
}

- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - JLSegmentViewControllerDelegate
- (void)scrollOffset:(CGPoint)offset {
    [self.headerView scrollOffset:offset.x];
}

#pragma mark - JLMultiChainWalletInfoHeaderViewDelegate
- (void)didTitleWithIndex: (NSInteger)index {
    [_segmentVC moveToViewControllerAtIndex:index];
}

- (void)lookAddressQRCode: (NSString *)address {
    JLChainQRCodeView *addressQRCodeView = [[JLChainQRCodeView alloc] initWithFrame:CGRectMake(0, 0, 225, 225) qrcodeString:address];
    addressQRCodeView.center = self.view.center;
    LewPopupViewAnimationSpring *animation = [[LewPopupViewAnimationSpring alloc] init];
    [self lew_presentPopupView:addressQRCodeView animation:animation];
}

- (void)settting {
    JLMultiChainWalletEditViewController *vc = [[JLMultiChainWalletEditViewController alloc] init];
    vc.walletInfo = _walletInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification
- (void)changeMultiWalletName: (NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    NSString *walletName = dict[_walletInfo.storeKey];
    if (![NSString stringIsEmpty:walletName]) {
        _walletInfo.walletName = walletName;
        
        self.headerView.walletInfo = _walletInfo;
    }
}

#pragma mark - setters and getters
- (JLMultiChainWalletInfoHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JLMultiChainWalletInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 260)];
        _headerView.delegate = self;
        _headerView.walletInfo = _walletInfo;
    }
    return _headerView;
}

@end
