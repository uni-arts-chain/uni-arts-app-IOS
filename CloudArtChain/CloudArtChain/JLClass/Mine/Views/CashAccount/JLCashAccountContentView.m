//
//  JLCashAccountContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLCashAccountContentView.h"
#import "JLCashAccountHeaderView.h"
#import "JLCashAccountCell.h"
#import "JLNormalEmptyView.h"

@interface JLCashAccountContentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JLNormalEmptyView *emptyView;

@property (nonatomic, copy) NSArray *historiesArray;

@end

@implementation JLCashAccountContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = JL_color_white_ffffff;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 66;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    WS(weakSelf)
    _tableView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshDatas)]) {
            [weakSelf.delegate refreshDatas];
        }
    }];
    _tableView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(loadMoreDatas)]) {
            [weakSelf.delegate loadMoreDatas];
        }
    }];
    
    [_tableView registerClass:JLCashAccountCell.class forCellReuseIdentifier:@"cell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _historiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLCashAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[JLCashAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accountHistoryData = _historiesArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WS(weakSelf)
    JLCashAccountHeaderView *headerView = [[JLCashAccountHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, 117)];
    if (_accountData) {
        headerView.accountData = _accountData;
    }
    headerView.withdrawBlock = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(withdraw)]) {
            [weakSelf.delegate withdraw];
        }
    };
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.historiesArray && self.historiesArray.count == 0) {
        return self.emptyView;
    }else {
        return [[UIView alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 117;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.historiesArray && self.historiesArray.count == 0) {
        return self.frameHeight - 117;
    }else {
        return KTouch_Responder_Height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - setters and getters
- (void)setAccountData:(Model_account_Data *)accountData {
    _accountData = accountData;
    
    [_tableView reloadData];
}

- (void)setHistoriesArray:(NSArray *)historiesArray page: (NSInteger)page pageSize: (NSInteger)pageSize {
    _historiesArray = historiesArray;
    
    if (page <= 1) {
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        if (_historiesArray.count < page * pageSize) {
            [(JLRefreshFooter *)_tableView.mj_footer endWithNoMoreDataNotice];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    }else {
        if (_historiesArray.count < page * pageSize) {
            [(JLRefreshFooter *)_tableView.mj_footer endWithNoMoreDataNotice];
        }else {
            if ([_tableView.mj_footer isRefreshing]) {
                [_tableView.mj_footer endRefreshing];
            }
        }
    }
    
    [_tableView reloadData];
}

- (JLNormalEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JLNormalEmptyView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, self.frameHeight - 117)];
    }
    return _emptyView;
}

@end
