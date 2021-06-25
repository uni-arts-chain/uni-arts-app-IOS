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

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JLBaseTextField *inputTF;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) MASConstraint *inputTFWidthConstraint;
@end

@implementation JLUploadPersentInputView
- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.backgroundColor = JL_color_white_ffffff;
        self.title = title;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    WS(weakSelf)
    [self addSubview:self.leftLineView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.inputTF];
    [self addSubview:self.lineView];
    [self addSubview:self.unitLabel];
    [self addSubview:self.bottomLineView];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(14);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(4, 15));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(27);
        make.top.bottom.equalTo(self);
    }];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-13);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.unitLabel.mas_left).offset(-6);
        make.centerY.equalTo(self.titleLabel);
        self.inputTFWidthConstraint = make.width.mas_equalTo(25.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTF.mas_left);
        make.right.equalTo(self.inputTF.mas_right);
        make.top.equalTo(self.inputTF.mas_bottom);
        make.height.mas_equalTo(1.0f);
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(@1);
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
        
        CGFloat textW = [JLTool getAdaptionSizeWithText:weakSelf.inputTF.text labelHeight:54 font:kFontPingFangSCRegular(13)].width;
        if (textW > kScreenWidth - 220) {
            textW = kScreenWidth - 220;
        }
        [weakSelf.inputTFWidthConstraint uninstall];
        [weakSelf.inputTF mas_updateConstraints:^(MASConstraintMaker *make) {
            weakSelf.inputTFWidthConstraint = make.width.mas_equalTo(@(textW + 20));
        }];
    }];
}

- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] init];
        _leftLineView.backgroundColor = JL_color_mainColor;
        _leftLineView.layer.cornerRadius = 2;
    }
    return _leftLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:self.title font:kFontPingFangSCRegular(15.0f) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (JLBaseTextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[JLBaseTextField alloc]init];
        _inputTF.font = kFontPingFangSCRegular(13.0f);
        _inputTF.textColor = JL_color_gray_87888F;
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
        _lineView.backgroundColor = JL_color_gray_87888F;
    }
    return _lineView;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [JLUIFactory labelInitText:@"%" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentRight];
    }
    return _unitLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = JL_color_gray_EDEDEE;
    }
    return _bottomLineView;
}
@end
