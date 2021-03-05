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
#import "JLNormalEmptyView.h"

@interface JLSelectWorksViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *artsArray;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) JLNormalEmptyView *emptyView;
@end

@implementation JLSelectWorksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择作品";
    [self addBackItem];
    [self addRightBarButton];
    [self createSubViews];
    [self headRefresh];
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
    if (self.selectWorkBlock) {
        self.selectWorkBlock(self.artsArray[self.selectedIndexPath.row]);
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
        WS(weakSelf)
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
        _tableView.mj_footer = [JLRefreshFooter footerWithRefreshingBlock:^{
            [weakSelf footRefresh];
        }];
        _tableView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf headRefresh];
        }];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource, UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.artsArray.count;
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
        cell.artDetailData = self.artsArray[indexPath.row];
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

- (NSMutableArray *)artsArray {
    if (!_artsArray) {
        _artsArray = [NSMutableArray array];
    }
    return _artsArray;
}

- (JLNormalEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JLNormalEmptyView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height)];
    }
    return _emptyView;
}

- (void)headRefresh {
    self.currentPage = 1;
    self.tableView.mj_footer.hidden = YES;
    if (self.selectType == JLSelectWorksTypeMechanismAddSign) {
        [self requestAvailableSignatureArtList];
    }
}

- (void)footRefresh {
    self.currentPage++;
    if (self.selectType == JLSelectWorksTypeMechanismAddSign) {
        [self requestAvailableSignatureArtList];
    }
}

- (void)endRefresh:(NSArray*)artsArray {
    [self.tableView.mj_header endRefreshing];
    if (artsArray.count < kPageSize) {
        self.tableView.mj_footer.hidden = NO;
        [(JLRefreshFooter *)self.tableView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)setNoDataShow {
    if (self.artsArray.count == 0) {
        [self.tableView addSubview:self.emptyView];
    } else {
        if (_emptyView) {
            [self.emptyView removeFromSuperview];
            self.emptyView = nil;
        }
    }
}

#pragma mark 请求艺术作品列表
- (void)requestAvailableSignatureArtList {
    WS(weakSelf)
    Model_arts_available_signature_arts_Req *request = [[Model_arts_available_signature_arts_Req alloc] init];
    request.page = self.currentPage;
    request.per_page = kPageSize;
    request.organization_name = self.organizationData.name;
    Model_arts_available_signature_arts_Rsp *response = [[Model_arts_available_signature_arts_Rsp alloc] init];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        [[JLLoading sharedLoading] hideLoading];
        if (netIsWork) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.artsArray removeAllObjects];
            }
            [weakSelf.artsArray addObjectsFromArray:response.body];
            
            [weakSelf endRefresh:response.body];
            [self setNoDataShow];
            [self.tableView reloadData];
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}
@end
