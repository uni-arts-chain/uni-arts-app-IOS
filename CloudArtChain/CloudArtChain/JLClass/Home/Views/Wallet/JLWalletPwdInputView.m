//
//  JLWalletPwdInputView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/4.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWalletPwdInputView.h"
#import "JLBaseTextField.h"

@interface JLWalletPwdInputView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *walletPwdView;
@property (nonatomic, strong) JLBaseTextField *walletPwdTF;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@end

@implementation JLWalletPwdInputView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    WS(weakSelf)
    [self addSubview:self.titleLabel];
    [self addSubview:self.walletPwdView];
    [self.walletPwdView addSubview:self.walletPwdTF];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.confirmBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(67.0f);
    }];
    [self.walletPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25.0f);
        make.right.mas_equalTo(-25.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7.0f);
        make.height.mas_equalTo(46.0f);
    }];
    [self.walletPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18.0f);
        make.right.mas_equalTo(-18.0f);
        make.top.bottom.equalTo(self.walletPwdView);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.walletPwdView);
        make.top.equalTo(self.walletPwdView.mas_bottom).offset(27.0f);
        make.height.mas_equalTo(40.0f);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.walletPwdView);
        make.top.equalTo(self.cancelBtn);
        make.left.equalTo(self.cancelBtn.mas_right).offset(24.0f);
        make.height.equalTo(self.cancelBtn);
        make.width.equalTo(self.cancelBtn);
    }];
    
    [self.walletPwdTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.walletPwdTF markedTextRange];
            UITextPosition *position = [weakSelf.walletPwdTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                weakSelf.walletPwdTF.text = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            weakSelf.walletPwdTF.text = result;
        }
    }];
    
    [self.walletPwdTF becomeFirstResponder];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"提示" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIView *)walletPwdView {
    if (!_walletPwdView) {
        _walletPwdView = [[UIView alloc] init];
        ViewBorderRadius(_walletPwdView, 5.0f, 1.0f, JL_color_gray_A4A4A4);
    }
    return _walletPwdView;
}

- (JLBaseTextField *)walletPwdTF {
    if (!_walletPwdTF) {
        _walletPwdTF = [[JLBaseTextField alloc]init];
        _walletPwdTF.font = kFontPingFangSCRegular(16.0f);
        _walletPwdTF.textColor = JL_color_gray_101010;
        _walletPwdTF.secureTextEntry = YES;
        _walletPwdTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_BBBBBB, NSFontAttributeName: kFontPingFangSCRegular(16.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"请输入钱包密码" attributes:dic];
        _walletPwdTF.attributedPlaceholder = attr;
    }
    return _walletPwdTF;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kFontPingFangSCRegular(16.0f);
        ViewBorderRadius(_cancelBtn, 20.0f, 1.0f, JL_color_blue_38B2F1);
        [_cancelBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = kFontPingFangSCRegular(16.0f);
        _confirmBtn.backgroundColor = JL_color_blue_38B2F1;
        ViewBorderRadius(_confirmBtn, 20.0f, 0.0f, JL_color_clear);
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (void)confirmBtnClick {
    [self endEditing:YES];
    if ([NSString stringIsEmpty:self.walletPwdTF.text]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入钱包密码" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    [self closeView];
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    self.walletPwdTF.text = @"";
}

- (void)closeView {
    [LEEAlert closeWithCompletionBlock:nil];
}
@end
