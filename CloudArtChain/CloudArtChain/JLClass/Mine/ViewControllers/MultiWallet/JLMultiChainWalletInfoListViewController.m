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
@property (nonatomic, strong) NSMutableArray *dataArray;

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

#pragma mark - loadDatas
- (void)loadMainNFTDatas {
    WS(weakSelf)
    Model_arts_mine_Req *request = [[Model_arts_mine_Req alloc] init];
    request.page = _page;
    request.per_page = kPageSize;
    request.aasm_state = @"online";
    Model_arts_mine_Rsp *response = [[Model_arts_mine_Rsp alloc] init];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (weakSelf.page == 1) {
                [weakSelf.dataArray removeAllObjects];
                for (Model_art_Detail_Data *artData in response.body) {
                    JLWalletNFTData *nftData = [[JLWalletNFTData alloc] init];
                    nftData.name = artData.name;
                    nftData.imageUrl = artData.img_main_file1[@"url"];
                    nftData.amount = artData.has_amount;
                    [weakSelf.dataArray addObject:nftData];
                }
            }else {
                for (Model_art_Detail_Data *artData in response.body) {
                    JLWalletNFTData *nftData = [[JLWalletNFTData alloc] init];
                    nftData.name = artData.name;
                    nftData.imageUrl = artData.img_main_file1[@"url"];
                    nftData.amount = artData.has_amount;
                    [weakSelf.dataArray addObject:nftData];
                }
            }
            [weakSelf.contentView setDataArray:[weakSelf.dataArray copy] page:weakSelf.page pageSize:kPageSize];
        } else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
            [weakSelf.contentView setDataArray:[weakSelf.dataArray copy] page:weakSelf.page pageSize:kPageSize];
        }
    }];
}

- (void)loadTokenNFTDatas {
    [_contentView setDataArray:@[] page:_page pageSize:kPageSize];
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
    }else if (_style == JLMultiChainWalletInfoListContentViewStyleMainNFT) {
        [self loadMainNFTDatas];
    }else if (_style == JLMultiChainWalletInfoListContentViewStyleTokenNFT) {
        [self loadTokenNFTDatas];
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
