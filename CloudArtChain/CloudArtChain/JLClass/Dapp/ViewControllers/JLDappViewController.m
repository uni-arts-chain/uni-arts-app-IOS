//
//  JLDappViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappViewController.h"
#import "JLDappContentView.h"

#import "JLScanViewController.h"

@interface JLDappViewController ()<JLDappContentViewDelegate>

@property (nonatomic, strong) JLDappContentView *contentView;

@end

@implementation JLDappViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发现";
    
    [self.view addSubview:self.contentView];
    
    [self loadDatas];
}

#pragma mark - JLDappContentViewDelegate
- (void)search {
    JLLog(@"搜索");
}

- (void)scanCode {
    WS(weakSelf)
    JLScanViewController *scanVC = [[JLScanViewController alloc] init];
    scanVC.scanType = JLScanTypeOther;
    scanVC.qrCode = true;
    scanVC.resultBlock = ^(NSString * _Nonnull scanResult) {
        JLLog(@"扫码 结果: %@", scanResult);
    };
    scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:scanVC animated:YES completion:nil];
}

- (void)refreshData {
    [self loadDatas];
}

- (void)lookMoreWithType: (JLDappContentViewLookMoreType)type {
    JLLog(@"查看更多: %ld", type);
}

- (void)refreshChainInfoDatasWithSymbol: (JLMultiChainSymbol)symbol {
    JLLog(@"查看链下的信息: %@", symbol);
}

- (void)lookCollect {
    JLLog(@"查看收藏");
}

- (void)lookRecently {
    JLLog(@"查看最近");
}

- (void)lookDappWithUrl: (NSString *)url {
    JLLog(@"查看Dapp url: %@", url);
}

#pragma mark - loadDatas
- (void)loadDatas {
    self.contentView.chainSymbolArray = @[JLMultiChainSymbolETH, JLMultiChainSymbolUART];
    
    self.contentView.trackArray = @[@"",@"",@"",@"",@"",@"",@""];
    self.contentView.recommendArray = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    self.contentView.transactionArray = @[@"",@"",@"",@"",@""];
}

#pragma mark - setters and getters
- (JLDappContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLDappContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
    }
    return _contentView;
}

@end
