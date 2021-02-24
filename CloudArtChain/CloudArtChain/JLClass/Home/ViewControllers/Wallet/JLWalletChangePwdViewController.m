//
//  JLWalletChangePwdViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/4.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWalletChangePwdViewController.h"
#import "JLBaseTextField.h"
#import "JLImportWalletViewController.h"

@interface JLWalletChangePwdViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *noticeView;
@property (nonatomic, strong) JLBaseTextField *currentPwdTF;
@property (nonatomic, strong) JLBaseTextField *newPwdTF;
@property (nonatomic, strong) JLBaseTextField *confirmNewPwdTF;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation JLWalletChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更改密码";
    [self addBackItem];
    [self addRightBarButton];
    [self createSubViews];
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
    if ([NSString stringIsEmpty:self.currentPwdTF.text]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请输入当前密码" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if ([NSString stringIsEmpty:self.newPwdTF.text] || self.newPwdTF.text.length < 6) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"密码仅支持6-18位数字与字母组合" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (![JLUtils checkPasswordForNumAndLetter:self.newPwdTF.text]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"密码仅支持6-18位数字与字母组合" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    if (![self.newPwdTF.text isEqualToString:self.confirmNewPwdTF.text]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"两次密码输入不一致，请重新输入" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSubViews {
    WS(weakSelf)
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.scrollView addSubview:self.noticeView];
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.scrollView);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.scrollView addSubview:self.currentPwdTF];
    UIView *currentPwdLine = [self createLineView];
    [self.scrollView addSubview:currentPwdLine];
    [self.currentPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.noticeView.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
    }];
    [currentPwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentPwdTF);
        make.top.equalTo(self.currentPwdTF.mas_bottom);
        make.height.mas_equalTo(1.0f);
        make.width.equalTo(self.currentPwdTF);
    }];
    
    [self.scrollView addSubview:self.newPwdTF];
    UIView *newPwdLine = [self createLineView];
    [self.scrollView addSubview:newPwdLine];
    [self.newPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(currentPwdLine.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
    }];
    [newPwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.newPwdTF);
        make.top.equalTo(self.newPwdTF.mas_bottom);
        make.height.mas_equalTo(1.0f);
        make.width.equalTo(self.newPwdTF);
    }];
    
    [self.scrollView addSubview:self.confirmNewPwdTF];
    UIView *confirmNewPwdLine = [self createLineView];
    [self.scrollView addSubview:confirmNewPwdLine];
    [self.confirmNewPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(newPwdLine.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(kScreenWidth - 15.0f * 2);
    }];
    [confirmNewPwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmNewPwdTF);
        make.top.equalTo(self.confirmNewPwdTF.mas_bottom);
        make.height.mas_equalTo(1.0f);
        make.width.equalTo(self.confirmNewPwdTF);
    }];
    
    [self.scrollView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmNewPwdLine);
        make.top.equalTo(confirmNewPwdLine.mas_bottom);
        make.height.mas_equalTo(62.0f);
        make.width.equalTo(confirmNewPwdLine);
    }];
    
    [self.currentPwdTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.currentPwdTF markedTextRange];
            UITextPosition *position = [weakSelf.currentPwdTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                if (result.length > 18) {
                    result = [result substringToIndex:18];
                }
                weakSelf.currentPwdTF.text = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            if (result.length > 18) {
                result = [result substringToIndex:18];
            }
            weakSelf.currentPwdTF.text = result;
        }
    }];
    [self.newPwdTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.newPwdTF markedTextRange];
            UITextPosition *position = [weakSelf.newPwdTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                if (result.length > 18) {
                    result = [result substringToIndex:18];
                }
                weakSelf.newPwdTF.text = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            if (result.length > 18) {
                result = [result substringToIndex:18];
            }
            weakSelf.newPwdTF.text = result;
        }
    }];
    [self.confirmNewPwdTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.confirmNewPwdTF markedTextRange];
            UITextPosition *position = [weakSelf.confirmNewPwdTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                if (result.length > 18) {
                    result = [result substringToIndex:18];
                }
                weakSelf.confirmNewPwdTF.text = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            if (result.length > 18) {
                result = [result substringToIndex:18];
            }
            weakSelf.confirmNewPwdTF.text = result;
        }
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.bottomView.frameBottom);
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = JL_color_white_ffffff;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)createLineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = JL_color_gray_DDDDDD;
    return lineView;
}

