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

@property (nonatomic, strong) UIButton *importWalletBtn;

@end

@implementation JLMultiChainWalletInfoViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _walletInfo.chainSymbol;
    [self addBackItem];
    
    if (_walletInfo.chainSymbol == JLMultiChainSymbolUART) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.importWalletBtn];
    }
    // token
    JLMultiChainWalletInfoListViewController *tokenVC = [[JLMultiChainWalletInfoListViewController alloc] init];
    tokenVC.topInset = 260;
    if (_walletInfo.chainSymbol == JLMultiChainSymbolUART) {
        tokenVC.style = JLMultiChainWalletInfoListContentViewStyleMainToken;
    }else {
        tokenVC.style = JLMultiChainWalletInfoListContentViewStyleToken;
    }
    tokenVC.walletInfo = _walletInfo;
    // nft
    JLMultiChainWalletInfoListViewController *nftVC = [[JLMultiChainWalletInfoListViewController alloc] init];
    nftVC.topInset = 260;
    if (_walletInfo.chainSymbol == JLMultiChainSymbolUART) {
        nftVC.style = JLMultiChainWalletInfoListContentViewStyleMainNFT;
    }else {
        nftVC.style = JLMultiChainWalletInfoListContentViewStyleTokenNFT;
    }
    nftVC.walletInfo = _walletInfo;
    
    _segmentVC = [[JLSegmentViewController alloc] initWithFrame:self.view.bounds viewControllers:@[tokenVC, nftVC]];
    _segmentVC.delegate = self;
    [self addChildViewController:_segmentVC];
    [self.view addSubview:_segmentVC.view];
    
    [self.view addSubview:self.headerView];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(walletNameNotification:) name:@"WalletNameNotification" object:nil];
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
    if (_walletInfo.chainSymbol == JLMultiChainSymbolUART) {
        JLEditWalletViewController *vc = [[JLEditWalletViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        JLMultiChainWalletEditViewController *vc = [[JLMultiChainWalletEditViewController alloc] init];
        vc.walletInfo = _walletInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - event response
- (void)importWalletBtnClick: (UIButton *)sender {
    WS(weakSelf)
    UIAlertController *alertVC = [UIAlertController alertShowWithTitle:@"提示" message:@"重新导入钱包后，当前钱包将被覆盖，请先备份好当前钱包助记词" cancel:@"取消" cancelHandler:^{

    } confirm:@"继续导入" confirmHandler:^{
        [[JLViewControllerTool appDelegate].walletTool importWalletFrom:weakSelf];
    }];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Notification
- (void)walletNameNotification: (NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    NSString *walletName = dict[@"walletName"];
    if (![NSString stringIsEmpty:walletName]) {
        _walletInfo.walletName = walletName;
        
        self.headerView.walletInfo = _walletInfo;
    }
}
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

- (UIButton *)importWalletBtn {
    if (!_importWalletBtn) {
        _importWalletBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        if (_walletInfo.chainSymbol == JLMultiChainSymbolUART) {
            _importWalletBtn.hidden = NO;
        }else {
            _importWalletBtn.hidden = YES;
        }
        [_importWalletBtn setTitle:@"导入钱包" forState:UIControlStateNormal];
        [_importWalletBtn setTitleColor:JL_color_blue_50C3FF forState:UIControlStateNormal];
        _importWalletBtn.titleLabel.font = kFontPingFangSCRegular(15);
        [_importWalletBtn addTarget:self action:@selector(importWalletBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _importWalletBtn;
}

@end
