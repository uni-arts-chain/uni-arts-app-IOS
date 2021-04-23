//
//  JLEditWalletViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/4.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLEditWalletViewController.h"
#import "UIImage+JLTool.h"
#import "JLWalletChangePwdViewController.h"
#import "JLExportKeystorePwdViewController.h"
#import "UIButton+AxcButtonContentLayout.h"

#import "JLEditWalletCell.h"
#import "JLWalletPwdInputView.h"
#import "JLPrivateKeyExportView.h"

@interface JLEditWalletViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) JLWalletPwdInputView *walletPwdInputView;
@property (nonatomic, strong) JLPrivateKeyExportView *privateKeyExportView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation JLEditWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑钱包";
    [self addBackItem];
//    [self addRightBarButton];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.mas_equalTo(-KTouch_Responder_Height - 60.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(107.0f);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (void)addRightBarButton {
    NSString *title = @"保存";
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_blue_38B2F1, NSFontAttributeName: kFontPingFangSCRegular(15.0f)};
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)saveBtnClick {
    [self.view endEditing:YES];
    JLEditWalletCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *walletName = [JLUtils trimSpace:cell.editContent];
    if ([NSString stringIsEmpty:walletName]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入钱包名" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    [[JLViewControllerTool appDelegate].walletTool saveUsernameWithUsername:walletName address:[[JLViewControllerTool appDelegate].walletTool getCurrentAccount].address];
    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"保存成功" hideTime:KToastDismissDelayTimeInterval];
    if (self.walletEditBlock) {
        self.walletEditBlock();
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WalletNameNotification" object:nil userInfo:@{@"walletName": walletName}];
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
        [_tableView registerClass:[JLEditWalletCell class] forCellReuseIdentifier:@"JLEditWalletCell"];
    }
    return _tableView;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 92.0f)];
        UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]]) {
            [headerButton setImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"] forState:UIControlStateNormal];
        } else {
            [headerButton sd_setImageWithURL:[NSURL URLWithString:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]] forState:UIControlStateNormal];
        }
        ViewBorderRadius(headerButton, 34.0f, 0, JL_color_clear);
        [_tableHeaderView addSubview:headerButton];
        [headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(68.0f);
            make.center.equalTo(_tableHeaderView);
        }];
    }
    return _tableHeaderView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        
        UIButton *saveButton = [JLUIFactory buttonInitTitle:@"保存" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_50C3FF font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(saveBtnClick)];
        ViewBorderRadius(saveButton, 23.0f, 0.0f, JL_color_clear);
        [_bottomView addSubview:saveButton];
        
        UIButton *backupMnemonicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backupMnemonicButton setTitle:@"备份助记词" forState:UIControlStateNormal];
        [backupMnemonicButton setTitleColor:JL_color_blue_50C3FF forState:UIControlStateNormal];
        backupMnemonicButton.titleLabel.font = kFontPingFangSCRegular(17.0f);
        [backupMnemonicButton setImage:[UIImage imageNamed:@"icon_wallet_export"] forState:UIControlStateNormal];
        [backupMnemonicButton setImage:[UIImage imageNamed:@"icon_wallet_export"] forState:UIControlStateHighlighted];
        backupMnemonicButton.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleCenterImageRight;
        backupMnemonicButton.axcUI_padding = 28.0f;
        [backupMnemonicButton addTarget:self action:@selector(backupMnemonicButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:backupMnemonicButton];
        
        [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_bottomView);
            make.height.mas_equalTo(46.0f);
        }];
        [backupMnemonicButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_bottomView);
            make.bottom.equalTo(saveButton.mas_top);
        }];
    }
    return _bottomView;
}

- (void)backupMnemonicButtonClick {
    [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
        if (success) {
            [[JLViewControllerTool appDelegate].walletTool backupMnemonicWithAddress:[[JLViewControllerTool appDelegate].walletTool getCurrentAccount].address navigationController:self.navigationController];
        }
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLEditWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLEditWalletCell"];
    [self configCell:cell indexPath:indexPath];
    return cell;
}

- (void)configCell:(JLEditWalletCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        cell.title = @"钱包名";
        cell.statusText = [[JLViewControllerTool appDelegate].walletTool getCurrentAccount].username;
        cell.editContent = [[JLViewControllerTool appDelegate].walletTool getCurrentAccount].username;
        cell.isEdit = YES;
    } else if (indexPath.row == 1) {
        cell.title = @"修改密码";
        cell.isEdit = NO;
    } else if (indexPath.row == 2) {
        cell.title = @"导出私钥";
        cell.isEdit = NO;
    } else if (indexPath.row == 3) {
        cell.title = @"导出Keystore";
        cell.isEdit = NO;
    } else {
        cell.title = @"隐私协议";
        cell.isEdit = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0f;
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
    WS(weakSelf)
    self.selectedIndexPath = indexPath;
    if (indexPath.row == 1) {
        [[JLViewControllerTool appDelegate].walletTool changePinSetupFrom:self.navigationController];
    } else if (indexPath.row == 2 || indexPath.row == 3) {
        [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
            if (success) {
                if (weakSelf.selectedIndexPath.row == 2) {
                    [JLAlert alertCustomView:weakSelf.privateKeyExportView maxWidth:kScreenWidth - 40.0f * 2];
                } else {
                    JLExportKeystorePwdViewController *exportKeystorePwdVC = [[JLExportKeystorePwdViewController alloc] init];
                    [weakSelf.navigationController pushViewController:exportKeystorePwdVC animated:YES];
                }
            }
        }];
    } else {
        // 隐私协议
    }
}

- (JLWalletPwdInputView *)walletPwdInputView {
    WS(weakSelf)
    if (!_walletPwdInputView) {
        _walletPwdInputView = [[JLWalletPwdInputView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth - 40.0f * 2, 212.0f)];
        ViewBorderRadius(_walletPwdInputView, 5.0f, 0.0f, JL_color_clear);
        _walletPwdInputView.confirmBlock = ^{
            if (weakSelf.selectedIndexPath.row == 2) {
                [JLAlert alertCustomView:weakSelf.privateKeyExportView maxWidth:kScreenWidth - 40.0f * 2];
            } else {
                JLExportKeystorePwdViewController *exportKeystorePwdVC = [[JLExportKeystorePwdViewController alloc] init];
                [weakSelf.navigationController pushViewController:exportKeystorePwdVC animated:YES];
            }
        };
    }
    return _walletPwdInputView;
}

- (JLPrivateKeyExportView *)privateKeyExportView {
    if (!_privateKeyExportView) {
        _privateKeyExportView = [[JLPrivateKeyExportView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth - 40.0f * 2, 270.0f)];
        ViewBorderRadius(_privateKeyExportView, 5.0f, 0.0f, JL_color_clear);
    }
    return _privateKeyExportView;
}
@end
