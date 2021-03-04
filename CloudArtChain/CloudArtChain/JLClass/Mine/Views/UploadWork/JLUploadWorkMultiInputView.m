//
//  JLUploadWorkMultiInputView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/18.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLUploadWorkMultiInputView.h"
#import "JLBaseTextField.h"

@interface JLUploadWorkMultiInputView ()
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JLBaseTextField *firstTF;
@property (nonatomic, strong) UILabel *multiLabel;
@property (nonatomic, strong) JLBaseTextField *secondTF;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLUploadWorkMultiInputView
- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    WS(weakSelf)
    [self addSubview:self.titleLabel];
    [self addSubview:self.firstTF];
    [self addSubview:self.multiLabel];
    [self addSubview:self.secondTF];
    [self addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.bottom.equalTo(self);
    }];
    [self.secondTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-32.0f);
        make.width.mas_equalTo(54.0f);
        make.height.mas_equalTo(33.0f);
        make.centerY.equalTo(self);
    }];
    [self.multiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.secondTF.mas_left);
        make.width.mas_equalTo(32.0f);
        make.height.equalTo(self.secondTF);
        make.centerY.equalTo(self);
    }];
    [self.firstTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.multiLabel.mas_left);
        make.width.equalTo(self.secondTF);
        make.height.equalTo(self.secondTF);
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(15.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
    
    [self.firstTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.firstTF markedTextRange];
            UITextPosition *position = [weakSelf.firstTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                weakSelf.firstTF.text = result;
                weakSelf.firstInputContent = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            weakSelf.firstTF.text = result;
            weakSelf.firstInputContent = result;
        }
    }];
    [self.secondTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.secondTF markedTextRange];
            UITextPosition *position = [weakSelf.secondTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                weakSelf.secondTF.text = result;
                weakSelf.secondInputContent = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            weakSelf.secondTF.text = result;
            weakSelf.secondInputContent = result;
        }
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:self.title font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (JLBaseTextField *)firstTF {
    if (!_firstTF) {
        _firstTF = [[JLBaseTextField alloc]init];
        _firstTF.font = kFontPingFangSCRegular(16);
        _firstTF.textColor = JL_color_gray_101010;
        _firstTF.clearButtonMode = UITextFieldViewModeNever;
        _firstTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _firstTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _firstTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _firstTF.textAlignment = NSTextAlignmentCenter;
        _firstTF.keyboardType = UIKeyboardTypeDecimalPad;
        ViewBorderRadius(_firstTF, 5.0f, 1.0f, JL_color_gray_DDDDDD);
    }
    return _firstTF;
}

- (UILabel *)multiLabel {
    if (!_multiLabel) {
        _multiLabel = [JLUIFactory labelInitText:@"X" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentCenter];
    }
    return _multiLabel;
}

- (JLBaseTextField *)secondTF {
    if (!_secondTF) {
        _secondTF = [[JLBaseTextField alloc]init];
        _secondTF.font = kFontPingFangSCRegular(16);
        _secondTF.textColor = JL_color_gray_101010;
        _secondTF.clearButtonMode = UITextFieldViewModeNever;
        _secondTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _secondTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _secondTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _secondTF.textAlignment = NSTextAlignmentCenter;
        _secondTF.keyboardType = UIKeyboardTypeDecimalPad;
        ViewBorderRadius(_secondTF, 5.0f, 1.0f, JL_color_gray_DDDDDD);
    }
    return _secondTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}
@end
