//
//  JLMultiChainWalletBackupMnemonicViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletBackupMnemonicViewController.h"
#import "JLMultiChainWalletBackupMnemonicContentView.h"
#import "JLExportKeystoreSnapshotView.h"

#import "JLMultiChainWalletVerifyMnemonicViewController.h"

@interface JLMultiChainWalletBackupMnemonicViewController ()<JLMultiChainWalletBackupMnemonicContentViewDelegate>

@property (nonatomic, strong) JLMultiChainWalletBackupMnemonicContentView *contentView;

@end

@implementation JLMultiChainWalletBackupMnemonicViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"备份助记词";
    [self addBackItem];
    
    [self.view addSubview:self.contentView];
    
    [self showSnapshotView];
}

- (void)showSnapshotView {
    JLExportKeystoreSnapshotView *snapshotView = [[JLExportKeystoreSnapshotView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40.0 * 2, 280.0) understoodBlock:^{
        JLLog(@"知道了");
    }];
    snapshotView.layer.cornerRadius = 5.0;
    snapshotView.layer.masksToBounds = true;
    [JLAlert alertCustomView:snapshotView maxWidth:kScreenWidth - 40.0 * 2];
}

#pragma mark - JLMultiChainWalletBackupMnemonicContentViewDelegate
- (void)next {
    JLMultiChainWalletVerifyMnemonicViewController *vc = [[JLMultiChainWalletVerifyMnemonicViewController alloc] init];
    vc.mnemonicArray = _mnemonicArray;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - setters and getters
- (JLMultiChainWalletBackupMnemonicContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLMultiChainWalletBackupMnemonicContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
        _contentView.mnemonicArray = _mnemonicArray;
    }
    return _contentView;
}

@end
