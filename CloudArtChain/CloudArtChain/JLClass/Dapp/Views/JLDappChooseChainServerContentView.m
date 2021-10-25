//
//  JLDappChooseChainServerContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/10/25.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappChooseChainServerContentView.h"
#import "JLDappChooseChainServerCell.h"

@interface JLDappChooseChainServerContentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) Model_eth_rpc_server_data *rpcServerData;

@end

@implementation JLDappChooseChainServerContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _rpcServerData = [JLEthRPCServerTool ethRPCServer];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    _tableView.backgroundColor = JL_color_white_ffffff;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:JLDappChooseChainServerCell.class forCellReuseIdentifier:NSStringFromClass(JLDappChooseChainServerCell.class)];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((Model_chain_server_Data *)_dataArray[section]).chain_networks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Model_eth_rpc_server_data *data = ((Model_chain_server_Data *)_dataArray[indexPath.section]).chain_networks[indexPath.row];
    JLDappChooseChainServerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JLDappChooseChainServerCell.class) forIndexPath:indexPath];
    if (!cell) {
        cell = [[JLDappChooseChainServerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(JLDappChooseChainServerCell.class)];
    }
    if (_rpcServerData && _rpcServerData.chain_id == data.chain_id) {
        cell.isChoosed = YES;
    }else {
        cell.isChoosed = NO;
    }
    cell.rpcServerData = data;
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, 20)];
    label.text = ((Model_chain_server_Data *)_dataArray[section]).title;
    label.textColor = JL_color_gray_999999;
    label.font = kFontPingFangSCRegular(13);
    label.jl_contentInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(chooseEthRPCServerData:)]) {
        [_delegate chooseEthRPCServerData:((Model_chain_server_Data *)_dataArray[indexPath.section]).chain_networks[indexPath.row]];
    }
}

#pragma mark - setters and getters
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [_tableView reloadData];
}

@end
