//
//  JLCreatorViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCreatorViewController.h"
#import "JLCreatorPageViewController.h"
#import "JLHomePageViewController.h"

#import "JLCreatorTableViewCell.h"
#import "JLCreatorTableHeaderViewCell.h"
#import "JLCreatorTableHeaderView.h"

@interface JLCreatorViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JLCreatorTableHeaderView *creatorTableHeaderView;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *topList;
@property (nonatomic, strong) NSMutableArray *preTopicList;
@end

@implementation JLCreatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创作者";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 请求置顶艺术家列表
    [self headRefresh];
}

- (UITableView *)tableView {
    if (!_tableView) {
        WS(weakSelf)
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JL_color_white_ffffff;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView = self.creatorTableHeaderView;
        [_tableView registerClass:[JLCreatorTableViewCell class] forCellReuseIdentifier:@"JLCreatorTableViewCell"];
        [_tableView registerClass:[JLCreatorTableHeaderViewCell class] forCellReuseIdentifier:@"JLCreatorTableHeaderViewCell"];
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
    [self requestArtistTopic];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestPreArtistTopic:YES];
}

- (void)endRefresh:(NSArray*)authorArray {
    [self.tableView.mj_header endRefreshing];
    if (authorArray.count < kPageSize) {
        [(JLRefreshFooter *)self.tableView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (JLCreatorTableHeaderView *)creatorTableHeaderView {
    if (!_creatorTableHeaderView) {
        WS(weakSelf)
        _creatorTableHeaderView = [[JLCreatorTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 243.0f)];
        _creatorTableHeaderView.headerClickBlock = ^(Model_art_author_Data * _Nonnull authorData) {
            if (authorData != nil) {
                if ([authorData.ID isEqualToString:[AppSingleton sharedAppSingleton].userBody.ID]) {
                    JLHomePageViewController *homePageVC = [[JLHomePageViewController alloc] init];
                    [weakSelf.navigationController pushViewController:homePageVC animated:YES];
                } else {
                    JLCreatorPageViewController *creatorPageVC = [[JLCreatorPageViewController alloc] init];
                    creatorPageVC.authorData = authorData;
                    creatorPageVC.backBlock = ^(Model_art_author_Data * _Nonnull authorData) {
                        weakSelf.creatorTableHeaderView.authorData = authorData;
                    };
                    [weakSelf.navigationController pushViewController:creatorPageVC animated:YES];
                }
            }
        };
    }
    return _creatorTableHeaderView;
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.preTopicList.count == 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.topList.count;
    } else {
        return self.preTopicList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JLCreatorTableHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLCreatorTableHeaderViewCell" forIndexPath:indexPath];
        [cell setAuthorData:self.topList[indexPath.row] indexPath:indexPath];
        return cell;
    } else {
        JLCreatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLCreatorTableViewCell" forIndexPath:indexPath];
        cell.preTopicData = self.preTopicList[indexPath.row];
        cell.viewController = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 243.0f;
    }
    return 314.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 38.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [UIView new];
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, [self tableView:tableView heightForHeaderInSection:section])];
    headerView.backgroundColor = JL_color_white_ffffff;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = kFontPingFangSCMedium(16.0f);
    titleLabel.textColor = JL_color_gray_333333;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"往期平台推荐";
    [headerView addSubview:titleLabel];
    
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = JL_color_black;
    [headerView addSubview:leftLineView];
    
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = JL_color_black;
    [headerView addSubview:rightLineView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView);
        make.centerX.equalTo(headerView);
    }];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleLabel.mas_left).offset(-10.0f);
        make.height.mas_equalTo(2.0f);
        make.width.mas_equalTo(20.0f);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(10.0f);
        make.height.mas_equalTo(2.0f);
        make.width.mas_equalTo(20.0f);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0) {
        Model_art_author_Data *authorData = self.topList[indexPath.row];
        if ([authorData.ID isEqualToString:[AppSingleton sharedAppSingleton].userBody.ID]) {
            JLHomePageViewController *homePageVC = [[JLHomePageViewController alloc] init];
            [self.navigationController pushViewController:homePageVC animated:YES];
        } else {
            JLCreatorPageViewController *creatorPageVC = [[JLCreatorPageViewController alloc] init];
            creatorPageVC.authorData = authorData;
            creatorPageVC.backBlock = ^(Model_art_author_Data * _Nonnull authorData) {
                weakSelf.creatorTableHeaderView.authorData = authorData;
            };
            [self.navigationController pushViewController:creatorPageVC animated:YES];
        }
    }
}

#pragma mark 请求置顶艺术家
- (void)requestArtistTopic {
    WS(weakSelf)
    Model_members_artist_topic_Req *request = [[Model_members_artist_topic_Req alloc] init];
    Model_members_artist_topic_Rsp *response = [[Model_members_artist_topic_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
//            weakSelf.creatorTableHeaderView.authorData = [response.body firstObject];
            weakSelf.topList = response.body;
        } else {
            NSLog(@"error: %@", errorStr);
        }
        [weakSelf requestPreArtistTopic:NO];
    }];
}

#pragma mark 请求往期艺术家推荐
- (void)requestPreArtistTopic:(BOOL)refresh {
    WS(weakSelf)
    Model_members_pre_artist_topic_Req *request = [[Model_members_pre_artist_topic_Req alloc] init];
    request.page = self.currentPage;
    request.per_page = kPageSize;
    Model_members_pre_artist_topic_Rsp *response = [[Model_members_pre_artist_topic_Rsp alloc] init];
    
    if (refresh) {
        [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    }
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.preTopicList removeAllObjects];
            }
            [weakSelf.preTopicList addObjectsFromArray:response.body];
            [weakSelf endRefresh:response.body];
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"error: %@", errorStr);
        }
    }];
}

- (NSMutableArray *)preTopicList {
    if (!_preTopicList) {
        _preTopicList = [NSMutableArray array];
    }
    return _preTopicList;
}
@end
