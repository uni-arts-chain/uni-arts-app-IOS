//
//  JLMultiChainWalletImportContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletImportContentView.h"
#import "JLBaseTableView.h"
#import "JLBaseTextField.h"
#import "JLMultiChainWalletImportCell.h"
#import "JLMultiChainWalletImportFooterView.h"

@interface JLMultiChainWalletImportContentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *importTypeView;
@property (nonatomic, strong) UILabel *importTypeTitleLabel;
@property (nonatomic, strong) UIButton *importTypeBtn;
@property (nonatomic, strong) UIView *importTypeLineView;

@property (nonatomic, strong) UIView *walletNameView;
@property (nonatomic, strong) UILabel *walletNameLabel;
@property (nonatomic, strong) JLBaseTextField *textField;

@property (nonatomic, strong) UIImageView *tipImgView;
@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) JLBaseTableView *tableView;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *placeholderArray;

@property (nonatomic, copy) NSString *inputWalletName;
@property (nonatomic, copy) NSString *inputMnomenic;
@property (nonatomic, copy) NSString *inputPrivateKey;
@property (nonatomic, copy) NSString *inputKeystore;
@property (nonatomic, copy) NSString *inputPassword;

@end

@implementation JLMultiChainWalletImportContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _nextBtn.backgroundColor = JL_color_blue_50C3FF;
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = kFontPingFangSCRegular(17.0f);
    _nextBtn.layer.cornerRadius = 23;
    [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextBtn];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-(20 + KTouch_Responder_Height));
        make.height.mas_equalTo(@46);
    }];
    
    _tableView = [[JLBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = JL_color_white_ffffff;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:JLMultiChainWalletImportCell.class forCellReuseIdentifier:NSStringFromClass(JLMultiChainWalletImportCell.class)];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.nextBtn.mas_top).offset(-20);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    JLMultiChainWalletImportCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JLMultiChainWalletImportCell.class) forIndexPath:indexPath];
    if (!cell) {
        cell = [[JLMultiChainWalletImportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(JLMultiChainWalletImportCell.class)];
    }
    [cell setTitle:_titleArray[indexPath.row]
       placeholder:_placeholderArray[indexPath.row]
       defaultText:[self getDefaultInputText:indexPath]
             style:[self getCellStyle:indexPath]
          eidtType:[self getCellEditType:indexPath]];
    cell.editBlock = ^(NSString * _Nonnull inputText) {
        if (indexPath.row == 1 ||
            indexPath.row == 3) {
            weakSelf.inputWalletName = inputText;
        }else {
            weakSelf.inputPassword = inputText;
        }
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    WS(weakSelf)
    JLMultiChainWalletImportFooterView *footerView = [[JLMultiChainWalletImportFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    footerView.importType = _importType;
    footerView.changeTextBlock = ^(NSString * _Nonnull text) {
        if (weakSelf.importType == JLMultiChainImportTypeMnemonic) {
            weakSelf.inputMnomenic = text;
        }else if (weakSelf.importType == JLMultiChainImportTypePrivateKey) {
            weakSelf.inputPrivateKey = text;
        }
    };
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(chooseImportType)]) {
            [_delegate chooseImportType];
        }
    }else if (indexPath.row == 1 &&
              _importType == JLMultiChainImportTypeKeystore) {
        if (_delegate && [_delegate respondsToSelector:@selector(paste)]) {
            [_delegate paste];
        }
    }
}

