//
//  JLWalletViewController.m
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWalletViewController.h"
#import "UIButton+AxcButtonContentLayout.h"
#import "JLIntegralListViewController.h"
#import "JLEditWalletViewController.h"

#import "JLWalletPointCell.h"

#import "JLWalletCryptoModel.h"

@interface JLWalletViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) JLAccountItem *currentAccount;
@end

@implementation JLWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"积分钱包";
    [self addBackItem];
    self.currentAccount = [[JLViewControllerTool appDelegate].walletTool getCurrentAccount];
    [self createSubViews];
    NSLog(@"%@", [JLWalletCryptoModel getKeyPair]);
}

- (void)backClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createSubViews {
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
        make.height.mas_equalTo(62.0f);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        
        UIView *centerView = [[UIView alloc] init];
        [_bottomView addSubview:centerView];
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_bottomView);
            make.centerX.equalTo(_bottomView.mas_centerX);
        }];
        
        UILabel *titleLabel = [JLUIFactory labelInitText:@"积分说明" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentCenter];
        [centerView addSubview:titleLabel];
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.image = [UIImage imageNamed:@"icon_wallet_point_help"];
        [centerView addSubview:iconImageView];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(centerView);
        }];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(7.0f);
            make.right.equalTo(centerView);
            make.size.mas_equalTo(14.0f);
            make.centerY.equalTo(titleLabel.mas_centerY);
        }];
        
        UIButton *pointDescBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [pointDescBtn addTarget:self action:@selector(pointDescBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:pointDescBtn];
        [pointDescBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_bottomView);
        }];
    }
    return _bottomView;
}

- (void)pointDescBtnClick {
    
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
        [_tableView registerClass:[JLWalletPointCell class] forCellReuseIdentifier:@"JLWalletPointCell"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLWalletPointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLWalletPointCell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JLIntegralListViewController *integralListVC = [[JLIntegralListViewController alloc] init];
    [self.navigationController pushViewController:integralListVC animated:YES];
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 220.0f)];
        
        UIImageView *backImageView = [[UIImageView alloc] init];
        backImageView.image = [UIColor randomColor];
        [_tableHeaderView addSubview:backImageView];
        
        UIView *avatarView = [[UIView alloc] init];
        avatarView.backgroundColor = JL_color_white_ffffff;
        ViewBorderRadius(avatarView, 65.0f * 0.5f, 0.0f, JL_color_clear);
        [_tableHeaderView addSubview:avatarView];
        
        UIImageView *avatarImageView = [[UIImageView alloc] init];
        avatarImageView.backgroundColor = [UIColor randomColor];
        ViewBorderRadius(avatarImageView, 59.0f * 0.5f, 0.0f, JL_color_clear);
        [avatarView addSubview:avatarImageView];
        
//        UILabel *nameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(16.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
//        [_tableHeaderView addSubview:nameLabel];
//
//        UILabel *addressLabel = [JLUIFactory labelInitText:[NSString stringWithFormat:@"钱包地址：%@", @""] font:kFontPingFangSCRegular(13.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
//        [_tableHeaderView addSubview:addressLabel];
        
        UILabel *nameLabel = [JLUIFactory labelInitText:self.currentAccount.username font:kFontPingFangSCMedium(16.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
        [_tableHeaderView addSubview:nameLabel];

        UILabel *addressLabel = [JLUIFactory labelInitText:[NSString stringWithFormat:@"钱包地址：%@", [self.currentAccount getHiddenAddress]] font:kFontPingFangSCRegular(13.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
        [_tableHeaderView addSubview:addressLabel];
        
        UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [headerButton addTarget:self action:@selector(headerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeaderView addSubview:headerButton];
        
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_tableHeaderView);
        }];
        [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(38.0f);
            make.size.mas_equalTo(65.0f);
            make.centerX.equalTo(_tableHeaderView.mas_centerX);
        }];
        [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(avatarView).insets(UIEdgeInsetsMake(3.0f, 3.0f, 3.0f, 3.0f));
        }];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_tableHeaderView);
            make.top.equalTo(avatarView.mas_bottom).offset(18.0f);
            make.height.mas_equalTo(16.0f);
        }];
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_tableHeaderView);
            make.top.equalTo(nameLabel.mas_bottom).offset(26.0f);
            make.height.mas_equalTo(13.0f);
        }];
        [headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_tableHeaderView);
        }];
    }
    return _tableHeaderView;
}

- (void)headerButtonClick {
    JLEditWalletViewController *editWalletVC = [[JLEditWalletViewController alloc] init];
    [self.navigationController pushViewController:editWalletVC animated:YES];
}
@end
