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
#import "JLDappSearchViewController.h"
#import "JLDappMoreViewController.h"

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
    JLDappSearchViewController *vc = [[JLDappSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
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

- (void)refreshDataWithTrackType: (JLDappContentViewTrackType)trackType chainSymbol: (JLMultiChainSymbol)chainSymbol {
    JLLog(@"刷新信息 trackType: %ld chainSymbol: %@", trackType, chainSymbol);
    [self loadDatas];
}

- (void)lookMoreWithType: (JLDappContentViewLookMoreType)type {
    JLLog(@"查看更多: %ld", type);
    JLDappMoreViewController *vc = [[JLDappMoreViewController alloc] init];
    vc.type = [self exchangeTypeFrom:type];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshChainInfoDatasWithSymbol: (JLMultiChainSymbol)symbol {
    JLLog(@"查看链下的信息: %@", symbol);
}

- (void)lookTrackWithType: (JLDappContentViewTrackType)type {
    JLLog(@"查看收藏或最近: %ld", type);
}

- (void)lookDappWithUrl: (NSString *)url {
    JLLog(@"查看Dapp url: %@", url);
    
    // dapp浏览器
    NSString *dappUrl = @"https://app.dodoex.io/exchange/ETH-USDC?C3VK=3a0ea1&network=rinkeby";
//    NSString *dappUrl = @"https://app.dodoex.io/exchange/ETH-USDC?C3VK=bd2bc1&network=mainnet";
//    NSString *dappUrl = @"https://cbridge.celer.network/?locale=zh-CN&utm_source=imtoken";
    
    [JLEthereumTool.shared lookDappWithNavigationViewController:(JLNavigationViewController *)self.navigationController name:@"imKey" imgUrl:@"http://bpic.588ku.com/element_origin_min_pic/18/08/24/05dbcc82c8d3bd356e57436be0922357.jpg" webUrl:[NSURL URLWithString:dappUrl] isCollect: NO collectCompletion:^(BOOL isCollect) {
        JLLog(@"是否收藏: %@", isCollect ? @"收藏":@"取消收藏");
    }];
}

#pragma mark - loadDatas
- (void)loadDatas {
    self.contentView.chainSymbolArray = @[JLMultiChainSymbolETH, JLMultiChainSymbolUART];
    
    self.contentView.trackArray = @[@"",@"",@"",@"",@"",@"",@""];
    self.contentView.recommendArray = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    self.contentView.transactionArray = @[@"",@"",@"",@"",@""];
}

#pragma mark - private methods
- (JLDappMoreViewControllerType)exchangeTypeFrom: (JLDappContentViewLookMoreType)type {
    if (type == JLDappContentViewLookMoreTypeCollect) {
        return JLDappMoreViewControllerTypeCollect;
    }else if (type == JLDappContentViewLookMoreTypeRecently) {
        return JLDappMoreViewControllerTypeRecently;
    }else if (type == JLDappContentViewLookMoreTypeRecommend) {
        return JLDappMoreViewControllerTypeRecommend;
    }else {
        return JLDappMoreViewControllerTypeTransaction;
    }
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
