//
//  JLMultiChainWalletEditContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletEditContentView.h"
#import "JLBaseTableView.h"
#import "JLMultiChainWalletEditCell.h"

@interface JLMultiChainWalletEditContentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) JLBaseTableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIButton *backupsMnemonicBtn;
@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSString *walletName;

@end

@implementation JLMultiChainWalletEditContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _saveBtn.backgroundColor = JL_color_blue_50C3FF;
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = kFontPingFangSCRegular(17.0f);
    _saveBtn.layer.cornerRadius = 23;
    [_saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveBtn];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-(60 + KTouch_Responder_Height));
        make.height.mas_equalTo(@46);
    }];
    
    _backupsMnemonicBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_backupsMnemonicBtn setTitle:@"备份助记词" forState:UIControlStateNormal];
    [_backupsMnemonicBtn setTitleColor:JL_color_blue_50C3FF forState:UIControlStateNormal];
    _backupsMnemonicBtn.titleLabel.font = kFontPingFangSCRegular(17.0f);
    [_backupsMnemonicBtn setImage:[[UIImage imageNamed:@"icon_wallet_export"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    _backupsMnemonicBtn.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleCenterImageRight;
    _backupsMnemonicBtn.axcUI_padding = 28.0f;
    [_backupsMnemonicBtn addTarget:self action:@selector(backupsMnemonicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backupsMnemonicBtn];
    [_backupsMnemonicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.saveBtn);
        make.bottom.equalTo(self.saveBtn.mas_top);
        make.height.mas_equalTo(@50);
    }];
    
    _tableView = [[JLBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = JL_color_white_ffffff;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = self.tableHeaderView;
    [_tableView registerClass:JLMultiChainWalletEditCell.class forCellReuseIdentifier:NSStringFromClass(JLMultiChainWalletEditCell.class)];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.backupsMnemonicBtn.mas_top);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    JLMultiChainWalletEditCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JLMultiChainWalletEditCell.class) forIndexPath:indexPath];
    if (!cell) {
        cell = [[JLMultiChainWalletEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(JLMultiChainWalletEditCell.class)];
    }
    if (indexPath.row == 0) {
        cell.style = JLMultiChainWalletEditCellStyleEdit;
    }else {
        cell.style = JLMultiChainWalletEditCellStyleDefault;
    }
    cell.title = self.titleArray[indexPath.row];
    cell.walletName = _walletName;
    cell.editWalletNameBlock = ^(NSString * _Nonnull walletName) {
        weakSelf.walletName = walletName;
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 1) {
        if (_delegate && [_delegate respondsToSelector:@selector(changePinCode)]) {
            [_delegate changePinCode];
        }
    }else if (indexPath.row == 2) {
        if (_delegate && [_delegate respondsToSelector:@selector(exportPrivateKey)]) {
            [_delegate exportPrivateKey];
        }
    }else if (indexPath.row == 3) {
        if (_delegate && [_delegate respondsToSelector:@selector(exportKeystore)]) {
            [_delegate exportKeystore];
        }
    }else if (indexPath.row == 4) {
        if (_delegate && [_delegate respondsToSelector:@selector(privateProtocol)]) {
            [_delegate privateProtocol];
        }
    }
}

#pragma mark - event response
- (void)backupsMnemonicBtnClick: (UIButton *)sender {
    [_tableView endEditing: YES];
    if (_delegate && [_delegate respondsToSelector:@selector(backupsMnemonic)]) {
        [_delegate backupsMnemonic];
    }
}

- (void)saveBtnClick: (UIButton *)sender {
    if ([NSString stringIsEmpty:_walletName]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入钱包名" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    [_tableView endEditing: YES];
    if (_delegate && [_delegate respondsToSelector:@selector(saveWalletName:)]) {
        [_delegate saveWalletName:_walletName];
    }
}

#pragma mark - setters and getters
- (void)setWalletInfo:(JLMultiWalletInfo *)walletInfo {
    _walletInfo = walletInfo;
    
    _walletName = _walletInfo.walletName;
    [_tableView reloadData];
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
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"钱包名",@"修改密码",@"导出私钥",@"导出Keystore",@"隐私协议"];
    }
    return _titleArray;
}

@end
