//
//  JLMultiChainWalletVerifyMnemonicViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/24.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletVerifyMnemonicViewController.h"
#import "JLMultiChainWalletVerifyMnemonicContentView.h"

@interface JLMultiChainWalletVerifyMnemonicViewController ()<JLMultiChainWalletVerifyMnemonicContentViewDelegate>

@property (nonatomic, strong) JLMultiChainWalletVerifyMnemonicContentView *contentView;

@end

@implementation JLMultiChainWalletVerifyMnemonicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"备份助记词";
    [self addBackItem];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"稍后备份" style:UIBarButtonItemStyleDone target:self action:@selector(laterToBackup)];
    
    [self.view addSubview:self.contentView];
}

- (void)laterToBackup {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - JLMultiChainWalletVerifyMnemonicContentViewDelegate
- (void)done {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - setters and getters
- (JLMultiChainWalletVerifyMnemonicContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLMultiChainWalletVerifyMnemonicContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
        _contentView.mnemonicArray = _mnemonicArray;
    }
    return _contentView;
}

@end
