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

@property (nonatomic, assign) JLDappContentViewTrackType currentTrackType;
@property (nonatomic, copy) NSString *currentChainId;
@property (nonatomic, assign) NSInteger page;

@end

@implementation JLDappViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发现";
    _page = 1;
    
    [self.view addSubview:self.contentView];
    
    [self loadFavoriteDapps];
    [self loadChainDatas: _currentChainId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectOrUnCollectDappSuccess) name:LOCALNOTIFICATION_JL_COLLECT_DAPP_SUCCESS object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - JLDappContentViewDelegate
- (void)search {
    JLDappSearchViewController *vc = [[JLDappSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

//- (void)scanCode {
//    WS(weakSelf)
//    JLScanViewController *scanVC = [[JLScanViewController alloc] init];
//    scanVC.scanType = JLScanTypeOther;
//    scanVC.qrCode = true;
//    scanVC.resultBlock = ^(NSString * _Nonnull scanResult) {
//        if (![NSString stringIsEmpty:scanResult] &&
//            [scanResult hasPrefix:@"https"] &&
//            [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scanResult]]) {
//            [weakSelf lookDappWithUrl:scanResult];
//        }else {
//            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
//        }
//    };
//    scanVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:scanVC animated:YES completion:nil];
//}

- (void)refreshDataWithTrackType: (JLDappContentViewTrackType)trackType chainData: (Model_chain_Data *)chainData {
    JLLog(@"刷新信息 trackType: %ld chainTitle: %@", trackType, chainData.title);
    _currentTrackType = trackType;
    if (trackType == JLDappContentViewTrackTypeCollect) {
        [self loadFavoriteDapps];
    }else {
        [self loadRecentlyDapps];
    }
    _currentChainId = chainData.ID;
    _page = 1;
    [self.chainDappArray removeAllObjects];
    [self loadChainDatas: _currentChainId];
}

- (void)lookTrackMoreWithType: (JLDappContentViewLookTrackMoreType)type {
    JLLog(@"查看收藏或最近更多: %ld", type);
    JLDappMoreViewController *vc = [[JLDappMoreViewController alloc] init];
    vc.type = JLDappMoreViewControllerTypeCollectOrRecently;
    vc.collectOrRecentlyIndex = type;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lookChainCategoryMoreWithData: (Model_chain_category_Data *)chainCategoryData {
    JLLog(@"查看链分类更多: %@", chainCategoryData.title);
    JLDappMoreViewController *vc = [[JLDappMoreViewController alloc] init];
    if ([chainCategoryData.title isEqualToString:@"推荐"]) {
        vc.type = JLDappMoreViewControllerTypeRecommend;
        vc.chainId = _currentChainId;
        vc.chainCategoryData = chainCategoryData;
    }else {
        vc.type = JLDappMoreViewControllerTypeChainCategory;
        vc.chainCategoryData = chainCategoryData;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshChainInfoDatasWithChainData: (Model_chain_Data *)chainData {
    JLLog(@"查看链下的信息: %@", chainData.title);
    _currentChainId = chainData.ID;
    _page = 1;
    [self.chainDappArray removeAllObjects];
    [self loadChainDatas: _currentChainId];
}

- (void)loadMoreChainCategoryDatas {
    _page += 1;
    [self loadChainCategories:_currentChainId];
}

- (void)lookTrackWithType: (JLDappContentViewTrackType)type {
    JLLog(@"查看收藏或最近: %ld", type);
    _currentTrackType = type;
    if (type == JLDappContentViewTrackTypeCollect) {
        [self loadFavoriteDapps];
    }else {
        [self loadRecentlyDapps];
    }
}

- (void)lookDappWithDappData: (Model_dapp_Data *)dappData {
    JLLog(@"查看Dapp url: %@", dappData.website_url);
    WS(weakSelf)
    if (![NSString stringIsEmpty:dappData.website_url] &&
        [NSURL URLWithString:dappData.website_url] != nil &&
        [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:dappData.website_url]]) {
        [self postRecentlyDapp:dappData.ID];
        
        [JLEthereumTool.shared lookDappWithNavigationViewController:(JLNavigationViewController *)self.navigationController name:dappData.title imgUrl:dappData.logo.url webUrl:[NSURL URLWithString:dappData.website_url] isCollect: dappData.favorite_by_me collectCompletion:^(BOOL isCollect) {
            JLLog(@"是否收藏: %@", isCollect ? @"收藏":@"取消收藏");
            [weakSelf favoriteDapp:dappData isCollect:isCollect];
        }];
    }else {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"dapp网址不可用" hideTime:KToastDismissDelayTimeInterval];
    }
}

#pragma mark - Notification
- (void)collectOrUnCollectDappSuccess {
    if (_currentTrackType == JLDappContentViewTrackTypeCollect) {
        [self loadFavoriteDapps];
    }
    _page = 1;
    [self.chainDappArray removeAllObjects];
    [self loadChainDatas: _currentChainId];
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
                    weakSelf.currentChainId = requestChainId;
                }
                // 推荐dapp
                [weakSelf loadChainRecommendDapps:requestChainId completion:^{
                    [weakSelf loadChainCategories:requestChainId];
                }];
            }
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

/// 获取推荐的链dapp列表
- (void)loadChainRecommendDapps: (NSString *)chianId completion: (void(^)(void))completion {
    WS(weakSelf)
    Model_chains_id_recommend_dapps_Req *request = [[Model_chains_id_recommend_dapps_Req alloc] init];
    request.ID = chianId;
    request.page = 1;
    request.per_page = kPageSize;
    Model_chains_id_recommend_dapps_Rsp *response = [[Model_chains_id_recommend_dapps_Rsp alloc] init];
    response.request = request;
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        Model_chain_category_Data *chainCategoryData = [[Model_chain_category_Data alloc] init];
        chainCategoryData.title = @"推荐";
        if (netIsWork) {
            if (response.body.count > 9) {
                chainCategoryData.dapps = (NSArray<Model_dapp_Data> *)[response.body subarrayWithRange:NSMakeRange(0, 9)];
            }else {
                chainCategoryData.dapps = response.body;
            }
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
        [weakSelf.chainDappArray addObject:chainCategoryData];
        completion();
    }];
}

/// 加载链分类数据
- (void)loadChainCategories: (NSString *)chianId {
    WS(weakSelf)
    Model_chains_id_categories_Req *request = [[Model_chains_id_categories_Req alloc] init];
    request.ID = chianId;
    request.page = _page;
    request.per_page = kPageSize;
    Model_chains_id_categories_Rsp *response = [[Model_chains_id_categories_Rsp alloc] init];
    response.request = request;

    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            [weakSelf.chainDappArray addObjectsFromArray:response.body];
            // 赋值给视图
            [weakSelf.contentView setChainDappArray:weakSelf.chainDappArray page:weakSelf.page pageSize:kPageSize];
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

/// 获取收藏过的dapp
- (void)loadFavoriteDapps {
    WS(weakSelf)
    Model_dapps_favorites_Req *request = [[Model_dapps_favorites_Req alloc] init];
    request.page = 1;
    request.per_page = kPageSize;
    Model_dapps_favorites_Rsp *response = [[Model_dapps_favorites_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            NSMutableArray *arr = [NSMutableArray array];
            if (response.body.count > 9) {
                for (Model_favorite_Data *data in [response.body subarrayWithRange:NSMakeRange(0, 9)]) {
                    [arr addObject:data.favoritable];
                }
            }else {
                for (Model_favorite_Data *data in response.body) {
                    [arr addObject:data.favoritable];
                }
            }
            weakSelf.contentView.trackArray = [arr copy];
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

/// 最近使用过的dapp
- (void)loadRecentlyDapps {
    WS(weakSelf)
    Model_member_recently_dapps_Req *request = [[Model_member_recently_dapps_Req alloc] init];
    request.page = 1;
    request.per_page = kPageSize;
    Model_member_recently_dapps_Rsp *response = [[Model_member_recently_dapps_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            NSMutableArray *arr = [NSMutableArray array];
            if (response.body.count > 9) {
                for (Model_recently_dapp_Data *data in [response.body subarrayWithRange:NSMakeRange(0, 9)]) {
                    [arr addObject:data.dapp];
                }
            }else {
                for (Model_recently_dapp_Data *data in response.body) {
                    [arr addObject:data.dapp];
                }
            }
            weakSelf.contentView.trackArray = [arr copy];
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

/// 收藏或者取消收藏dapp
- (void)favoriteDapp: (Model_dapp_Data *)dappData isCollect: (BOOL)isCollect {
    if (isCollect) {
        Model_dapps_id_favorite_Req *request = [[Model_dapps_id_favorite_Req alloc] init];
        request.ID = dappData.ID;
        Model_dapps_id_favorite_Rsp *response = [[Model_dapps_id_favorite_Rsp alloc] init];
        response.request = request;
        
        [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
        [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
            [[JLLoading sharedLoading] hideLoading];
            if (netIsWork) {
                [MBProgressHUD jl_showSuccessWithText:@"收藏成功"];
                dappData.favorite_by_me = !dappData.favorite_by_me;
                [[NSNotificationCenter defaultCenter] postNotificationName:LOCALNOTIFICATION_JL_COLLECT_DAPP_SUCCESS object:nil];
            }else {
                [MBProgressHUD jl_showFailureWithText:errorStr];
            }
        }];
    }else {
        Model_dapps_id_unfavorite_Req *request = [[Model_dapps_id_unfavorite_Req alloc] init];
        request.ID = dappData.ID;
        Model_dapps_id_unfavorite_Rsp *response = [[Model_dapps_id_unfavorite_Rsp alloc] init];
        response.request = request;
        
        [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
        [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
            [[JLLoading sharedLoading] hideLoading];
            if (netIsWork) {
                [MBProgressHUD jl_showSuccessWithText:@"取消收藏成功"];
                dappData.favorite_by_me = !dappData.favorite_by_me;
                [[NSNotificationCenter defaultCenter] postNotificationName:LOCALNOTIFICATION_JL_COLLECT_DAPP_SUCCESS object:nil];
            }else {
                [MBProgressHUD jl_showFailureWithText:errorStr];
            }
        }];
    }
}

/// 上传使用的dapp痕迹
- (void)postRecentlyDapp: (NSString *)dappId {
    Model_member_recently_dapp_Req *request = [[Model_member_recently_dapp_Req alloc] init];
    request.dapp_id = dappId;
    Model_member_recently_dapp_Rsp *response = [[Model_member_recently_dapp_Rsp alloc] init];
    
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            JLLog(@"最近使用dapp id: %@ 上传痕迹成功", dappId);
        }else {
            JLLog(@"最近使用dapp id: %@ 上传痕迹失败: %@", dappId, errorStr);
        }
    }];
}

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
