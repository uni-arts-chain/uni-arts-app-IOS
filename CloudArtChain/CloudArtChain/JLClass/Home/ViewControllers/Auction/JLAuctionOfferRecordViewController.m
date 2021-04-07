//
//  JLAuctionOfferRecordViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/19.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLAuctionOfferRecordViewController.h"
#import "JLAuctionOfferRecordCell.h"

@interface JLAuctionOfferRecordViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JLAuctionOfferRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"出价记录";
    [self addBackItem];
    [self createSubViews];
}

- (void)createSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
    }];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
    return self.bidList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLAuctionOfferRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLAuctionOfferRecordCell" forIndexPath:indexPath];
    [cell setBidHistory:self.bidList[indexPath.row] indexPath:indexPath blockDate:self.blockDate blockNumber:self.blockNumber];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

@end
