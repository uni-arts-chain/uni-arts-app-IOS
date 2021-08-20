//
//  JLCashAccountViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLCashAccountViewController.h"
#import "JLCashAccountContentView.h"
#import "JLCashViewController.h"

@interface JLCashAccountViewController () <JLCashAccountContentViewDelegate>

@property (nonatomic, strong) JLCashAccountContentView *contentView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) Model_account_Data *accountData;

@property (nonatomic, strong) NSMutableArray *historiesArray;

@end

@implementation JLCashAccountViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadCashAccount];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"现金账户";
    [self addBackItem];
    
    _page = 1;
    
    [self.view addSubview:self.contentView];
}

#pragma mark - JLCashAccountContentViewDelegate
- (void)withdraw {
    if (![NSString stringIsEmpty:_accountData.balance]) {
        NSDecimalNumber *balanceNumber = [NSDecimalNumber decimalNumberWithString:_accountData.balance];
        if ([balanceNumber isGreaterThanZero]) {
            JLCashViewController *vc = [[JLCashViewController alloc] init];
            vc.amount = balanceNumber.stringValue;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
    }
    [[JLLoading sharedLoading] showMBFailedTipMessage:@"没有可用的余额" hideTime:KToastDismissDelayTimeInterval];
}

#pragma mark - loadDatas
/// 获取现金账户
- (void)loadCashAccount {
    WS(weakSelf)
    Model_accounts_Req *request = [[Model_accounts_Req alloc] init];
    Model_accounts_Rsp *response = [[Model_accounts_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            for (Model_account_Data *model in response.body) {
                if ([model.currency_code isEqualToString:@"rmb"]) {
                    weakSelf.accountData = model;
                    weakSelf.contentView.accountData = weakSelf.accountData;
                    // 获取明细
                    [weakSelf loadCashAccountHistories];
                }
            }
        }
    }];
}

/// 获取现金账户明细
- (void)loadCashAccountHistories {
    WS(weakSelf)
    Model_account_histories_Req *request = [[Model_account_histories_Req alloc] init];
    Model_account_histories_Rsp *response = [[Model_account_histories_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (weakSelf.page == 1) {
                [weakSelf.historiesArray removeAllObjects];
            }
            [weakSelf.historiesArray addObjectsFromArray:response.body];

            weakSelf.contentView.historiesArray = [weakSelf.historiesArray copy];
        }
    }];
}

#pragma mark - setters and getters
- (JLCashAccountContentView *)contentView {
    if (!_contentView) {
        _contentView = [[JLCashAccountContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentView.delegate = self;
    }
    return _contentView;
}

- (NSMutableArray *)historiesArray {
    if (!_historiesArray) {
        _historiesArray = [NSMutableArray array];
    }
    return _historiesArray;
}

@end
