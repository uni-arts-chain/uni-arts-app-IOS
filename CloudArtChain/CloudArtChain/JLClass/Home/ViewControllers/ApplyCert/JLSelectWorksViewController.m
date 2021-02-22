//
//  JLSelectWorksViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLSelectWorksViewController.h"

#import "JLApplyCertWorksSelfSignCell.h"
#import "JLApplyCertWorksMechanismSignCell.h"

@interface JLSelectWorksViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation JLSelectWorksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择作品";
    [self addBackItem];
    [self addRightBarButton];
    [self createSubViews];
}

- (void)addRightBarButton {
    NSString *title = @"确认";
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnClick)];
    NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_blue_38B2F1, NSFontAttributeName: kFontPingFangSCRegular(15.0f)};
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)confirmBtnClick {
    if (self.selectedIndexPath == nil) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请选择作品后确认" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
        [_tableView registerClass:[JLApplyCertWorksSelfSignCell class] forCellReuseIdentifier:@"JLApplyCertWorksSelfSignCell"];
        [_tableView registerClass:[JLApplyCertWorksMechanismSignCell class] forCellReuseIdentifier:@"JLApplyCertWorksMechanismSignCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource, UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectType == JLSelectWorksTypeSelfSign) {
        JLApplyCertWorksSelfSignCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLApplyCertWorksSelfSignCell" forIndexPath:indexPath];
        if (self.selectedIndexPath) {
            [cell worksSelected:[indexPath isEqual:self.selectedIndexPath]];
        }
        return cell;
    } else {
        JLApplyCertWorksMechanismSignCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLApplyCertWorksMechanismSignCell" forIndexPath:indexPath];
        if (self.selectedIndexPath) {
            [cell worksSelected:[indexPath isEqual:self.selectedIndexPath]];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = JL_color_white_ffffff;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self.tableView reloadData];
}
@end