- (UIView *)noticeView {
    if (!_noticeView) {
        _noticeView = [[UIView alloc] init];
        _noticeView.backgroundColor = JL_color_white_ffffff;
        
        UIView *centerView = [[UIView alloc] init];
        centerView.backgroundColor = JL_color_blue_C7ECFF;
        ViewBorderRadius(centerView, 5.0f, 0.0f, JL_color_clear);
        [_noticeView addSubview:centerView];
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noticeView.mas_centerX);
            make.width.mas_lessThanOrEqualTo(kScreenWidth - 15.0f * 2);
            make.top.mas_equalTo(16.0f);
            make.bottom.mas_equalTo(-16.0f);
        }];
        
        UILabel *noticeLabel = [JLUIFactory labelInitText:@"密码提示信息：装很多东西" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_blue_165B7F textAlignment:NSTextAlignmentCenter];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 10.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:noticeLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, noticeLabel.text.length)];
        noticeLabel.attributedText = attr;
        [centerView addSubview:noticeLabel];
        
        [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12.0f);
            make.right.mas_equalTo(-12.0f);
            make.top.mas_equalTo(6.0f);
            make.bottom.mas_equalTo(-6.0f);
        }];
    }
    return _noticeView;
}

- (JLBaseTextField *)currentPwdTF {
    if (!_currentPwdTF) {
        _currentPwdTF = [[JLBaseTextField alloc] init];
        _currentPwdTF.font = kFontPingFangSCRegular(15.0f);
        _currentPwdTF.textColor = JL_color_gray_101010;
        _currentPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _currentPwdTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _currentPwdTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _currentPwdTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _currentPwdTF.secureTextEntry = YES;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_909090, NSFontAttributeName: kFontPingFangSCRegular(15.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"当前密码" attributes:dic];
        _currentPwdTF.attributedPlaceholder = attr;
    }
    return _currentPwdTF;
}

- (JLBaseTextField *)newPwdTF {
    if (!_newPwdTF) {
        _newPwdTF = [[JLBaseTextField alloc] init];
        _newPwdTF.font = kFontPingFangSCRegular(15.0f);
        _newPwdTF.textColor = JL_color_gray_101010;
        _newPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newPwdTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _newPwdTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _newPwdTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _newPwdTF.secureTextEntry = YES;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_909090, NSFontAttributeName: kFontPingFangSCRegular(15.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"6-18位数字与字母组合密码" attributes:dic];
        _newPwdTF.attributedPlaceholder = attr;
    }
    return _newPwdTF;
}

- (JLBaseTextField *)confirmNewPwdTF {
    if (!_confirmNewPwdTF) {
        _confirmNewPwdTF = [[JLBaseTextField alloc] init];
        _confirmNewPwdTF.font = kFontPingFangSCRegular(15.0f);
        _confirmNewPwdTF.textColor = JL_color_gray_101010;
        _confirmNewPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _confirmNewPwdTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _confirmNewPwdTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _confirmNewPwdTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _confirmNewPwdTF.secureTextEntry = YES;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_909090, NSFontAttributeName: kFontPingFangSCRegular(15.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"重复新密码" attributes:dic];
        _confirmNewPwdTF.attributedPlaceholder = attr;
    }
    return _confirmNewPwdTF;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        
        UILabel *noticeLabel = [JLUIFactory labelInitText:@"忘记密码？导入助记词或私钥可重置密码。" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
        [_bottomView addSubview:noticeLabel];
        [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_bottomView);
        }];
        
        UIButton *importBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [importBtn setTitle:@"马上导入" forState:UIControlStateNormal];
        [importBtn setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        importBtn.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [importBtn addTarget:self action:@selector(importBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:importBtn];
        [importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(noticeLabel.mas_right);
            make.top.bottom.equalTo(_bottomView);
        }];
    }
    return _bottomView;
}

- (void)importBtnClick {
    JLImportWalletViewController *importWalletVC = [[JLImportWalletViewController alloc] init];
    [self.navigationController pushViewController:importWalletVC animated:YES];
}
@end
