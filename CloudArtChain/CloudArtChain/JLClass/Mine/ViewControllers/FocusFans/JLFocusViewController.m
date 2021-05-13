//
//  JLFocusViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/4.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLFocusViewController.h"
#import "JLCreatorPageViewController.h"

#import "JLFocusFansTableViewCell.h"
#import "JLNormalEmptyView.h"

@interface JLFocusViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) JLNormalEmptyView *emptyView;
@property (nonatomic, strong) NSMutableArray *focusArray;
@end

@implementation JLFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关注的人";
    [self addBackItem];
    [self createSubViews];
    [self headRefresh];
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
        WS(weakSelf)
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JL_color_white_ffffff;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JLFocusFansTableViewCell class] forCellReuseIdentifier:@"JLFocusFansTableViewCell"];
        _tableView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footRefresh];
        }];
    }
    return _tableView;
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.focusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    JLFocusFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLFocusFansTableViewCell" forIndexPath:indexPath];
    [cell setAuthor:self.focusArray[indexPath.row] isLastCell:(indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1)];
    cell.cancleFocusBlock = ^(Model_art_author_Data * _Nonnull authorData) {
        Model_members_unfollow_Req *request = [[Model_members_unfollow_Req alloc] init];
        request.author_id = authorData.ID;
        Model_members_unfollow_Rsp *response = [[Model_members_unfollow_Rsp alloc] init];
        response.request = request;
        [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
        [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
            [[JLLoading sharedLoading] hideLoading];
            if (netIsWork) {
                [weakSelf.focusArray replaceObjectAtIndex:indexPath.row withObject:response.body];
                [weakSelf.tableView reloadData];
                [[JLLoading sharedLoading] showMBSuccessTipMessage:@"已取消关注" hideTime:KToastDismissDelayTimeInterval];
            } else {
                [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
            }
        }];
    };
    cell.focusBlock = ^(Model_art_author_Data * _Nonnull authorData) {
        Model_members_follow_Req *request = [[Model_members_follow_Req alloc] init];
        request.author_id = authorData.ID;
        Model_members_follow_Rsp *response = [[Model_members_follow_Rsp alloc] init];
        response.request = request;
        [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
        [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
            [[JLLoading sharedLoading] hideLoading];
            if (netIsWork) {
                [weakSelf.focusArray replaceObjectAtIndex:indexPath.row withObject:response.body];
                [weakSelf.tableView reloadData];
                [[JLLoading sharedLoading] showMBSuccessTipMessage:@"关注成功" hideTime:KToastDismissDelayTimeInterval];
            } else {
                [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
            }
        }];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    JLCreatorPageViewController *creatorPageVC = [[JLCreatorPageViewController alloc] init];
    creatorPageVC.authorData = self.focusArray[indexPath.row];
//    creatorPageVC.cancelFollowBlock = ^(Model_art_author_Data * _Nonnull authorData) {
//        [weakSelf.focusArray replaceObjectAtIndex:indexPath.row withObject:authorData];
//        [weakSelf.tableView reloadData];
//    };
    creatorPageVC.backBlock = ^(Model_art_author_Data * _Nonnull authorData) {
        [weakSelf.focusArray replaceObjectAtIndex:indexPath.row withObject:authorData];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:creatorPageVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96.0f;
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

#pragma mark 请求关注列表
- (void)requestFocusList {
    WS(weakSelf)
    Model_members_followings_Req *request = [[Model_members_followings_Req alloc] init];
    request.page = self.currentPage;
    request.per_page = kPageSize;
    Model_members_followings_Rsp *response = [[Model_members_followings_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.focusArray removeAllObjects];
            }
            [weakSelf.focusArray addObjectsFromArray:response.body];

            [weakSelf endRefresh:response.body];
            [self setNoDataShow];
            [self.tableView reloadData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

- (JLNormalEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JLNormalEmptyView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height)];
    }
    return _emptyView;
}

- (void)headRefresh {
    self.currentPage = 1;
    [self requestFocusList];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestFocusList];
}

- (void)endRefresh:(NSArray*)focusArray {
    if (focusArray.count < kPageSize) {
        [(JLRefreshFooter *)self.tableView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)setNoDataShow {
    if (self.focusArray.count == 0) {
        [self.tableView addSubview:self.emptyView];
    } else {
        if (_emptyView) {
            [self.emptyView removeFromSuperview];
            self.emptyView = nil;
        }
    }
}

- (NSMutableArray *)focusArray {
    if (!_focusArray) {
        _focusArray = [NSMutableArray array];
    }
    return _focusArray;
}

@end
