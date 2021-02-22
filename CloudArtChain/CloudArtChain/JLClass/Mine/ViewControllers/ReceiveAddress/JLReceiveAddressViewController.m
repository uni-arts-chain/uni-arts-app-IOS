//
//  JLReceiveAddressViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLReceiveAddressViewController.h"
#import "JLEditAddressViewController.h"

#import "JLReceiveAddressTableViewCell.h"
#import "JLNoAddressView.h"

@interface JLReceiveAddressViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) JLNoAddressView *noAddressView;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation JLReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收货地址";
    [self addBackItem];
    [self addRightBarButton];
    [self createView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)addRightBarButton {
    NSString *title = @"新增地址";
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(addAddressBtnClick)];
    NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_212121, NSFontAttributeName: kFontPingFangSCRegular(14.0f)};
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)addAddressBtnClick {
    JLEditAddressViewController *editAddressVC = [[JLEditAddressViewController alloc] init];
    editAddressVC.editAdressType = JLEidtAddressTypeAdd;
    [self.navigationController pushViewController:editAddressVC animated:YES];
}

- (void)createView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
    }];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JL_color_white_ffffff;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 107.0f;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JLReceiveAddressTableViewCell class] forCellReuseIdentifier:@"JLReceiveAddressTableViewCell"];
        
        _tableView.mj_header = [JLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
        _tableView.mj_footer = [JLRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    }
    return _tableView;
}

- (void)headRefresh {
    self.currentPage = 1;
    self.tableView.mj_footer.hidden = YES;
    [self requestAddressList];
}

- (void)footRefresh {
    self.currentPage++;
    [self requestAddressList];
}

- (void)requestAddressList {
    [self endRefresh:[NSArray array]];
    [self setNoOrderViewShow];
    [self.tableView reloadData];
}

- (void)endRefresh:(NSArray*)addressArray {
    [self.tableView.mj_header endRefreshing];
    if (addressArray.count < kPageSize) {
        [(JLRefreshFooter *)self.tableView.mj_footer endWithNoMoreDataNotice];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)setNoOrderViewShow {
    if (self.addressArray.count == 0) {
        [self.view addSubview:self.noAddressView];
    } else {
        if (_noAddressView) {
            [self.noAddressView removeFromSuperview];
            self.noAddressView = nil;
        }
    }
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    JLReceiveAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLReceiveAddressTableViewCell" forIndexPath:indexPath];
    cell.editAddressBlock = ^{
        JLEditAddressViewController *editAddressVC = [[JLEditAddressViewController alloc] init];
        editAddressVC.editAdressType = JLEidtAddressTypeEdit;
        [weakSelf.navigationController pushViewController:editAddressVC animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSMutableArray *)addressArray {
    if (!_addressArray) {
        _addressArray = [NSMutableArray array];
    }
    return _addressArray;
}

- (JLNoAddressView *)noAddressView {
    if (!_noAddressView) {
        WS(weakSelf)
        _noAddressView = [[JLNoAddressView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height - KTouch_Responder_Height)];
        _noAddressView.addNewAddressBlock = ^{
            JLEditAddressViewController *editAddressVC = [[JLEditAddressViewController alloc] init];
            editAddressVC.editAdressType = JLEidtAddressTypeAdd;
            [weakSelf.navigationController pushViewController:editAddressVC animated:YES];
        };
    }
    return _noAddressView;
}

@end
