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

@property (nonatomic, copy) NSArray *chainArray;
@property (nonatomic, strong) NSMutableArray *chainDappArray; // 包括推荐和分类下的dapp

@property (nonatomic, copy) NSString *currentChainId;

@end

@implementation JLDappViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发现";
    
    [self.view addSubview:self.contentView];
    
    [self loadFavoriteDapps];
    [self loadChainDatas: _currentChainId];
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
        if (![NSString stringIsEmpty:scanResult] &&
            [scanResult hasPrefix:@"https"] &&
            [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scanResult]]) {
//            [weakSelf lookDappWithUrl:scanResult];
        }else {
            [MBProgressHUD jl_showWithText:scanResult toView:weakSelf.view];
        }
    };
    scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:scanVC animated:YES completion:nil];
}

- (void)refreshDataWithTrackType: (JLDappContentViewTrackType)trackType chainData: (Model_chain_Data *)chainData {
    JLLog(@"刷新信息 trackType: %ld chainTitle: %@", trackType, chainData.title);
    
    if (trackType == JLDappContentViewTrackTypeCollect) {
        [self loadFavoriteDapps];
    }else {
        [self loadRecentlyDapps];
    }
    _currentChainId = chainData.ID;
    [self.chainDappArray removeAllObjects];
    [self loadChainDatas: _currentChainId];
}

- (void)lookTrackMoreWithType: (JLDappContentViewLookTrackMoreType)type {
    JLLog(@"查看收藏或最近更多: %ld", type);
//    JLDappMoreViewController *vc = [[JLDappMoreViewController alloc] init];
//    vc.type = [self exchangeTypeFrom:type];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lookChainCategoryMoreWithData: (Model_chain_category_Data *)chainCategoryData {
    JLLog(@"查看链分类更多: %@", chainCategoryData.title);
}

- (void)refreshChainInfoDatasWithChainData: (Model_chain_Data *)chainData {
    JLLog(@"查看链下的信息: %@", chainData.title);
    
    _currentChainId = chainData.ID;
    [self.chainDappArray removeAllObjects];
    [self loadChainDatas: _currentChainId];
}

- (void)lookTrackWithType: (JLDappContentViewTrackType)type {
    JLLog(@"查看收藏或最近: %ld", type);
    if (type == JLDappContentViewTrackTypeCollect) {
        [self loadFavoriteDapps];
    }else {
        [self loadRecentlyDapps];
    }
}

- (void)lookDappWithDappData: (Model_dapp_Data *)dappData {
    JLLog(@"查看Dapp url: %@", dappData.website_url);
    
    // dapp浏览器
    NSString *dappUrl = @"https://app.dodoex.io/exchange/ETH-USDC?C3VK=3a0ea1&network=rinkeby";
//    NSString *dappUrl = @"https://app.dodoex.io/exchange/ETH-USDC?C3VK=bd2bc1&network=mainnet";
//    NSString *dappUrl = @"https://cbridge.celer.network/?locale=zh-CN&utm_source=imtoken";
    
    WS(weakSelf)
    [JLEthereumTool.shared lookDappWithNavigationViewController:(JLNavigationViewController *)self.navigationController name:dappData.title imgUrl:dappData.logo.url webUrl:[NSURL URLWithString:dappUrl] isCollect: NO collectCompletion:^(BOOL isCollect) {
        JLLog(@"是否收藏: %@", isCollect ? @"收藏":@"取消收藏");
        [weakSelf favoriteDapp:dappData.ID isCollect:isCollect];
    }];
}

#pragma mark - loadDatas
- (void)loadChainDatas: (NSString * _Nullable)chainId {
    WS(weakSelf)
    Model_chains_Req *request = [[Model_chains_Req alloc] init];
    Model_chains_Rsp *response = [[Model_chains_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.chainArray = response.body;
            weakSelf.contentView.chainArray = weakSelf.chainArray;
            if (weakSelf.chainArray.count) {
                NSString *requestChainId = chainId;
                if ([NSString stringIsEmpty:requestChainId]) {
                    requestChainId = ((Model_chain_Data*)weakSelf.chainArray.firstObject).ID;
                }
                // 推荐dapp
                [weakSelf loadChainRecommendDapps:requestChainId completion:^{
                    [weakSelf loadChainCategories:requestChainId];
                }];
            }
        }else {
            [MBProgressHUD jl_showFailureWithText:errorStr toView:weakSelf.view];
        }
    }];
}

/// 加载链分类数据
- (void)loadChainCategories: (NSString *)chianId {
    WS(weakSelf)
    Model_chains_id_categories_Req *request = [[Model_chains_id_categories_Req alloc] init];
    request.ID = chianId;
    Model_chains_id_categories_Rsp *response = [[Model_chains_id_categories_Rsp alloc] init];
    response.request = request;

    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            [weakSelf.chainDappArray addObjectsFromArray:response.body];
            // 赋值给视图
            weakSelf.contentView.chainDappArray = weakSelf.chainDappArray;
        }else {
            [MBProgressHUD jl_showFailureWithText:errorStr toView:weakSelf.view];
        }
    }];
}

