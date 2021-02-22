//
//  JLImportWalletViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/4.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLImportWalletViewController.h"
#import "JLScanViewController.h"

#import "JLPageMenuView.h"
#import "JLImportWalletMnemonicView.h"
#import "JLImportWalletPrivateKeyView.h"

@interface JLImportWalletViewController ()
@property (nonatomic, strong) JLPageMenuView *pageMenuView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *mnemonicScrollView;
@property (nonatomic, strong) JLImportWalletMnemonicView *mnemonicView;
@property (nonatomic, strong) UIScrollView *privateKeyScrollView;
@property (nonatomic, strong) JLImportWalletPrivateKeyView *privateKeyView;
@end

@implementation JLImportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"导入钱包";
    [self addBackItem];
    [self addRightItemImage:@"icon_navi_scan"];
    [self createSubViews];
}

- (void)rightItemClick {
    JLScanViewController *scanVC = [[JLScanViewController alloc] init];
    scanVC.scanType = JLScanTypeImportWallet;
    scanVC.qrCode = YES;
    scanVC.resultBlock = ^(NSString *scanResult) {
        NSLog(@"%@", scanResult);
    };
    scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:scanVC animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - KStatusBar_Navigation_Height - 65.0f - KTouch_Responder_Height);
    self.mnemonicScrollView.contentSize = CGSizeMake(kScreenWidth, self.mnemonicView.frameBottom + 20.0f);
    self.privateKeyScrollView.contentSize = CGSizeMake(kScreenWidth, self.privateKeyView.frameBottom + 20.0f);
}

- (void)createSubViews {
    [self.view addSubview:self.pageMenuView];
    [self.pageMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(65.0f);
    }];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pageMenuView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
    }];
    [self.scrollView addSubview:self.mnemonicScrollView];
    [self.mnemonicScrollView addSubview:self.mnemonicView];
    [self.scrollView addSubview:self.privateKeyScrollView];
    [self.privateKeyScrollView addSubview:self.privateKeyView];
}

- (JLPageMenuView *)pageMenuView {
    if (!_pageMenuView) {
        WS(weakSelf)
        _pageMenuView = [[JLPageMenuView alloc] initWithMenus:@[@"助记词", @"私钥"] itemMargin:120.0f];
        _pageMenuView.indexChangedBlock = ^(NSInteger index) {
            [weakSelf.scrollView setContentOffset:CGPointMake(index * kScreenWidth, 0.0f) animated:YES];
        };
    }
    return _pageMenuView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = JL_color_white_ffffff;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

- (UIScrollView *)mnemonicScrollView {
    if (!_mnemonicScrollView) {
        _mnemonicScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - 65.0f - KTouch_Responder_Height)];
        _mnemonicScrollView.backgroundColor = JL_color_white_ffffff;
        _mnemonicScrollView.showsVerticalScrollIndicator = NO;
        _mnemonicScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _mnemonicScrollView;
}

- (JLImportWalletMnemonicView *)mnemonicView {
    if (!_mnemonicView) {
        _mnemonicView = [[JLImportWalletMnemonicView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 0.0f)];
    }
    return _mnemonicView;
}

- (UIScrollView *)privateKeyScrollView {
    if (!_privateKeyScrollView) {
        _privateKeyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kScreenWidth, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - 65.0f - KTouch_Responder_Height)];
        _privateKeyScrollView.backgroundColor = JL_color_white_ffffff;
        _privateKeyScrollView.showsVerticalScrollIndicator = NO;
        _privateKeyScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _privateKeyScrollView;
}

- (JLImportWalletPrivateKeyView *)privateKeyView {
    if (!_privateKeyView) {
        _privateKeyView = [[JLImportWalletPrivateKeyView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 0.0f)];
    }
    return _privateKeyView;
}
@end
