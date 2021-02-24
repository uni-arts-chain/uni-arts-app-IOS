//
//  JLImportWalletMnemonicView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/4.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLImportWalletMnemonicView.h"
#import "JLBaseTextField.h"
#import "UIButton+TouchArea.h"

@interface JLImportWalletMnemonicView ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *mnemonicTextView;
@property (nonatomic, strong) JLBaseTextField *pwdTF;
@property (nonatomic, strong) JLBaseTextField *confirmTF;
@property (nonatomic, strong) JLBaseTextField *pwdNoticeTF;
@property (nonatomic, strong) UIView *protocolView;
@property (nonatomic, strong) UIButton *severButton;
@property (nonatomic, strong) UIButton *protocolButton;
@property (nonatomic, strong) UIButton *importBtn;
@property (nonatomic, strong) UIButton *mnemonicHelpBtn;
@end

@implementation JLImportWalletMnemonicView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    frame.size.height = self.mnemonicHelpBtn.frameBottom;
    self.frame = frame;
}

- (void)createSubViews {
    WS(weakSelf)
    [self addSubview:self.mnemonicTextView];
    [self.mnemonicTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(143.0f);
    }];
    
    [self addSubview:self.pwdTF];
    UIView *pwdLine = [self createLineView];
    [self addSubview:pwdLine];
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.mnemonicTextView.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
    }];
    [pwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdTF);
        make.top.equalTo(self.pwdTF.mas_bottom);
        make.height.mas_equalTo(1.0f);
        make.width.equalTo(self.pwdTF);
    }];
    
    [self addSubview:self.confirmTF];
    UIView *confirmPwdLine = [self createLineView];
    [self addSubview:confirmPwdLine];
    [self.confirmTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(pwdLine.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
    }];
    [confirmPwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmTF);
        make.top.equalTo(self.confirmTF.mas_bottom);
        make.height.mas_equalTo(1.0f);
        make.width.equalTo(self.confirmTF);
    }];
    
    [self addSubview:self.pwdNoticeTF];
    UIView *pwdNoticeLine = [self createLineView];
    [self addSubview:pwdNoticeLine];
    [self.pwdNoticeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(confirmPwdLine.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
    }];
    [pwdNoticeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdNoticeTF);
        make.top.equalTo(self.pwdNoticeTF.mas_bottom);
        make.height.mas_equalTo(1.0f);
        make.width.equalTo(self.pwdNoticeTF);
    }];
    
    [self addSubview:self.protocolView];
    [self.protocolView addSubview:self.severButton];
    [self.protocolView addSubview:self.protocolButton];
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(pwdNoticeLine.mas_bottom).offset(3.0f);
        make.height.mas_equalTo(52.0f);
        make.width.equalTo(self.pwdNoticeTF);
    }];
    [self.severButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.protocolView);
        make.centerY.equalTo(self.protocolView.mas_centerY);
        make.height.mas_equalTo(20.0f);
        make.width.mas_equalTo(170.0f);
    }];
    [self.protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.severButton.mas_right);
        make.centerY.equalTo(self.protocolView.mas_centerY);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self addSubview:self.importBtn];
    [self.importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.protocolView.mas_bottom);
        make.height.mas_equalTo(46.0f);
        make.width.equalTo(self.pwdNoticeTF);
    }];
    
    [self addSubview:self.mnemonicHelpBtn];
    [self.mnemonicHelpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.importBtn.mas_right);
        make.top.equalTo(self.importBtn.mas_bottom);
        make.height.mas_equalTo(48.0f);
    }];
    
    [self.mnemonicTextView.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.mnemonicTextView markedTextRange];
            UITextPosition *position = [weakSelf.mnemonicTextView positionFromPosition:selectedRange.start offset:0];
            if (!position) {
//                NSString *content = [JLUtils trimSpace:x];
                weakSelf.mnemonicTextView.text = x;
            }
        } else {
//            NSString *content = [JLUtils trimSpace:x];
            weakSelf.mnemonicTextView.text = x;
        }
    }];
    [self.pwdTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.pwdTF markedTextRange];
            UITextPosition *position = [weakSelf.pwdTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                if (result.length > 18) {
                    result = [result substringToIndex:18];
                }
                weakSelf.pwdTF.text = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            if (result.length > 18) {
                result = [result substringToIndex:18];
            }
            weakSelf.pwdTF.text = result;
        }
    }];
    [self.confirmTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.confirmTF markedTextRange];
            UITextPosition *position = [weakSelf.confirmTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                if (result.length > 18) {
                    result = [result substringToIndex:18];
                }
                weakSelf.confirmTF.text = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            if (result.length > 18) {
                result = [result substringToIndex:18];
            }
            weakSelf.confirmTF.text = result;
        }
    }];
    [self.pwdNoticeTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.pwdNoticeTF markedTextRange];
            UITextPosition *position = [weakSelf.pwdNoticeTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                if (result.length > 20) {
                    result = [result substringToIndex:20];
                }
                weakSelf.pwdNoticeTF.text = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            if (result.length > 20) {
                result = [result substringToIndex:20];
            }
            weakSelf.pwdNoticeTF.text = result;
        }
    }];
}

