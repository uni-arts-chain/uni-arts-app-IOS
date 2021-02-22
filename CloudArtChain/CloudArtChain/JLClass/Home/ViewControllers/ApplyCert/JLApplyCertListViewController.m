//
//  JLApplyCertViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLApplyCertListViewController.h"
#import "UIButton+AxcButtonContentLayout.h"
#import "JLApplyCertViewController.h"
#import "JLArtDetailViewController.h"
#import "JLApplyCertMechanismDetailViewController.h"

#import "JLApplyCertSelfSignCell.h"
#import "JLApplyCertMechanismSignCell.h"
#import "JLApplyCertNoDataCell.h"

@interface JLApplyCertListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL showAllSelfSign;
@property (nonatomic, strong) NSArray *selfSignArray;
@property (nonatomic, strong) NSArray *mechanismArray;
@end

@implementation JLApplyCertListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请证书";
    [self addBackItem];
    self.selfSignArray = @[@"", @"", @"", @""];
    self.mechanismArray = @[@"", @""];
    [self createSubViews];
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
        _tableView.tableHeaderView = self.tableHeaderView;
        [_tableView registerClass:[JLApplyCertSelfSignCell class] forCellReuseIdentifier:@"JLApplyCertSelfSignCell"];
        [_tableView registerClass:[JLApplyCertMechanismSignCell class] forCellReuseIdentifier:@"JLApplyCertMechanismSignCell"];
        [_tableView registerClass:[JLApplyCertNoDataCell class] forCellReuseIdentifier:@"JLApplyCertNoDataCell"];
    }
    return _tableView;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 140.0f)];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"icon_applycert_background"];
        [_tableHeaderView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10.0f);
            make.bottom.equalTo(_tableHeaderView);
            make.left.mas_equalTo(15.0f);
            make.right.mas_equalTo(-15.0f);
        }];
    }
    return _tableHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.selfSignArray.count > 0) {
            if (self.selfSignArray.count > 2) {
                if (self.showAllSelfSign) {
                    return self.selfSignArray.count;
                } else {
                    return 2;
                }
            } else {
                return self.selfSignArray.count;
            }
        } else {
            return 1;
        }
    } else {
        if (self.mechanismArray.count > 0) {
            return self.mechanismArray.count;
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.selfSignArray.count > 0) {
            JLApplyCertSelfSignCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLApplyCertSelfSignCell" forIndexPath:indexPath];
            [cell setIndex:indexPath.row total:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
            return cell;
        } else {
            JLApplyCertNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLApplyCertNoDataCell" forIndexPath:indexPath];
            cell.noticeStr = @"暂无作品";
            return cell;
        }
    } else {
        if (self.mechanismArray.count > 0) {
            JLApplyCertMechanismSignCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLApplyCertMechanismSignCell" forIndexPath:indexPath];
            [cell setIndex:indexPath.row total:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
            return cell;
        } else {
            JLApplyCertNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLApplyCertNoDataCell" forIndexPath:indexPath];
            cell.noticeStr = @"暂无鉴定机构";
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 37.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 && self.selfSignArray.count > 2) {
        return 46.0f;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    UILabel *titleLabel = [JLUIFactory labelInitText:section == 0 ? @"我的签名作品" : @"选择机构增加签名" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(headerView);
    }];
    if (section == 0) {
        // 添加申请证书按钮
        UIButton *applyCertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [applyCertBtn setTitle:@"申请证书" forState:UIControlStateNormal];
        [applyCertBtn setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        applyCertBtn.titleLabel.font = kFontPingFangSCRegular(13.0f);
        [applyCertBtn setImage:[UIImage imageNamed:@"icon_applycert_arrowapply"] forState:UIControlStateNormal];
        applyCertBtn.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleCenterImageRight;
        applyCertBtn.axcUI_padding = 8.0f;
        [headerView addSubview:applyCertBtn];
        [applyCertBtn addTarget:self action:@selector(applyCertBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [applyCertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headerView).offset(-23.0f);
            make.centerY.equalTo(titleLabel.mas_centerY);
        }];
    }
    return headerView;
}

- (void)applyCertBtnClick {
    JLApplyCertViewController *applyCertVC = [[JLApplyCertViewController alloc] init];
    [self.navigationController pushViewController:applyCertVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 && self.selfSignArray.count > 2) {
        UIView *footerView = [[UIView alloc] init];
        UIView *centerView = [[UIView alloc] init];
        [footerView addSubview:centerView];
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(footerView);
            make.centerX.equalTo(footerView.mas_centerX);
        }];
        self.titleLabel = [JLUIFactory labelInitText:self.showAllSelfSign ? @"收起" : @"全部作品" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentCenter];
        [centerView addSubview:self.titleLabel];
        
        [centerView addSubview:self.arrowImageView];
        
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(centerView);
            make.width.mas_equalTo(11.0f);
            make.height.mas_equalTo(6.0f);
            make.centerY.equalTo(centerView.mas_centerY);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(centerView);
            make.right.equalTo(self.arrowImageView.mas_left).offset(-6.0f);
        }];
        
        UIButton *showAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [showAllBtn addTarget:self action:@selector(showAllBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:showAllBtn];
        [showAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footerView);
        }];
        return footerView;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.selfSignArray.count > 0) {
        JLArtDetailViewController *artDetailVC = [[JLArtDetailViewController alloc] init];
        artDetailVC.artDetailType = JLArtDetailTypeSelfOrOffShelf;
        [self.navigationController pushViewController:artDetailVC animated:YES];
    } else if(indexPath.section == 1 && self.mechanismArray.count > 0) {
        JLApplyCertMechanismDetailViewController *mechanismDetailVC = [[JLApplyCertMechanismDetailViewController alloc] init];
        [self.navigationController pushViewController:mechanismDetailVC animated:YES];
    }
}

- (void)showAllBtnClick {
    WS(weakSelf)
    [UIView animateWithDuration:0.3f animations:^{
        if (weakSelf.showAllSelfSign) {
            weakSelf.arrowImageView.transform = CGAffineTransformIdentity;
        } else {
            weakSelf.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }
    }];
    self.showAllSelfSign = !self.showAllSelfSign;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"icon_applycert_arrowdown"];
    }
    return _arrowImageView;
}
@end
