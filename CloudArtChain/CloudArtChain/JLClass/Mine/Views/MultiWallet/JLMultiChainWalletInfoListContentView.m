//
//  JLMultiChainWalletInfoListContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletInfoListContentView.h"
#import "JLMultiChainWalletInfoListCell.h"
#import "JLNormalEmptyView.h"

@interface JLMultiChainWalletInfoListContentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSArray *nftArray;

@end

@implementation JLMultiChainWalletInfoListContentView

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
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [_tableView registerClass:JLMultiChainWalletInfoListCell.class forCellReuseIdentifier:NSStringFromClass(JLMultiChainWalletInfoListCell.class)];
    [self addSubview:_tableView];
    
    WS(weakSelf)
    _tableView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refresh)]) {
            [weakSelf.delegate refresh];
        }
    }];
    _tableView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(loadMore)]) {
            [weakSelf.delegate loadMore];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_style == JLMultiChainWalletInfoListContentViewStyleMainToken ||
        _style == JLMultiChainWalletInfoListContentViewStyleToken) {
        return 1;
    }
    return self.nftArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLMultiChainWalletInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JLMultiChainWalletInfoListCell.class) forIndexPath:indexPath];
    if (!cell) {
        cell = [[JLMultiChainWalletInfoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(JLMultiChainWalletInfoListCell.class)];
    }
    cell.style = _style;
    if (_style == JLMultiChainWalletInfoListContentViewStyleMainToken ||
        _style == JLMultiChainWalletInfoListContentViewStyleToken) {
        cell.walletInfo = _walletInfo;
        cell.amount = _amount;
    }else {
        cell.nftData = self.nftArray[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ((_style == JLMultiChainWalletInfoListContentViewStyleMainNFT ||
         _style == JLMultiChainWalletInfoListContentViewStyleTokenNFT) &&
         self.nftArray &&
         self.nftArray.count == 0) {
        JLNormalEmptyView *emptyView = [[JLNormalEmptyView alloc] initWithFrame:self.bounds];
        return emptyView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ((_style == JLMultiChainWalletInfoListContentViewStyleMainNFT ||
        _style == JLMultiChainWalletInfoListContentViewStyleTokenNFT) &&
        self.nftArray &&
        self.nftArray.count == 0) {
        return self.frameHeight;
    }
    return KTouch_Responder_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

#pragma mark - public methods
- (void)setDataArray: (NSArray *)dataArray page: (NSInteger)page pageSize: (NSInteger) pageSize {
    self.page = page;
    self.pageSize = pageSize;
    self.nftArray = dataArray;
}

#pragma mark - setters and getters
- (void)setStyle:(JLMultiChainWalletInfoListContentViewStyle)style {
    _style = style;
    
    if (_style == JLMultiChainWalletInfoListContentViewStyleMainToken ||
        _style == JLMultiChainWalletInfoListContentViewStyleToken) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)setWalletInfo:(JLMultiWalletInfo *)walletInfo {
    _walletInfo = walletInfo;
    
    [_tableView.mj_header endRefreshing];
    
    [_tableView reloadData];
}
- (void)setAmount:(NSString *)amount {
    _amount = amount;
    
    [_tableView reloadData];
}

- (void)setNftArray:(NSArray *)nftArray {
    _nftArray = nftArray;
    
    [_tableView.mj_header endRefreshing];
    
    if (_page * _pageSize > _nftArray.count) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [_tableView.mj_footer endRefreshing];
    }
    
    [_tableView reloadData];
}

@end
