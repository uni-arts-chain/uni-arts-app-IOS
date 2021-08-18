//
//  JLAuctionListContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionListContentView.h"
#import "JLAuctionListCell.h"
#import "JLNormalEmptyView.h"

@interface JLAuctionListContentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JLNormalEmptyView *emptyView;

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JLAuctionListContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = JL_color_white_ffffff;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(11, 0, 0, 0);
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    WS(weakSelf)
    _tableView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshData)]) {
            [weakSelf.delegate refreshData];
        }
    }];
    _tableView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(loadMoreData)]) {
            [weakSelf.delegate loadMoreData];
        }
    }];
    
    [_tableView registerClass:JLAuctionListCell.class forCellReuseIdentifier:@"JLAuctionListCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLAuctionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLAuctionListCell" forIndexPath:indexPath];
    [cell setAuctionsData:self.dataArray[indexPath.row] type:_type];
    WS(weakSelf)
    cell.payBlock = ^(NSString * _Nonnull auctionsId) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(payAuction:)]) {
            [weakSelf.delegate payAuction:auctionsId];
        }
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return self.emptyView;
    }else {
        return [[UIView alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return self.frameHeight;
    }else {
        return KTouch_Responder_Height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == JLAuctionHistoryTypeWins) {
        return 198;
    }
    return 168;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(lookAuctionDetail:)]) {
        [self.delegate lookAuctionDetail:((Model_auctions_Data *)self.dataArray[indexPath.row]).ID];
    }
}

#pragma mark - private methods
- (void)createTimer {
    /// 是否有拍卖作品 有启动定时器
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    WS(weakSelf)
    self.timer = [NSTimer jl_scheduledTimerWithTimeInterval:1.0 block:^{
        [weakSelf handleTimer];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)handleTimer {
    for (int i = 0; i < self.dataArray.count; i++) {
        Model_auctions_Data *model = self.dataArray[i];
        model.server_timestamp = @(model.server_timestamp.integerValue + 1).stringValue;
    }
    [_tableView reloadData];
}

#pragma mark - public methods
- (void)setDataArray:(NSArray *)dataArray page:(NSInteger)page pageSize:(NSInteger)pageSize {
    _dataArray = dataArray;
    
    if (page <= 1) {
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        if (_dataArray.count < page * pageSize) {
            [(JLRefreshFooter *)_tableView.mj_footer endWithNoMoreDataNotice];
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
    
    if (_dataArray.count && _type == JLAuctionHistoryTypeWins) {
        [self createTimer];
    }
    
    [_tableView reloadData];
}

#pragma mark - setters and getters
- (JLNormalEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JLNormalEmptyView alloc]initWithFrame:self.bounds];
    }
    return _emptyView;
}

@end
