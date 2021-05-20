//
//  JLUploadPersentInputView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/5/19.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLUploadPersentInputView.h"
#import "JLBaseTextField.h"

@interface JLUploadPersentInputView()
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JLBaseTextField *inputTF;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *unitLabel;
@end

@implementation JLUploadPersentInputView
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
    [self addSubview:self.inputTF];
    [self addSubview:self.lineView];
    [self addSubview:self.unitLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(50.0f);
    }];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.unitLabel.mas_left);
        make.bottom.equalTo(self.titleLabel.mas_bottom);
        make.width.mas_equalTo(110.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTF.mas_left);
        make.right.equalTo(self.inputTF.mas_right);
        make.top.equalTo(self.inputTF.mas_bottom);
        make.height.mas_equalTo(1.0f);
    }];
    
    [self.inputTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.inputTF markedTextRange];
            UITextPosition *position = [weakSelf.inputTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                weakSelf.inputContent = result;
                weakSelf.inputTF.text = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            weakSelf.inputContent = result;
            weakSelf.inputTF.text = result;
        }
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:self.title font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (JLBaseTextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[JLBaseTextField alloc]init];
        _inputTF.font = kFontPingFangSCRegular(16.0f);
        _inputTF.textColor = JL_color_gray_101010;
        _inputTF.clearButtonMode = UITextFieldViewModeNever;
        _inputTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _inputTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _inputTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _inputTF.textAlignment = NSTextAlignmentCenter;
        _inputTF.keyboardType = UIKeyboardTypeNumberPad;
        _inputTF.textFieldType = TextFieldType_withdrawAmout;
    }
    return _inputTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_BEBEBE;
    }
    return _lineView;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [JLUIFactory labelInitText:@"%" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _unitLabel;
}
@end
