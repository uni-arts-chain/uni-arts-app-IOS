//
//  JLSinglePurchaseOrderViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/1.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLSinglePurchaseOrderViewController.h"
#import "JLOrderDetailViewController.h"

#import "JLNormalEmptyView.h"
#import "JLSinglePurchaseOrderListCell.h"
#import "JLLogisticsView.h"

@interface JLSinglePurchaseOrderViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JLNormalEmptyView *noOrderView;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation JLSinglePurchaseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"买入订单";
    [self addBackItem];
    
    [self createView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)headRefresh {
    self.currentPage = 1;
    [self requestOrder];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestOrder];
}

#pragma mark  请求订单
- (void)requestOrder {
    WS(weakSelf)
    Model_arts_bought_Req *request = [[Model_arts_bought_Req alloc] init];
    request.page = self.currentPage;
    request.per_page = kPageSize;
    Model_arts_bought_Rsp *response = [[Model_arts_bought_Rsp alloc] init];

    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            [weakSelf.dataArray addObjectsFromArray:response.body];
            [weakSelf endRefresh:response.body];
            [weakSelf setNoOrderViewShow];
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)endRefresh:(NSArray*)orderArray {
    [self.tableView.mj_header endRefreshing];
    if (orderArray.count < kPageSize) {
        [(JLRefreshFooter *)self.tableView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)setNoOrderViewShow {
    if (self.dataArray.count == 0) {
        [self.view addSubview:self.noOrderView];
    } else {
        if (_noOrderView) {
            [self.noOrderView removeFromSuperview];
            self.noOrderView = nil;
        }
    }
}

- (void)createView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLSinglePurchaseOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLSinglePurchaseOrderListCell" forIndexPath:indexPath];
    cell.soldData = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JLOrderDetailViewController *orderDetailVC = [[JLOrderDetailViewController alloc] init];
    orderDetailVC.orderDetailType = JLOrderDetailTypeBuy;
    orderDetailVC.orderData = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JL_color_white_ffffff;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JLSinglePurchaseOrderListCell class] forCellReuseIdentifier:@"JLSinglePurchaseOrderListCell"];
        
        _tableView.mj_header = [JLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
        _tableView.mj_footer = [JLRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    }
    return _tableView;
}

- (JLNormalEmptyView *)noOrderView {
    if (!_noOrderView) {
        _noOrderView = [[JLNormalEmptyView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height)];
    }
    return _noOrderView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

@end