/// 获取推荐的链dapp列表
- (void)loadChainRecommendDapps: (NSString *)chianId completion: (void(^)(void))completion {
    WS(weakSelf)
    Model_chains_id_recommend_dapps_Req *request = [[Model_chains_id_recommend_dapps_Req alloc] init];
    request.ID = chianId;
    Model_chains_id_recommend_dapps_Rsp *response = [[Model_chains_id_recommend_dapps_Rsp alloc] init];
    response.request = request;
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        Model_chain_category_Data *chainCategoryData = [[Model_chain_category_Data alloc] init];
        chainCategoryData.title = @"推荐";
        if (netIsWork) {
            if (response.body.count > 9) {
                chainCategoryData.dapps = [response.body subarrayWithRange:NSMakeRange(0, 9)];
            }else {
                chainCategoryData.dapps = response.body;
            }
        }else {
            [MBProgressHUD jl_showFailureWithText:errorStr toView:weakSelf.view];
        }
        [weakSelf.chainDappArray addObject:chainCategoryData];
        completion();
    }];
}

/// 获取收藏过的dapp
- (void)loadFavoriteDapps {
    WS(weakSelf)
    Model_dapps_favorites_Req *request = [[Model_dapps_favorites_Req alloc] init];
    Model_dapps_favorites_Rsp *response = [[Model_dapps_favorites_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (response.body.count > 9) {
                self.contentView.trackArray = [response.body subarrayWithRange:NSMakeRange(0, 9)];
            }else {
                self.contentView.trackArray = response.body;
            }
        }else {
            [MBProgressHUD jl_showFailureWithText:errorStr toView:weakSelf.view];
        }
    }];
}

/// 最近使用过的dapp
- (void)loadRecentlyDapps {
    WS(weakSelf)
    Model_member_recently_dapps_Req *request = [[Model_member_recently_dapps_Req alloc] init];
    Model_member_recently_dapps_Rsp *response = [[Model_member_recently_dapps_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (response.body.count > 9) {
                self.contentView.trackArray = [response.body subarrayWithRange:NSMakeRange(0, 9)];
            }else {
                self.contentView.trackArray = response.body;
            }
        }else {
            [MBProgressHUD jl_showFailureWithText:errorStr toView:weakSelf.view];
        }
    }];
}

/// 收藏或者取消收藏dapp
- (void)favoriteDapp: (NSString *)dappId isCollect: (BOOL)isCollect {
    WS(weakSelf)
    if (isCollect) {
        Model_dapps_id_favorite_Req *request = [[Model_dapps_id_favorite_Req alloc] init];
        request.ID = dappId;
        Model_dapps_id_favorite_Rsp *response = [[Model_dapps_id_favorite_Rsp alloc] init];
        response.request = request;
        
        [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
        [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
            [[JLLoading sharedLoading] hideLoading];
            if (netIsWork) {
                [MBProgressHUD jl_showSuccessWithText:@"收藏成功" toView:weakSelf.view];
            }else {
                [MBProgressHUD jl_showFailureWithText:errorStr toView:weakSelf.view];
            }
        }];
    }else {
        Model_dapps_id_unfavorite_Req *request = [[Model_dapps_id_unfavorite_Req alloc] init];
        request.ID = dappId;
        Model_dapps_id_unfavorite_Rsp *response = [[Model_dapps_id_unfavorite_Rsp alloc] init];
        response.request = request;
        
        [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
        [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
            [[JLLoading sharedLoading] hideLoading];
            if (netIsWork) {
                [MBProgressHUD jl_showSuccessWithText:@"取消收藏成功" toView:weakSelf.view];
            }else {
                [MBProgressHUD jl_showFailureWithText:errorStr toView:weakSelf.view];
            }
        }];
    }
}

#pragma mark - private methods
//- (JLDappMoreViewControllerType)exchangeTypeFrom: (JLDappContentViewLookMoreType)type {
//    if (type == JLDappContentViewLookMoreTypeCollect) {
//        return JLDappMoreViewControllerTypeCollect;
//    }else if (type == JLDappContentViewLookMoreTypeRecently) {
//        return JLDappMoreViewControllerTypeRecently;
//    }else if (type == JLDappContentViewLookMoreTypeRecommend) {
//        return JLDappMoreViewControllerTypeRecommend;
//    }else {
//        return JLDappMoreViewControllerTypeTransaction;
//    }
//}

#pragma mark - setters and getters
- (JLDappContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLDappContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
    }
    return _contentView;
}

- (NSMutableArray *)chainDappArray {
    if (!_chainDappArray) {
        _chainDappArray = [NSMutableArray array];
    }
    return _chainDappArray;
}

@end
