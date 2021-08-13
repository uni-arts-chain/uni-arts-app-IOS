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

@interface JLCashAccountContentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

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
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 66;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
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
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 117;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - setters and getters
- (void)setAccountData:(Model_account_Data *)accountData {
    _accountData = accountData;
    
    [_tableView reloadData];
}

- (void)setHistoriesArray:(NSArray *)historiesArray {
    _historiesArray = historiesArray;
    
    [_tableView reloadData];
}

@end
