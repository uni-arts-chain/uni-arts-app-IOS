//
//  JLDappMoreContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/27.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappMoreContentView.h"
#import "JLDappMoreCell.h"
#import "JLNormalEmptyView.h"

@interface JLDappMoreContentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JLNormalEmptyView *emptyDataView;

@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation JLDappMoreContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    WS(weakSelf)
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    _tableView.backgroundColor = JL_color_white_ffffff;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:JLDappMoreCell.class forCellReuseIdentifier:NSStringFromClass(JLDappMoreCell.class)];
    [self addSubview:_tableView];
    
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
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLDappMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JLDappMoreCell.class) forIndexPath:indexPath];
    if (!cell) {
        cell = [[JLDappMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(JLDappMoreCell.class)];
    }
    cell.dappData = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_dataArray && _dataArray.count == 0) {
        JLNormalEmptyView *footerView = [[JLNormalEmptyView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, self.frameHeight)];
        return footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_dataArray && _dataArray.count == 0) {
        return self.frameHeight;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(lookDappWithDappData:)]) {
        [_delegate lookDappWithDappData:_dataArray[indexPath.row]];
    }
}

#pragma mark - public methods
- (void)setDataArray:(NSArray *)dataArray page: (NSInteger)page pageSize: (NSInteger)pageSize {
    _dataArray = dataArray;
    
    if (page <= 1) {
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        if (_dataArray.count < page * pageSize) {
            [(JLRefreshFooter *)_tableView.mj_footer endWithNoMoreDataNotice];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    }else {
        if (_dataArray.count < page * pageSize) {
            [(JLRefreshFooter *)_tableView.mj_footer endWithNoMoreDataNotice];
        }else {
            if ([_tableView.mj_footer isRefreshing]) {
                [_tableView.mj_footer endRefreshing];
            }
        }
    }
    
    [_tableView reloadData];
}

@end
