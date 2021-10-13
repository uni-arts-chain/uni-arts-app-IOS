//
//  JLDappMoreViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/27.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappMoreViewController.h"
#import "JLDappMoreContentView.h"

@interface JLDappMoreViewController ()<JLDappMoreContentViewDelegate>

@property (nonatomic, strong) JLDappMoreContentView *contentView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JLDappMoreViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self getNavigationTitle];
    [self addBackItem];
    
    _page = 1;
    
    [self.view addSubview:self.contentView];
    
    [self loadDatas];
}

#pragma mark - JLDappMoreContentViewDelegate
- (void)refreshDatas {
    _page = 1;
    
    [self loadDatas];
}

- (void)loadMoreDatas {
    _page += 1;
    
    [self loadDatas];
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

#pragma mark - loadDatas
- (void)loadDatas {
    if (_type == JLDappMoreViewControllerTypeRecommend) {
        [self loadChainRecommendDapps:_chainId];
    }else if (_type == JLDappMoreViewControllerTypeChainCategory) {
        [self loadChainCategoryDapps];
    }else {
        if (_collectOrRecentlyIndex == 0) {
            [self loadFavoriteDapps];
        }else if (_collectOrRecentlyIndex == 1) {
            [self loadRecentlyDapps];
        }
    }
}

/// 获取推荐的链dapp列表
- (void)loadChainRecommendDapps: (NSString *)chianId {
    WS(weakSelf)
    Model_chains_id_recommend_dapps_Req *request = [[Model_chains_id_recommend_dapps_Req alloc] init];
    request.ID = chianId;
    request.page = _page;
    request.per_page = kPageSize;
    Model_chains_id_recommend_dapps_Rsp *response = [[Model_chains_id_recommend_dapps_Rsp alloc] init];
    response.request = request;
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (weakSelf.page == 1) {
                weakSelf.dataArray = [NSMutableArray arrayWithArray:response.body];
            }else {
                [weakSelf.dataArray addObjectsFromArray:response.body];
            }
            [weakSelf.contentView setDataArray:weakSelf.dataArray page:weakSelf.page pageSize:kPageSize];
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

/// 链分类下的dapps
- (void)loadChainCategoryDapps {
    WS(weakSelf)
    Model_dapps_category_dapps_Req *request = [[Model_dapps_category_dapps_Req alloc] init];
    request.chain_category_id = _chainCategoryData.ID;
    request.page = _page;
    request.per_page = kPageSize;
    Model_dapps_category_dapps_Rsp *response = [[Model_dapps_category_dapps_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (weakSelf.page == 1) {
                weakSelf.dataArray = [NSMutableArray arrayWithArray:response.body];
            }else {
                [weakSelf.dataArray addObjectsFromArray:response.body];
            }
            [self.contentView setDataArray:weakSelf.dataArray page:weakSelf.page pageSize:kPageSize];
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

/// 获取收藏过的dapp
- (void)loadFavoriteDapps {
    WS(weakSelf)
    Model_dapps_favorites_Req *request = [[Model_dapps_favorites_Req alloc] init];
    request.page = _page;
    request.per_page = kPageSize;
    Model_dapps_favorites_Rsp *response = [[Model_dapps_favorites_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            NSMutableArray *arr = [NSMutableArray array];
            for (Model_favorite_Data *data in response.body) {
                if (data.favoritable) {
                    [arr addObject:data.favoritable];
                }
            }
            if (weakSelf.page == 1) {
                weakSelf.dataArray = [arr copy];
            }else {
                [weakSelf.dataArray addObjectsFromArray:[arr copy]];
            }
            [self.contentView setDataArray:weakSelf.dataArray page:weakSelf.page pageSize:kPageSize];
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

/// 最近使用过的dapp
- (void)loadRecentlyDapps {
    WS(weakSelf)
    Model_member_recently_dapps_Req *request = [[Model_member_recently_dapps_Req alloc] init];
    request.page = _page;
    request.per_page = kPageSize;
    Model_member_recently_dapps_Rsp *response = [[Model_member_recently_dapps_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            NSMutableArray *arr = [NSMutableArray array];
            for (Model_recently_dapp_Data *data in response.body) {
                if (data.dapp) {
                    [arr addObject:data.dapp];
                }
            }
            if (weakSelf.page == 1) {
                weakSelf.dataArray = [arr copy];
            }else {
                [weakSelf.dataArray addObjectsFromArray:[arr copy]];
            }
            [weakSelf.contentView setDataArray:weakSelf.dataArray page:weakSelf.page pageSize:kPageSize];
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

#pragma mark - private methods
- (NSString *)getNavigationTitle {
    if (_type == JLDappMoreViewControllerTypeRecommend ||
        _type == JLDappMoreViewControllerTypeChainCategory) {
        if (![NSString stringIsEmpty:_chainCategoryData.title]) {
            return _chainCategoryData.title;
        }
    }else {
        if (_collectOrRecentlyIndex == 0) {
            return @"收藏";
        }else if (_collectOrRecentlyIndex == 1) {
            return @"最近";
        }
    }
    return @"更多";
}

#pragma mark - setters and getters
- (JLDappMoreContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLDappMoreContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
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
