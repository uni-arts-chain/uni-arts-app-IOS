//
//  JLOrderDetailViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/28.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLOrderDetailViewController.h"
#import "JLInputLogisticsViewController.h"

#import "JLOrderDetailTitleTableViewCell.h"
#import "JLOrderDetailProductTableViewCell.h"
#import "JLOrderDetailInfoTableViewCell.h"

@interface JLOrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JLOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
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
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100.0f;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[JLOrderDetailTitleTableViewCell class] forCellReuseIdentifier:@"JLOrderDetailTitleTableViewCell"];
        [_tableView registerClass:[JLOrderDetailProductTableViewCell class] forCellReuseIdentifier:@"JLOrderDetailProductTableViewCell"];
        [_tableView registerClass:[JLOrderDetailInfoTableViewCell class] forCellReuseIdentifier:@"JLOrderDetailInfoTableViewCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        JLOrderDetailTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLOrderDetailTitleTableViewCell" forIndexPath:indexPath];
        [cell setTitle:@"交易成功"];
        return cell;
    } else if (indexPath.row == 1) {
        JLOrderDetailProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLOrderDetailProductTableViewCell" forIndexPath:indexPath];
        cell.orderData = self.orderData;
        return cell;
    } else if (indexPath.row == 2) {
        JLOrderDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLOrderDetailInfoTableViewCell" forIndexPath:indexPath];
        cell.orderData = self.orderData;
        return cell;
    } else {
        return nil;
    }
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
