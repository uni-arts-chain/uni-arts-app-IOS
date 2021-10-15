//
//  JLDappContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/26.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappContentView.h"
#import "JLDappSearchHeaderView.h"
#import "JLDappTitleView.h"
#import "JLDappTrackCell.h"
#import "JLDappCell.h"

@interface JLDappContentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JLDappSearchHeaderView *searchHeaderView;

@property (nonatomic, copy) NSArray *chainDappArray;
@property (nonatomic, copy) NSArray *chainTitleArray;
@property (nonatomic, assign) JLDappContentViewTrackType selectTrackType;
@property (nonatomic, assign) NSInteger selectChainIndex;

@end

@implementation JLDappContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectTrackType = JLDappContentViewTrackTypeCollect;
        _selectChainIndex = 0;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    WS(weakSelf)
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, self.frameHeight - KTabBar_Height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = JL_color_white_ffffff;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    [_tableView registerClass:JLDappTrackCell.class forCellReuseIdentifier:NSStringFromClass(JLDappTrackCell.class)];
    [_tableView registerClass:JLDappCell.class forCellReuseIdentifier:NSStringFromClass(JLDappCell.class)];
    _tableView.tableHeaderView = self.searchHeaderView;
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-(KTabBar_Height));
    }];
    
    _tableView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshDataWithTrackType:chainData:)]) {
            [weakSelf.delegate refreshDataWithTrackType:weakSelf.selectTrackType chainData:weakSelf.chainArray[weakSelf.selectChainIndex]];
        }
    }];
    _tableView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(loadMoreChainCategoryDatas)]) {
            [weakSelf.delegate loadMoreChainCategoryDatas];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return _chainDappArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    if (indexPath.section == 0) {
        JLDappTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JLDappTrackCell.class) forIndexPath:indexPath];
        if (!cell) {
            cell = [[JLDappTrackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(JLDappTrackCell.class)];
        }
        cell.lookDappBlock = ^(Model_dapp_Data * _Nonnull dappData) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lookDappWithDappData:)]) {
                [weakSelf.delegate lookDappWithDappData:dappData];
            }
        };
        cell.trackArray = _trackArray;
        return cell;
    }else {
        JLDappCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JLDappCell.class) forIndexPath:indexPath];
        if (!cell) {
            cell = [[JLDappCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(JLDappCell.class)];
        }
        cell.moreBlock = ^(Model_chain_category_Data * _Nonnull dappData) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lookChainCategoryMoreWithData:)]) {
                [weakSelf.delegate lookChainCategoryMoreWithData:dappData];
            }
        };
        cell.lookDappBlock = ^(Model_dapp_Data * _Nonnull dappData) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lookDappWithDappData:)]) {
                [weakSelf.delegate lookDappWithDappData:dappData];
            }
        };
        cell.chainCategoryData = _chainDappArray[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WS(weakSelf)
    JLDappTitleView *headerView = [[JLDappTitleView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, 52)];
    headerView.didSelectBlock = ^(NSInteger index) {
        if (section == 0) {
            weakSelf.selectTrackType = index;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lookTrackWithType:)]) {
                [weakSelf.delegate lookTrackWithType:weakSelf.selectTrackType];
            }
        }else {
            weakSelf.selectChainIndex = index;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshChainInfoDatasWithChainData:)]) {
                [weakSelf.delegate refreshChainInfoDatasWithChainData:weakSelf.chainArray[weakSelf.selectChainIndex]];
            }
        }
    };
    headerView.moreBlock = ^(NSInteger index) {
        if (section == 0) {
            JLDappContentViewLookTrackMoreType type = JLDappContentViewLookTrackMoreTypeCollect;
            if (index == 1) {
                type = JLDappContentViewLookTrackMoreTypeRecently;
            }
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lookTrackMoreWithType:)]) {
                [weakSelf.delegate lookTrackMoreWithType:type];
            }
        }
    };
    if (section == 0) {
        [headerView setTitleArray:@[@"收藏",@"最近"] selectIndex:_selectTrackType style:JLDappTitleViewStyleScrollDefault];
    }else {
        if (_chainTitleArray.count) {
            [headerView setTitleArray:_chainTitleArray selectIndex:_selectChainIndex style:JLDappTitleViewStyleScrollNoMore];
        }
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 88;
    }
    
    Model_chain_category_Data *data = _chainDappArray[indexPath.row];
    if (data.dapps.count < 3) {
        CGFloat height = MAX(64, 64 *data.dapps.count);
        return 44 + height;
    }else {
        return 44 + 192;
    }
}

#pragma mark - setters and getters
- (JLDappSearchHeaderView *)searchHeaderView {
    if (!_searchHeaderView) {
        WS(weakSelf)
        _searchHeaderView = [[JLDappSearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        _searchHeaderView.searchBlock = ^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(search)]) {
                [weakSelf.delegate search];
            }
        };
        _searchHeaderView.scanBlock = ^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(scanCode)]) {
                [weakSelf.delegate scanCode];
            }
        };
    }
    return _searchHeaderView;
}

- (void)setTrackArray:(NSArray *)trackArray {
    _trackArray = trackArray;
    
    [_tableView reloadData];
}

- (void)setChainArray:(NSArray *)chainArray {
    _chainArray = chainArray;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (Model_chain_Data *data in _chainArray) {
        [arr addObject:data.title];
    }
    _chainTitleArray = [arr copy];
    
    [_tableView reloadData];
}

- (void)setChainDappArray: (NSArray *)chainDappArray page: (NSInteger)page pageSize: (NSInteger)pageSize {
    _chainDappArray = chainDappArray;
    
    if (page <= 1) {
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        if (_chainDappArray.count < page * pageSize) {
            [(JLRefreshFooter *)_tableView.mj_footer endWithNoMoreDataNotice];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
    }else {
        if (_chainDappArray.count < page * pageSize) {
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
