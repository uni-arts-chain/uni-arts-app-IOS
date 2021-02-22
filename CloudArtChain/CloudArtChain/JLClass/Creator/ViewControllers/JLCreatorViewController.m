//
//  JLCreatorViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCreatorViewController.h"
#import "JLCreatorPageViewController.h"

#import "JLCreatorTableViewCell.h"
#import "JLCreatorTableHeaderView.h"

@interface JLCreatorViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JLCreatorTableHeaderView *creatorTableHeaderView;
@end

@implementation JLCreatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创作者";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JL_color_white_ffffff;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.creatorTableHeaderView;
        [_tableView registerClass:[JLCreatorTableViewCell class] forCellReuseIdentifier:@"JLCreatorTableViewCell"];
    }
    return _tableView;
}

- (JLCreatorTableHeaderView *)creatorTableHeaderView {
    if (!_creatorTableHeaderView) {
        WS(weakSelf)
        _creatorTableHeaderView = [[JLCreatorTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 243.0f)];
        _creatorTableHeaderView.headerClickBlock = ^{
            JLCreatorPageViewController *creatorPageVC = [[JLCreatorPageViewController alloc] init];
            [weakSelf.navigationController pushViewController:creatorPageVC animated:YES];
        };
    }
    return _creatorTableHeaderView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLCreatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLCreatorTableViewCell" forIndexPath:indexPath];
    cell.viewController = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 314.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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
@end
