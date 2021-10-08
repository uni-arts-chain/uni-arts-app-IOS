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

- (void)lookDappWithUrl: (NSString *)url {
    JLLog(@"查看dapp url: %@", url);
}

#pragma mark - loadDatas
- (void)loadHotDatas {
    self.contentView.hotSearchArray = @[];
}

- (void)startSearch: (NSString *)searchContent {
    WS(weakSelf)
    Model_dapps_search_Req *request = [[Model_dapps_search_Req alloc] init];
    request.q = searchContent;
    Model_dapps_search_Rsp *response = [[Model_dapps_search_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            self.contentView.searchResultArray = response.body;
        }else {
            [MBProgressHUD jl_showFailureWithText:errorStr toView:weakSelf.view];
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
