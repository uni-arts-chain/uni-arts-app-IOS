//
//  JLBoxViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/16.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBoxViewController.h"
#import "JLBoxDetailViewController.h"

#import "JLBoxTableViewCell.h"

@interface JLBoxViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *boxList;
@end

@implementation JLBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"盲盒";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.topInset);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (UITableView *)tableView {
    if (!_tableView) {
        WS(weakSelf)
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JL_color_white_ffffff;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 260.0f;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        [_tableView registerClass:[JLBoxTableViewCell class] forCellReuseIdentifier:@"JLBoxTableViewCell"];
        _tableView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf headRefresh];
        }];
        _tableView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footRefresh];
        }];
    }
    return _tableView;
}

- (void)headRefresh {
    self.currentPage = 1;
    [self requetBlindBoxList];
}

- (void)footRefresh {
    self.currentPage++;
    [self requetBlindBoxList];
}

- (void)endRefresh:(NSArray*)boxArray {
    [self.tableView.mj_header endRefreshing];
    if (boxArray.count < kPageSize) {
        [(JLRefreshFooter *)self.tableView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.boxList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLBoxTableViewCell" forIndexPath:indexPath];
    cell.boxData = self.boxList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JLBoxDetailViewController *boxDetailVC = [[JLBoxDetailViewController alloc] init];
    boxDetailVC.boxData = self.boxList[indexPath.row];
    [self.navigationController pushViewController:boxDetailVC animated:YES];
}

- (void)requetBlindBoxList {
    WS(weakSelf)
    Model_blind_boxes_Req *request = [[Model_blind_boxes_Req alloc] init];
    Model_blind_boxes_Rsp *response = [[Model_blind_boxes_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.boxList removeAllObjects];
            }
            [weakSelf.boxList addObjectsFromArray:response.body];
            [weakSelf endRefresh:response.body];
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

- (NSMutableArray *)boxList {
    if (!_boxList) {
        _boxList = [NSMutableArray array];
    }
    return _boxList;
}

@end