#pragma mark - event response
- (void)nextBtnClick: (UIButton *)sender {
    if ([NSString stringIsEmpty:[JLUtils trimSpace:_inputWalletName]]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入钱包名" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (_importType == JLMultiChainImportTypeMnemonic) {
        if ([NSString stringIsEmpty:[JLUtils trimSpace:_inputMnomenic]]) {
            [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入助记词" hideTime:KToastDismissDelayTimeInterval];
            return;
        }
    }else if (_importType == JLMultiChainImportTypePrivateKey) {
        if ([NSString stringIsEmpty:[JLUtils trimSpace:_inputPrivateKey]]) {
            [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入私钥" hideTime:KToastDismissDelayTimeInterval];
            return;
        }else if (_importType == JLMultiChainImportTypeKeystore) {
            if ([NSString stringIsEmpty:[JLUtils trimSpace:_inputKeystore]]) {
                [[JLLoading sharedLoading] showMBFailedTipMessage:@"请粘贴或输入JSON文件" hideTime:KToastDismissDelayTimeInterval];
                return;
            }
            if ([NSString stringIsEmpty:[JLUtils trimSpace:_inputPassword]]) {
                [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入设置JSON的密码" hideTime:KToastDismissDelayTimeInterval];
                return;
            }
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(nextWithWalletName:mnonicArray:privateKey:keystore:keystorePassword:)]) {
        [_delegate nextWithWalletName:_inputWalletName
                          mnonicArray:[_inputMnomenic componentsSeparatedByString:@" "]
                           privateKey:_inputPrivateKey
                             keystore:_inputKeystore
                     keystorePassword:_inputPassword];
    }
}

#pragma mark - private methods
- (NSString *)getDefaultInputText: (NSIndexPath *)indexPath {
    NSString *defaultText = @"";
    if (_importType == JLMultiChainImportTypeKeystore) {
        if (indexPath.row == 1) {
            defaultText = _inputKeystore;
        }else if (indexPath.row == 2) {
            defaultText = _inputPassword;
        }else if (indexPath.row == 3) {
            defaultText = _inputWalletName;
        }
    }else {
        if (indexPath.row == 1) {
            defaultText = _inputWalletName;
        }
    }
    return defaultText;
}
- (JLMultiChainWalletImportCellStyle)getCellStyle: (NSIndexPath *)indexPath {
    JLMultiChainWalletImportCellStyle style = JLMultiChainWalletImportCellStyleDefault;
    if (indexPath.row == 0) {
        style = JLMultiChainWalletImportCellStyleDefault;
    }else if (indexPath.row == 1) {
        if (_importType == JLMultiChainImportTypeKeystore) {
            style = JLMultiChainWalletImportCellStylePaste;
        }else {
            style = JLMultiChainWalletImportCellStyleEdit;
        }
    }else {
        style = JLMultiChainWalletImportCellStyleEdit;
    }
    return style;
}
- (JLMultiChainWalletImportCellEditType)getCellEditType: (NSIndexPath *)indexPath {
    JLMultiChainWalletImportCellEditType editType = JLMultiChainWalletImportCellEditTypeWalletName;
    if (indexPath.row == 2) {
        editType = JLMultiChainWalletImportCellEditTypePassword;
    }else if (indexPath.row == 3) {
        editType = JLMultiChainWalletImportCellEditTypeWalletName;
    }
    return editType;
}

#pragma mark - setters and getters
- (void)setImportType:(JLMultiChainImportType)importType {
    _importType = importType;
    
    if (_importType == JLMultiChainImportTypeKeystore) {
        _titleArray = @[@"导入类型",@"JOSN文件",@"JOSN密码",@"钱包名称"];
        _placeholderArray = @[@"Keystore JSON",@"粘贴或输入JSON",@"设置JSON的密码",@"请输入钱包名"];
    }else if (_importType == JLMultiChainImportTypeMnemonic) {
        _titleArray = @[@"导入类型",@"钱包名称"];
        _placeholderArray = @[@"助记词",@"请输入钱包名"];
    }else if (_importType == JLMultiChainImportTypePrivateKey) {
        _titleArray = @[@"导入类型",@"钱包名称"];
        _placeholderArray = @[@"私钥",@"请输入钱包名"];
    }
    
    [_tableView reloadData];
}

- (void)setKeystore:(NSString *)keystore {
    _keystore = keystore;
    _inputKeystore = _keystore;
    
    [_tableView reloadData];
}

@end
