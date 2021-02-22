//
//  JLPurchaseOrderListViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLPurchaseOrderListViewController.h"

#import "JLNoOrderView.h"
#import "JLPurchaseOrderListTableViewCell.h"
#import "JLPurchaseOrderListCloseTableViewCell.h"
#import "JLLogisticsView.h"

@interface JLPurchaseOrderListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JLNoOrderView *noOrderView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger showTime;
@end

@implementation JLPurchaseOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.showTime++;
    if (self.showTime > 1) {
        [self headRefresh];
    }
}

- (void)headRefresh {
    self.currentPage = 1;
    self.tableView.mj_footer.hidden = YES;
    [self requestOrder];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestOrder];
}

#pragma mark  请求订单
- (void)requestOrder {
//    WS(weakSelf)
//    Model_orders_Req *request = [[Model_orders_Req alloc] init];
//    if (self.state == JLMinerOrderStatePaying) {
//        request.state = @"paying";
//    } else if(self.state == JLMinerOrderStatePreparing) {
//        request.mining_state = @"waitting";
//    } else if (self.state == JLMinerOrderStateWaiting) {
//        request.mining_state = @"suspend";
//    } else if (self.state == JLMinerOrderStateRunning) {
//        request.mining_state = @"running";
//    }
//    request.page = self.currentPage;
//    Model_orders_Rsp *response = [[Model_orders_Rsp alloc] init];
//
//    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
//        if (netIsWork) {
//            if (weakSelf.currentPage == 1) {
//                [weakSelf.dataArray removeAllObjects];
//            }
//            [weakSelf.dataArray addObjectsFromArray:response.body];
//            [weakSelf endRefresh:response.body];
//            [weakSelf setNoOrderViewShow];
//            [weakSelf.tableView reloadData];
//        } else {
//            [weakSelf.tableView.mj_header endRefreshing];
//            [weakSelf.tableView.mj_footer endRefreshing];
//        }
//    }];
    [self endRefresh:[NSArray array]];
//    [self setNoOrderViewShow];
    [self.tableView reloadData];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger currentState = self.state;
    if (self.state == JLPurchaseOrderStateAll) {
        currentState = JLPurchaseOrderStateClose;
    }
    if (currentState == JLPurchaseOrderStateClose) {
        JLPurchaseOrderListCloseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLPurchaseOrderListCloseTableViewCell" forIndexPath:indexPath];
        return cell;
    } else {
        JLPurchaseOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLPurchaseOrderListTableViewCell" forIndexPath:indexPath];
        cell.state = currentState;
        cell.cancelOrderBlock = ^{
            NSLog(@"cancelOrderBlock");
        };
        cell.orderPayBlock = ^{
            NSLog(@"orderPayBlock");
        };
        cell.logisticsBlock = ^{
            JLLogisticsView *logisticsView = [[JLLogisticsView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth - 40.0f * 2, 242.0f)];
            ViewBorderRadius(logisticsView, 5.0f, 0.0f, JL_color_clear);
            [JLAlert alertCustomView:logisticsView maxWidth:kScreenWidth - 40.0f * 2];
        };
        cell.receiveBlock = ^{
            NSLog(@"receiveBlock");
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger currentState = self.state;
    if (self.state == JLPurchaseOrderStateAll) {
        currentState = JLPurchaseOrderStateClose;
    }
    if (currentState == JLPurchaseOrderStateClose) {
        return 170.0f;
    }
    return 212.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        [_tableView registerClass:[JLPurchaseOrderListTableViewCell class] forCellReuseIdentifier:@"JLPurchaseOrderListTableViewCell"];
        [_tableView registerClass:[JLPurchaseOrderListCloseTableViewCell class] forCellReuseIdentifier:@"JLPurchaseOrderListCloseTableViewCell"];
        
        _tableView.mj_header = [JLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
        _tableView.mj_footer = [JLRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    }
    return _tableView;
}

- (JLNoOrderView *)noOrderView {
    if (!_noOrderView) {
        _noOrderView = [[JLNoOrderView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height)];
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