- (UITextView *)mnemonicTextView {
    if (!_mnemonicTextView) {
        _mnemonicTextView = [[UITextView alloc] init];
        _mnemonicTextView.textContainer.lineFragmentPadding = 13.0f;
        _mnemonicTextView.backgroundColor = JL_color_white_ffffff;
        _mnemonicTextView.delegate = self;
        _mnemonicTextView.placeholder = @"请输入助记词，按空格分隔";
        _mnemonicTextView.zw_placeHolder = @"请输入助记词，按空格分隔";
        _mnemonicTextView.zw_placeHolderColor = JL_color_gray_BBBBBB;
        _mnemonicTextView.textColor  = JL_color_gray_101010;
        _mnemonicTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _mnemonicTextView.font = kFontPingFangSCRegular(16.0f);
        _mnemonicTextView.textContainerInset = UIEdgeInsetsMake(13.0f, 0.0f, 13.0f, 0.0f);
        ViewBorderRadius(_mnemonicTextView, 5.0f, 1.0f, JL_color_gray_A4A4A4);
    }
    return _mnemonicTextView;
}

#pragma mark textview 代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([textView isFirstResponder]) {
        //判断键盘是不是九宫格键盘
        if ([JLTool isNineKeyBoard:text]) {
            return YES;
        } else {
            if ([JLTool hasEmoji:text] || [JLTool stringContainsEmoji:text]) {
                return NO;
            }
        }
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            return NO;
        }
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0 && [JLTool stringContainsEmoji:textView.text]) {
        // 禁止系统表情的输入
        NSString *text = [JLTool disable_emoji:[textView text]];
        if (![text isEqualToString:textView.text]) {
            NSRange textRange = [textView selectedRange];
            textView.text = text;
            [textView setSelectedRange:textRange];
        }
    }
}

- (JLBaseTextField *)pwdTF {
    if (!_pwdTF) {
        _pwdTF = [[JLBaseTextField alloc] init];
        _pwdTF.font = kFontPingFangSCRegular(16.0f);
        _pwdTF.textColor = JL_color_gray_212121;
        _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _pwdTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _pwdTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _pwdTF.secureTextEntry = YES;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_BBBBBB, NSFontAttributeName: kFontPingFangSCRegular(16.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"6-18位数字与字母组合密码" attributes:dic];
        _pwdTF.attributedPlaceholder = attr;
    }
    return _pwdTF;
}

- (JLBaseTextField *)confirmTF {
    if (!_confirmTF) {
        _confirmTF = [[JLBaseTextField alloc] init];
        _confirmTF.font = kFontPingFangSCRegular(16.0f);
        _confirmTF.textColor = JL_color_gray_212121;
        _confirmTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _confirmTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _confirmTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _confirmTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _confirmTF.secureTextEntry = YES;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_BBBBBB, NSFontAttributeName: kFontPingFangSCRegular(16.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"重复密码" attributes:dic];
        _confirmTF.attributedPlaceholder = attr;
    }
    return _confirmTF;
}

