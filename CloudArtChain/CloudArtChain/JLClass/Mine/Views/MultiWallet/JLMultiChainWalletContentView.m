//
//  JLMultiChainWalletContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletContentView.h"
#import "JLMultiChainWalletCell.h"

@interface JLMultiChainWalletContentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *importBtn;

@property (nonatomic, assign) JLMultiChainWalletSymbol symbol;
@property (nonatomic, copy) NSArray *walletInfoArray;

@end

@implementation JLMultiChainWalletContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, self.frameHeight - 84 - KTouch_Responder_Height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = JL_color_white_ffffff;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [_tableView registerClass:JLMultiChainWalletCell.class forCellReuseIdentifier:NSStringFromClass(JLMultiChainWalletCell.class)];
    [self addSubview:_tableView];
    
    _importBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _importBtn.frame = CGRectMake(15, self.frameHeight - 62 - KTouch_Responder_Height, self.frameWidth - 30, 40);
    _importBtn.backgroundColor = JL_color_white_ffffff;
    _importBtn.layer.cornerRadius = 5;
    _importBtn.layer.borderWidth = 1;
    _importBtn.layer.borderColor = JL_color_gray_101010.CGColor;
    _importBtn.layer.masksToBounds = YES;
    [_importBtn setTitle:@"导入钱包" forState:UIControlStateNormal];
    [_importBtn setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
    _importBtn.titleLabel.font = kFontPingFangSCRegular(15);
    [_importBtn setImage:[[UIImage imageNamed:@"icon_mine_multi_wallet_import"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_importBtn setImagePosition:LXMImagePositionLeft spacing:10];
    [_importBtn addTarget:self action:@selector(importBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_importBtn];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.walletInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLMultiChainWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JLMultiChainWalletCell.class) forIndexPath:indexPath];
    if (!cell) {
        cell = [[JLMultiChainWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(JLMultiChainWalletCell.class)];
    }
    if (_symbol == JLMultiChainWalletSymbolETH) {
        JLEthereumWalletInfo *walletInfo = self.walletInfoArray[indexPath.row];
        [cell setWalletName:walletInfo.name == nil ? @"钱包" : walletInfo.name address:walletInfo.address];
    }
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
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(lookWalletWithIndex:)]) {
        [_delegate lookWalletWithIndex:indexPath.row];
    }
}

#pragma mark - event response
- (void)importBtnClick: (UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(importWallet)]) {
        [_delegate importWallet];
    }
}

#pragma mark - public methods
- (void)setMultiWalletSymbol: (JLMultiChainWalletSymbol)symbol walletInfoArray: (NSArray *)walletInfoArray {
    _symbol = symbol;
    _walletInfoArray = walletInfoArray;
    
    [_tableView reloadData];
}

@end
