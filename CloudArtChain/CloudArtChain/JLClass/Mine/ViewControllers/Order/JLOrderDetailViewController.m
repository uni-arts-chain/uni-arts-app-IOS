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
#import "JLOrderDetailAddressTableViewCell.h"
#import "JLOrderDetailProductTableViewCell.h"
#import "JLOrderDetailInfoTableViewCell.h"

@interface JLOrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *bottomView;
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
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
        make.height.mas_equalTo(46.0f);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
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
        [_tableView registerClass:[JLOrderDetailAddressTableViewCell class] forCellReuseIdentifier:@"JLOrderDetailAddressTableViewCell"];
        [_tableView registerClass:[JLOrderDetailProductTableViewCell class] forCellReuseIdentifier:@"JLOrderDetailProductTableViewCell"];
        [_tableView registerClass:[JLOrderDetailInfoTableViewCell class] forCellReuseIdentifier:@"JLOrderDetailInfoTableViewCell"];
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = JL_color_white_ffffff;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = JL_color_gray_DDDDDD;
        [_bottomView addSubview:lineView];
        
        UIButton *cancelOrderBtn = [JLUIFactory buttonInitTitle:@"取消订单" titleColor:JL_color_gray_212121 backgroundColor:JL_color_white_ffffff font:kFontPingFangSCRegular(13.0f) addTarget:self action:@selector(cancelOrderBtnClick)];
        cancelOrderBtn.contentEdgeInsets = UIEdgeInsetsZero;
        ViewBorderRadius(cancelOrderBtn, 13.0f, 1.0f, JL_color_gray_DDDDDD);
        [_bottomView addSubview:cancelOrderBtn];
        
        UIButton *deliverBtn = [JLUIFactory buttonInitTitle:@"去发货" titleColor:JL_color_red_D70000 backgroundColor:JL_color_white_ffffff font:kFontPingFangSCRegular(13.0f) addTarget:self action:@selector(deliverBtnClick)];
        deliverBtn.contentEdgeInsets = UIEdgeInsetsZero;
        ViewBorderRadius(deliverBtn, 13.0f, 1.0f, JL_color_red_D70000);
        [_bottomView addSubview:deliverBtn];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_bottomView);
            make.height.mas_equalTo(1.0f);
        }];
        [deliverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16.0f);
            make.width.mas_equalTo(76.0f);
            make.height.mas_equalTo(26.0f);
            make.centerY.equalTo(_bottomView.mas_centerY);
        }];
        [cancelOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(deliverBtn.mas_left).offset(-16.0f);
            make.width.mas_equalTo(76.0f);
            make.height.mas_equalTo(26.0f);
            make.centerY.equalTo(_bottomView.mas_centerY);
        }];
    }
    return _bottomView;
}

- (void)cancelOrderBtnClick {
    
}

- (void)deliverBtnClick {
    JLInputLogisticsViewController *inputLogisticsVC = [[JLInputLogisticsViewController alloc] init];
    [self.navigationController pushViewController:inputLogisticsVC animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        JLOrderDetailTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLOrderDetailTitleTableViewCell" forIndexPath:indexPath];
        [cell setTitle:@"待发货"];
        return cell;
    } else if (indexPath.row == 1) {
        JLOrderDetailAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLOrderDetailAddressTableViewCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 2) {
        JLOrderDetailProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLOrderDetailProductTableViewCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 3) {
        JLOrderDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLOrderDetailInfoTableViewCell" forIndexPath:indexPath];
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
