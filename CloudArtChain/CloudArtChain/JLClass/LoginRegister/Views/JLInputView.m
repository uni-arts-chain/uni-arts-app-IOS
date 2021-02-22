//
//  JLInputView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLInputView.h"
#import "JLBaseTextField.h"
#import "JLTimeButton.h"

@interface JLInputView ()
@property (nonatomic, strong) NSString *headImage;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) JLInputTrailType trailType;

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) JLBaseTextField *inputTF;
@property (nonatomic, strong) UIButton *showPwdBtn;
@property (nonatomic, strong) JLTimeButton *verifyCodeButton;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLInputView
- (instancetype)initWithHeadImage:(NSString *)headImage placeholder:(NSString *)placeholder trailType:(JLInputTrailType)trailType {
    if (self = [super init]) {
        self.headImage = headImage;
        self.placeholder = placeholder;
        self.trailType = trailType;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    WS(weakSelf)
    if (![NSString stringIsEmpty:self.headImage]) {
        [self addSubview:self.headerImageView];
    }
    [self addSubview:self.inputTF];
    if (self.trailType == JLInputTrailTypePwd) {
        [self addSubview:self.showPwdBtn];
    } else if (self.trailType == JLInputTrailTypeVerifyCode) {
        [self addSubview:self.verifyCodeButton];
    }
    [self addSubview:self.lineView];
    
    if (![NSString stringIsEmpty:self.headImage]) {
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.size.mas_equalTo(26.0f);
            make.centerY.equalTo(self);
        }];
    }
    
    CGFloat inputTFLeft = 0.0f;
    CGFloat inputTFRight = -0.0f;
    if (![NSString stringIsEmpty:self.headImage]) {
        inputTFLeft = 26.0f + 8.0f;
    }
    if (self.trailType == JLInputTrailTypePwd) {
        inputTFRight = - 26.0f - 8.0f;
    } else if (self.trailType == JLInputTrailTypeVerifyCode) {
        inputTFRight = -8.0f - 110.0f - 8.0f;
    }
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.mas_equalTo(inputTFLeft);
        make.right.mas_equalTo(inputTFRight);
    }];
    if (self.trailType == JLInputTrailTypePwd) {
        [self.showPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.size.mas_equalTo(26.0f);
            make.centerY.equalTo(self);
        }];
    } else if (self.trailType == JLInputTrailTypeVerifyCode) {
        [self.verifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8.0f);
            make.width.mas_equalTo(110.0f);
            make.height.mas_equalTo(32.0f);
            make.centerY.equalTo(self);
        }];
    }
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(1.0f);
    }];
    
    [self.inputTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.inputTF markedTextRange];
            UITextPosition *position = [weakSelf.inputTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                if (result.length > 18) {
                    result = [result substringToIndex:18];
                }
                weakSelf.inputTF.text = result;
                weakSelf.inputContent = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            if (result.length > 18) {
                result = [result substringToIndex:18];
            }
            weakSelf.inputTF.text = result;
            weakSelf.inputContent = result;
        }
    }];
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [JLUIFactory imageViewInitImageName:self.headImage];
    }
    return _headerImageView;
}

- (JLBaseTextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[JLBaseTextField alloc] init];
        _inputTF.font = kFontPingFangSCRegular(16.0f);
        _inputTF.textColor = JL_color_gray_101010;
        _inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _inputTF.secureTextEntry = (self.trailType == JLInputTrailTypePwd);
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_909090, NSFontAttributeName: kFontPingFangSCRegular(16.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dic];
        _inputTF.attributedPlaceholder = attr;
    }
    return _inputTF;
}

- (UIButton *)showPwdBtn {
    if (!_showPwdBtn) {
        _showPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPwdBtn setImage:[UIImage imageNamed:@"icon_pwd_show"] forState:UIControlStateNormal];
        [_showPwdBtn setImage:[UIImage imageNamed:@"icon_pwd_hidden"] forState:UIControlStateSelected];
        [_showPwdBtn addTarget:self action:@selector(showPwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPwdBtn;
}

- (void)showPwdBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.inputTF.secureTextEntry = !sender.selected;
}

- (JLTimeButton *)verifyCodeButton {
    if (!_verifyCodeButton) {
        _verifyCodeButton = [[JLTimeButton alloc] init];
        [_verifyCodeButton setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        [_verifyCodeButton setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateDisabled];
        _verifyCodeButton.titleLabel.font = kFontPingFangSCRegular(16.0f);
        [_verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verifyCodeButton addTarget:self action:@selector(verifyCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        ViewBorderRadius(_verifyCodeButton, 16.0f, 1.0f, JL_color_blue_38B2F1);
    }
    return _verifyCodeButton;
}

- (void)verifyCodeButtonClick:(JLTimeButton *)sender {
    [sender startCountDown];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}
@end
