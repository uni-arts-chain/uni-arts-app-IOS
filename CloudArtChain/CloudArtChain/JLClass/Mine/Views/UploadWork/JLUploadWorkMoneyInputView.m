//
//  JLUploadWorkMoneyInputView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/18.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLUploadWorkMoneyInputView.h"
#import "JLBaseTextField.h"

@interface JLUploadWorkMoneyInputView ()
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) JLBaseTextField *inputTF;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) MASConstraint *inputTFWidthConstraint;
@end

@implementation JLUploadWorkMoneyInputView
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
    [self addSubview:self.priceLabel];
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
//        make.right.equalTo(self.unitLabel.mas_left);
        make.right.mas_equalTo(-12.0f);
        make.top.bottom.equalTo(self);
        self.inputTFWidthConstraint = make.width.mas_equalTo(25.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTF.mas_left);
        make.right.equalTo(self.inputTF.mas_right);
        make.bottom.equalTo(self).offset(-17);
        make.height.mas_equalTo(1.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputTF.mas_left).offset(-6.0f);
        make.centerY.equalTo(self.inputTF.mas_centerY);
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
                NSRange range = [result rangeOfString:@"."];
                if (range.location == NSNotFound) {
                    if ([NSString stringIsEmpty:result]) {
                        weakSelf.inputTF.text = result;
                        weakSelf.inputContent = result;
                    } else {
                        NSDecimalNumber *resultNumber = [[NSDecimalNumber decimalNumberWithString:result] roundDownScale:2];
                        weakSelf.inputTF.text = resultNumber.stringValue;
                        weakSelf.inputContent = resultNumber.stringValue;
                    }
                } else {
                    if (range.location == result.length - 1) {
                        weakSelf.inputTF.text = result;
                        weakSelf.inputContent = result;
                    } else {
                        if ([NSString stringIsEmpty:result]) {
                            weakSelf.inputTF.text = result;
                            weakSelf.inputContent = result;
                        } else {
                            NSString *last = [result substringFromIndex:result.length - 1];
                            if ([last isEqualToString:@"0"]) {
                                weakSelf.inputTF.text = result;
                                weakSelf.inputContent = result;
                            } else {
                                NSDecimalNumber *resultNumber = [[NSDecimalNumber decimalNumberWithString:result] roundDownScale:2];
                                weakSelf.inputTF.text = resultNumber.stringValue;
                                weakSelf.inputContent = resultNumber.stringValue;
                            }
                        }
                    }
                }
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            NSRange range = [result rangeOfString:@"."];
            if (range.location == NSNotFound) {
                if ([NSString stringIsEmpty:result]) {
                    weakSelf.inputTF.text = result;
                    weakSelf.inputContent = result;
                } else {
                    NSDecimalNumber *resultNumber = [[NSDecimalNumber decimalNumberWithString:result] roundDownScale:2];
                    weakSelf.inputTF.text = resultNumber.stringValue;
                    weakSelf.inputContent = resultNumber.stringValue;
                }
            } else {
                if (range.location == result.length - 1) {
                    weakSelf.inputTF.text = result;
                    weakSelf.inputContent = result;
                } else {
                    if ([NSString stringIsEmpty:result]) {
                        weakSelf.inputTF.text = result;
                        weakSelf.inputContent = result;
                    } else {
                        NSString *last = [result substringFromIndex:result.length - 1];
                        if ([last isEqualToString:@"0"]) {
                            weakSelf.inputTF.text = result;
                            weakSelf.inputContent = result;
                        } else {
                            NSDecimalNumber *resultNumber = [[NSDecimalNumber decimalNumberWithString:result] roundDownScale:2];
                            weakSelf.inputTF.text = resultNumber.stringValue;
                            weakSelf.inputContent = resultNumber.stringValue;
                        }
                    }
                }
            }
        }
        
        CGFloat textW = [JLTool getAdaptionSizeWithText:weakSelf.inputTF.text labelHeight:54 font:kFontPingFangSCRegular(13)].width;
        if (textW > kScreenWidth - 220) {
            textW = kScreenWidth - 220;
        }
        [weakSelf.inputTFWidthConstraint uninstall];
        [weakSelf.inputTF mas_updateConstraints:^(MASConstraintMaker *make) {
            weakSelf.inputTFWidthConstraint = make.width.mas_equalTo(@(textW + 20));
        }];
        
        if (weakSelf.inputContentChangeBlock) {
            weakSelf.inputContentChangeBlock();
        }
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
        _titleLabel = [JLUIFactory labelInitText:self.title font:kFontPingFangSCRegular(16.0f) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentLeft];
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
        _inputTF.keyboardType = UIKeyboardTypeDecimalPad;
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
        _unitLabel = [JLUIFactory labelInitText:@"/份" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentRight];
        _unitLabel.hidden = YES;
    }
    return _unitLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"¥" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_87888F textAlignment:NSTextAlignmentLeft];
    }
    return _priceLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = JL_color_gray_EDEDEE;
    }
    return _bottomLineView;
}

- (void)setIsSecondLevelView:(BOOL)isSecondLevelView {
    _isSecondLevelView = isSecondLevelView;
    
    if (_isSecondLevelView) {
        self.leftLineView.hidden = YES;
        self.titleLabel.font = kFontPingFangSCRegular(13);
    }else {
        self.leftLineView.hidden = NO;
    }
}

- (void)refreshWithTitle:(NSString *)title showUnit:(BOOL)showUnit {
    self.titleLabel.text = title;
    self.inputTF.text = @"";
    if (showUnit) {
        self.unitLabel.hidden = NO;
        [self.inputTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.unitLabel.mas_left).offset(-6);
            make.centerY.equalTo(self.titleLabel);
            self.inputTFWidthConstraint = make.width.mas_equalTo(25.0f);
        }];
    } else {
        self.unitLabel.hidden = YES;
        [self.inputTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12.0f);
            make.centerY.equalTo(self.titleLabel);
            self.inputTFWidthConstraint = make.width.mas_equalTo(25.0f);
        }];
    }
}

@end
