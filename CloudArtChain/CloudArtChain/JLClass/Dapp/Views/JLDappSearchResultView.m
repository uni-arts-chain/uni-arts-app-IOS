//
//  JLDappSearchResultView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappSearchResultView.h"
#import "JLDappMoreCell.h"
#import "JLNormalEmptyView.h"
#import "JLDappSearchActivityIndicatorView.h"

@interface JLDappSearchResultView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JLDappSearchActivityIndicatorView *indicatorView;

@end

@implementation JLDappSearchResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"搜索结果";
    _titleLabel.textColor = JL_color_gray_101010;
    _titleLabel.font = kFontPingFangSCSCSemibold(14);
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self);
        make.top.equalTo(self);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    _tableView.backgroundColor = JL_color_white_ffffff;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:JLDappMoreCell.class forCellReuseIdentifier:NSStringFromClass(JLDappMoreCell.class)];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(self);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearching) {
        return 0;
    }
    return _searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLDappMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JLDappMoreCell.class) forIndexPath:indexPath];
    if (!cell) {
        cell = [[JLDappMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(JLDappMoreCell.class)];
    }
    cell.dappData = _searchResultArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_isSearching) {
        return self.indicatorView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_searchResultArray && _searchResultArray.count == 0) {
        JLNormalEmptyView *emptyDataView = [[JLNormalEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
        return emptyDataView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_isSearching) {
        return 40;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_searchResultArray && _searchResultArray.count == 0) {
        return 300;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(didSelect:)]) {
        [_delegate didSelect:_searchResultArray[indexPath.row]];
    }
}

#pragma mark - setters and getters
- (JLDappSearchActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[JLDappSearchActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    }
    return _indicatorView;
}

- (void)setSearchResultArray:(NSArray *)searchResultArray {
    _searchResultArray = searchResultArray;
    
    [_tableView reloadData];
}

- (void)setIsSearching:(BOOL)isSearching {
    _isSearching = isSearching;
    
    if (_isSearching) {
        [self.indicatorView startAnimating];
    }else {
        [self.indicatorView stopAnimating];
    }
    
    [_tableView reloadData];
}

@end