- (JLBaseTextField *)pwdNoticeTF {
    if (!_pwdNoticeTF) {
        _pwdNoticeTF = [[JLBaseTextField alloc] init];
        _pwdNoticeTF.font = kFontPingFangSCRegular(16.0f);
        _pwdNoticeTF.textColor = JL_color_gray_212121;
        _pwdNoticeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pwdNoticeTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _pwdNoticeTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _pwdNoticeTF.spellCheckingType = UITextSpellCheckingTypeNo;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_BBBBBB, NSFontAttributeName: kFontPingFangSCRegular(16.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"密码提示信息（可不填）" attributes:dic];
        _pwdNoticeTF.attributedPlaceholder = attr;
    }
    return _pwdNoticeTF;
}

- (UIView *)protocolView {
    if (!_protocolView) {
        _protocolView = [[UIView alloc] init];
    }
    return _protocolView;
}

- (UIButton *)importBtn {
    if (!_importBtn) {
        _importBtn = [JLUIFactory buttonInitTitle:@"开始导入" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_50C3FF font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(importBtnClick)];
        ViewBorderRadius(_importBtn, 23.0f, 0.0f, JL_color_clear);
    }
    return _importBtn;
}

- (void)importBtnClick {
    [self endEditing:YES];
    if ([NSString stringIsEmpty:self.mnemonicTextView.text]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入助记词" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if ([NSString stringIsEmpty:self.pwdTF.text]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入密码" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (self.pwdTF.text.length < 6) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"密码仅支持6-18位数字与字母组合" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (![JLUtils checkPasswordForNumAndLetter:self.pwdTF.text]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"密码仅支持6-18位数字与字母组合" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if ([NSString stringIsEmpty:self.confirmTF.text]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请再次输入密码" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (![self.pwdTF.text isEqualToString:self.confirmTF.text]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"两次密码输入不一致，请重新输入" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (!self.severButton.selected) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请先同意服务及隐私条款" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
}

- (UIButton *)mnemonicHelpBtn {
    if (!_mnemonicHelpBtn) {
        _mnemonicHelpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mnemonicHelpBtn setTitle:@"什么是助记词？" forState:UIControlStateNormal];
        [_mnemonicHelpBtn setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        _mnemonicHelpBtn.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_mnemonicHelpBtn addTarget:self action:@selector(mnemonicHelpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mnemonicHelpBtn;
}

- (void)mnemonicHelpBtnClick {
    
}

- (UIButton*)severButton {
    if (!_severButton) {
        _severButton = [[UIButton alloc] init];
        [_severButton setTitle:@"我已经仔细阅读并同意 " forState:UIControlStateNormal];
        _severButton.titleLabel.font = kFontPingFangSCRegular(14.0f);
        _severButton.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleLeftImageLeft;
        _severButton.axcUI_padding = 5.0f;
        [_severButton setTitleColor:JL_color_gray_909090 forState:UIControlStateNormal];
        [_severButton setImage:[UIImage imageNamed:@"icon_agree_normal"] forState:UIControlStateNormal];
        [_severButton setImage:[UIImage imageNamed:@"icon_agree_selected"] forState:UIControlStateSelected];
        _severButton.selected = YES;
        [_severButton edgeTouchAreaWithTop:5.0f right:0.0f bottom:10.0f left:10.0f];
        [_severButton addTarget:self action:@selector(severButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _severButton;
}

- (void)severButtonAction:(UIButton *)button {
    button.selected = !button.selected;
}

- (UIButton *)protocolButton {
    if (!_protocolButton) {
        _protocolButton = [[UIButton alloc] init];
        [_protocolButton setTitle:@"服务及隐私条款" forState:UIControlStateNormal];
        _protocolButton.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_protocolButton setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        _protocolButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_protocolButton edgeTouchAreaWithTop:5.0f right:10.0f bottom:10.0f left:0.0f];
        [_protocolButton addTarget:self action:@selector(termsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocolButton;
}

- (void)termsBtnClick {
//    JLServiceAgreementViewController *agreement = [[JLServiceAgreementViewController alloc] init];
//    [self.navigationController pushViewController:agreement animated:YES];
}

- (UIView *)createLineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = JL_color_gray_DDDDDD;
    return lineView;
}
@end
