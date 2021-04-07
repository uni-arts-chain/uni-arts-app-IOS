//
//  JLAuctionOfferRecordView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLAuctionOfferRecordView.h"
#import "JLAuctionOfferRecordCell.h"
#import "UIButton+AxcButtonContentLayout.h"

@interface JLAuctionOfferRecordView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *recordListButton;

// 出价记录
@property (nonatomic, strong) NSArray *bidList;
@property (nonatomic, strong) NSDate *blockDate;
@property (nonatomic, assign) UInt32 blockNumber;
@end

@implementation JLAuctionOfferRecordView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.headerView];
    [self addSubview:self.tableView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(45.0f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        
        UILabel *titleLabel = [JLUIFactory labelInitText:@"出价记录" font:kFontPingFangSCSCSemibold(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        [_headerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16.0f);
            make.top.mas_equalTo(9.0f);
            make.bottom.equalTo(_headerView);
        }];
        
        self.recordListButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.recordListButton setTitle:@"0条记录" forState:UIControlStateNormal];
        [self.recordListButton setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
        self.recordListButton.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [self.recordListButton setImage:[UIImage imageNamed:@"icon_auction_sanjiaoxing"] forState:UIControlStateNormal];
        self.recordListButton.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleCenterImageRight;
        self.recordListButton.axcUI_padding = 10.0f;
        [self.recordListButton addTarget:self action:@selector(recordListButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:self.recordListButton];
        [self.recordListButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16.0f - 10.0f);
            make.centerY.equalTo(titleLabel.mas_centerY);
        }];
    }
    return _headerView;
}

- (void)recordListButtonClick {
    if (self.recordListBlock) {
        self.recordListBlock(self.bidList, self.blockDate, self.blockNumber);
    }
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JL_color_white_ffffff;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JLAuctionOfferRecordCell class] forCellReuseIdentifier:@"JLAuctionOfferRecordCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.bidList.count > 3) {
        return 3;
    }
    return self.bidList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLAuctionOfferRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLAuctionOfferRecordCell" forIndexPath:indexPath];
    [cell setBidHistory:self.bidList[indexPath.row] indexPath:indexPath blockDate:self.blockDate blockNumber:self.blockNumber];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)setBidList:(NSArray *)bidList currentDate:(NSDate *)currentDate currentBlockNumber:(UInt32)blockNumber {
    WS(weakSelf)
    _bidList = bidList;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.recordListButton setTitle:[NSString stringWithFormat:@"%ld条记录", bidList.count] forState:UIControlStateNormal];
        weakSelf.blockDate = currentDate;
        weakSelf.blockNumber = blockNumber;
        [weakSelf.tableView reloadData];
    });
}

@end
