//
//  JLDappSearchViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappSearchViewController.h"
#import "JLDappSearchContentView.h"

@interface JLDappSearchViewController ()<JLDappSearchContentViewDelegate>

@property (nonatomic, strong) JLDappSearchContentView *contentView;

@end

@implementation JLDappSearchViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搜索";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    
    [self.view addSubview:self.contentView];
    
    [self loadHotDatas];
}

#pragma mark - JLDappSearchContentViewDelegate
- (void)searchWithSearchText: (NSString *)searchText {
    JLLog(@"searchText: %@", searchText);
    
    [self startSearch:searchText];
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:NO];
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
- (void)loadHotDatas {
    WS(weakSelf)
    Model_dapps_hot_search_dapps_Req *request = [[Model_dapps_hot_search_dapps_Req alloc] init];
    Model_dapps_hot_search_dapps_Rsp *response = [[Model_dapps_hot_search_dapps_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.contentView.hotSearchArray = response.body;
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

- (void)startSearch: (NSString *)searchContent {
    WS(weakSelf)
    Model_dapps_search_Req *request = [[Model_dapps_search_Req alloc] init];
    request.q = searchContent;
    Model_dapps_search_Rsp *response = [[Model_dapps_search_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.contentView.searchResultArray = response.body;
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
- (JLDappSearchContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLDappSearchContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
    }
    return _contentView;
}

@end
