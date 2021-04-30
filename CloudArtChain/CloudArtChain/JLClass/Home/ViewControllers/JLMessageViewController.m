//
//  JLMessageViewController.m
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/6.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLMessageViewController.h"
#import "JLHomePageViewController.h"
#import "JLSingleSellOrderViewController.h"
#import "JLBoxDetailViewController.h"

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
    [self addRightBarButton];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)addRightBarButton {
    NSString *title = @"全部已读";
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(maskAllReadedClick)];
    NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_212121, NSFontAttributeName: kFontPingFangSCRegular(14.0f)};
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)maskAllReadedClick {
    WS(weakSelf)
    Model_messages_read_all_Req *request = [[Model_messages_read_all_Req alloc] init];
    Model_messages_read_all_Rsp *response = [[Model_messages_read_all_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            NSArray *tempArray = [weakSelf.messageListArray copy];
            [weakSelf.messageListArray removeAllObjects];
            for (Model_messages_Data *messageData in tempArray) {
                messageData.read = YES;
                [weakSelf.messageListArray addObject:messageData];
            }
            [weakSelf.tableView reloadData];
            
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            [GeTuiSdk resetBadge];
        }
    }];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JL_color_white_ffffff;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 78.0f;
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
    Model_messages_Data *messageData = self.messageListArray[indexPath.row];
    if ([messageData.resource_type.lowercaseString isEqualToString:@"art"]) {
        // 作品审核
        JLHomePageViewController *homePageVC = [[JLHomePageViewController alloc] init];
        [self.navigationController pushViewController:homePageVC animated:YES];
    } else if ([messageData.resource_type.lowercaseString isEqualToString:@"arttrade"]) {
        // 作品卖出
        JLSingleSellOrderViewController *sellOrderVC = [[JLSingleSellOrderViewController alloc] init];
        [self.navigationController pushViewController:sellOrderVC animated:YES];
    } else if ([messageData.resource_type.lowercaseString isEqualToString:@"blindboxdrawgroup"]) {
        // 盲盒链上操作完成
        NSArray *params = [messageData.action_str componentsSeparatedByString:@"#"];
        if (params.count >= 2) {
            JLBoxDetailViewController *boxDetailVC = [[JLBoxDetailViewController alloc] init];
            boxDetailVC.boxId = params[1];
            [self.navigationController pushViewController:boxDetailVC animated:YES];
        }
    }
    // 标记消息已读
    [self maskMessageReaded:indexPath];
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

- (void)maskMessageReaded:(NSIndexPath *)indexPath {
    WS(weakSelf)
    Model_messages_Data *messageData = self.messageListArray[indexPath.row];
    Model_messages_read_Req *request = [[Model_messages_read_Req alloc] init];
    request.id = messageData.ID;
    Model_messages_read_Rsp *response = [[Model_messages_read_Rsp alloc] init];
    
    [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            messageData.read = YES;
            [weakSelf.messageListArray replaceObjectAtIndex:indexPath.row withObject:messageData];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            weakSelf.messageUnreadNumber = weakSelf.messageUnreadNumber - 1;
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:weakSelf.messageUnreadNumber];
            [GeTuiSdk setBadge:weakSelf.messageUnreadNumber];
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

- (void)refreshMessageList {
    [self.tableView.mj_header beginRefreshing];
}

@end
