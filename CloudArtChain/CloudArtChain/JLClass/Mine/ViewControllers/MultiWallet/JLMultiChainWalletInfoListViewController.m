//
//  JLMultiChainWalletInfoListViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletInfoListViewController.h"

@interface JLMultiChainWalletInfoListViewController ()<JLMultiChainWalletInfoListContentViewDelegate>

@property (nonatomic, strong) JLMultiChainWalletInfoListContentView *contentView;

@property (nonatomic, assign) NSInteger page;

@end

@implementation JLMultiChainWalletInfoListViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    
    [self.view addSubview:self.contentView];
    
    [self prepareSource];
}

#pragma mark - JLMultiChainWalletInfoListContentViewDelegate
- (void)refresh {
    _page= 1;
    [self prepareSource];
}

- (void)loadMore {
    _page += 1;
    [self prepareSource];
}

#pragma mark - private methods
- (void)prepareSource {
    WS(weakSelf)
    if (_style == JLMultiChainWalletInfoListContentViewStyleMainToken) {
        _contentView.walletInfo = _walletInfo;
        [[JLViewControllerTool appDelegate].walletTool getAccountBalanceWithBalanceBlock:^(NSString *amount) {
            JLLog(@"uart balance: %@", amount);
            weakSelf.contentView.amount = amount;
        }];
    }else if (_style == JLMultiChainWalletInfoListContentViewStyleToken) {
        _contentView.walletInfo = _walletInfo;
        if (_walletInfo.chainSymbol == JLMultiChainSymbolETH) {
            // 以太坊账户 余额
            [JLEthereumTool.shared getCurrentWalletBalanceWithCompletion:^(NSString * _Nullable balance, NSString * _Nullable errorMsg) {
                JLLog(@"ethereum balance: %@", balance);
                weakSelf.contentView.amount = balance;
            }];
        }
    }else {
        _contentView.page = _page;
        _contentView.pageSize = kPageSize;
        _contentView.nftArray = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    }
}

#pragma mark - setters and getters
- (JLMultiChainWalletInfoListContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLMultiChainWalletInfoListContentView alloc] initWithFrame:CGRectMake(0, _topInset, kScreenWidth, kScreenHeight - _topInset - KStatusBar_Navigation_Height)];
        _contentView.style = _style;
        _contentView.delegate = self;
    }
    return _contentView;
}

@end
