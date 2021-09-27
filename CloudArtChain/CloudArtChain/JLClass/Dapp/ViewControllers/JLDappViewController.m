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
