//
//  JLMessageViewController.m
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/6.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLMessageViewController.h"
#import "JLHomePageViewController.h"

#import "JLMessageTableViewCell.h"
#import "JLNormalEmptyView.h"

@interface JLMessageViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messageListArray;
@property (nonatomic, strong) JLNormalEmptyView *noOrderView;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation JLMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    [self addBackItem];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
    }];
    
    [self.tableView.mj_header beginRefreshing];
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
        [_tableView registerClass:[JLMessageTableViewCell class] forCellReuseIdentifier:@"JLMessageTableViewCell"];
        
        _tableView.mj_header = [JLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
        _tableView.mj_footer = [JLRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    }
    return _tableView;
}

- (void)headRefresh {
    self.currentPage = 1;
    self.tableView.mj_footer.hidden = YES;
    [self requestMessageList];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestMessageList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLMessageTableViewCell" forIndexPath:indexPath];
    cell.messageData = self.messageListArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0f;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JLHomePageViewController *homePageVC = [[JLHomePageViewController alloc] init];
    [self.navigationController pushViewController:homePageVC animated:YES];
}

- (NSMutableArray *)messageListArray {
    if (!_messageListArray) {
        _messageListArray = [NSMutableArray array];
    }
    return _messageListArray;
}

- (JLNormalEmptyView *)noOrderView {
    if (!_noOrderView) {
        _noOrderView = [[JLNormalEmptyView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height)];
    }
    return _noOrderView;
}

- (void)requestMessageList {
    WS(weakSelf)
    Model_messages_Req *request = [[Model_messages_Req alloc] init];
    request.page = self.currentPage;
    Model_messages_Rsp *response = [[Model_messages_Rsp alloc] init];

    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.messageListArray removeAllObjects];
            }
            [weakSelf.messageListArray addObjectsFromArray:response.body];
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
    if (orderArray.count == 0) {
        [(JLRefreshFooter *)self.tableView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)setNoOrderViewShow {
    if (self.messageListArray.count == 0) {
        [self.view addSubview:self.noOrderView];
    } else {
        if (_noOrderView) {
            [self.noOrderView removeFromSuperview];
            self.noOrderView = nil;
        }
    }
}
@end
