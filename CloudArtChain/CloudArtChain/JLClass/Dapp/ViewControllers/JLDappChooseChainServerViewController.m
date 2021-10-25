//
//  JLDappChooseChainServerViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/10/25.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappChooseChainServerViewController.h"
#import "JLDappChooseChainServerContentView.h"

@interface JLDappChooseChainServerViewController ()<JLDappChooseChainServerContentViewDelegate>

@property (nonatomic, strong) JLDappChooseChainServerContentView *contentView;

@end

@implementation JLDappChooseChainServerViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"网络切换";
    [self addRightItemImage:@"icon_dapp_browser_face_close"];
    
    [self.view addSubview:self.contentView];
    
    [self loadChianRPCServerDatas];
}

- (void)rightItemClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - JLDappChooseChainServerContentViewDelegate
- (void)chooseEthRPCServerData:(Model_eth_rpc_server_data *)ethRPCServerData {
    [JLEthRPCServerTool saveEthRPCServer:ethRPCServerData];
    [JLEthereumTool.shared setRPCServerWithName:ethRPCServerData.name chainID:ethRPCServerData.chain_id rpcStr:ethRPCServerData.rpc_url];
    if (_chooseBlock) {
        _chooseBlock(ethRPCServerData);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - loadDatas
/// 获取链服务列表
- (void)loadChianRPCServerDatas {
    WS(weakSelf)
    Model_chain_id_networks_Req *request = [[Model_chain_id_networks_Req alloc] init];
    request.ID = @"1";
    Model_chain_id_networks_Rsp *response = [[Model_chain_id_networks_Rsp alloc] init];
    response.request = request;
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            weakSelf.contentView.dataArray = response.body;
        }else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
        }
    }];
}

#pragma mark - setters and getters
- (JLDappChooseChainServerContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLDappChooseChainServerContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
    }
    return _contentView;
}

@end
