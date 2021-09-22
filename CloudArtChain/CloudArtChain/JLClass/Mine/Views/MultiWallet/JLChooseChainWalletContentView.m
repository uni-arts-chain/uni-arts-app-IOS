//
//  JLChooseChainWalletContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLChooseChainWalletContentView.h"
#import "JLChooseChainWalletCell.h"

@interface JLChooseChainWalletContentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *nameArray;
@property (nonatomic, copy) NSArray *symbolArray;
@property (nonatomic, copy) NSArray *imageNamedArray;

@end

@implementation JLChooseChainWalletContentView

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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:JLChooseChainWalletCell.class forCellReuseIdentifier:NSStringFromClass(JLChooseChainWalletCell.class)];
    [self addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLChooseChainWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JLChooseChainWalletCell.class) forIndexPath:indexPath];
    if (!cell) {
        cell = [[JLChooseChainWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(JLChooseChainWalletCell.class)];
    }
    [cell setSymbol:self.symbolArray[indexPath.row] name:self.nameArray[indexPath.row] imageNamed:self.imageNamedArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(chooseChainSymbol:chainName:imageNamed:)]) {
        [_delegate chooseChainSymbol:self.symbolArray[indexPath.row] chainName:self.nameArray[indexPath.row] imageNamed:self.imageNamedArray[indexPath.row]];
    }
}

#pragma mark - setters and getters
- (NSArray *)symbolArray {
    if (!_symbolArray) {
        _symbolArray = @[JLMultiChainSymbolUART,
                         JLMultiChainSymbolETH];
    }
    return _symbolArray;
}

- (NSArray *)nameArray {
    if (!_nameArray) {
        _nameArray = @[JLMultiChainNameUniArts,
                       JLMultiChainNameEthereum];
    }
    return _nameArray;
}

- (NSArray *)imageNamedArray {
    if (!_imageNamedArray) {
        _imageNamedArray = @[@"icon_mine_multi_wallet_uart",
                             @"icon_mine_multi_wallet_eth"];
    }
    return _imageNamedArray;
}

@end
