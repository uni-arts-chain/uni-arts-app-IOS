//
//  JLMultiChainWalletEditViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletEditViewController.h"
#import "JLMultiChainWalletEditContentView.h"
#import "JLPrivateKeyExportView.h"

#import "JLProtocolViewController.h"
#import "JLExportKeystorePwdViewController.h"
#import "JLMultiChainWalletBackupMnemonicViewController.h"

@interface JLMultiChainWalletEditViewController ()<JLMultiChainWalletEditContentViewDelegate>

@property (nonatomic, strong) JLMultiChainWalletEditContentView *contentView;

@property (nonatomic, strong) JLPrivateKeyExportView *privateKeyExportView;

@end

@implementation JLMultiChainWalletEditViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑钱包";
    [self addBackItem];
    
    [self.view addSubview:self.contentView];
}

#pragma mark - JLMultiChainWalletEditContentViewDelegate
- (void)saveWalletName: (NSString *)walletName {
    _walletInfo.walletName = walletName;
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:USERDEFAULTS_JL_MULTI_WALLET_NAME];
    NSMutableArray *resultArr = [NSMutableArray arrayWithArray:arr];
    NSDictionary *resultDict = @{ _walletInfo.storeKey : walletName };
    
    BOOL isFind = NO;
    for (int i = 0; i < resultArr.count; i++) {
        NSDictionary *dict = resultArr[i];
        NSString *name = dict[_walletInfo.storeKey];
        if (![NSString stringIsEmpty:name]) {
            isFind = YES;
            [resultArr replaceObjectAtIndex:i withObject:resultDict];
            break;
        }
    }
    
    if (!isFind) {
        [resultArr addObject:resultDict];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[resultArr copy] forKey:USERDEFAULTS_JL_MULTI_WALLET_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCALNOTIFICATION_JL_CHANGEMULTIWALLETNAMESUCCESS object:nil userInfo:@{ _walletInfo.storeKey : walletName }];
    
    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"已保存" hideTime:KToastDismissDelayTimeInterval];
}

- (void)changePinCode {
    [[JLViewControllerTool appDelegate].walletTool changePinSetupFrom:self.navigationController];
}

- (void)exportPrivateKey {
    WS(weakSelf)
    [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
        if (success) {
            [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
            [JLEthereumTool.shared exportPrivateKeyWithCompletion:^(NSString * _Nullable privateKey, NSString * _Nullable errorMsg) {
                [[JLLoading sharedLoading] hideLoading];
                if (![NSString stringIsEmpty:privateKey]) {
                    weakSelf.privateKeyExportView.privateKey = privateKey;
                    [JLAlert alertCustomView:weakSelf.privateKeyExportView maxWidth:kScreenWidth - 40.0f * 2];
                }else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:[NSString stringWithFormat:@"导出失败: %@", errorMsg] hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }
    }];
}

- (void)exportKeystore {
    WS(weakSelf)
    [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
        if (success) {
            JLExportKeystorePwdViewController *exportKeystorePwdVC = [[JLExportKeystorePwdViewController alloc] init];
            exportKeystorePwdVC.walletInfo = weakSelf.walletInfo;
            [weakSelf.navigationController pushViewController:exportKeystorePwdVC animated:YES];
        }
    }];
}

- (void)privateProtocol {
    JLProtocolViewController *protocolVC = [[JLProtocolViewController alloc] init];
    [self.navigationController pushViewController:protocolVC animated:YES];
}

- (void)backupsMnemonic {
    WS(weakSelf)
    [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
        if (success) {
            [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
            [JLEthereumTool.shared exportMnemonicWithCompletion:^(NSArray<NSString *> * _Nonnull mnemonics, NSString * _Nullable errorMsg) {
                [[JLLoading sharedLoading] hideLoading];
                if (mnemonics.count) {
                    JLMultiChainWalletBackupMnemonicViewController *vc = [[JLMultiChainWalletBackupMnemonicViewController alloc] init];
                    vc.mnemonicArray = mnemonics;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:@"此账户不能导出助记词" hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }
    }];
}

#pragma mark - setters and getters
- (JLMultiChainWalletEditContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLMultiChainWalletEditContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
        _contentView.walletInfo = _walletInfo;
    }
    return _contentView;
}

- (JLPrivateKeyExportView *)privateKeyExportView {
    if (!_privateKeyExportView) {
        _privateKeyExportView = [[JLPrivateKeyExportView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth - 40.0f * 2, 270.0f)];
        ViewBorderRadius(_privateKeyExportView, 5.0f, 0.0f, JL_color_clear);
    }
    return _privateKeyExportView;
}

@end
