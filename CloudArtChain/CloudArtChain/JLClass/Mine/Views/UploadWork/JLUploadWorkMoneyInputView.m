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

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) JLBaseTextField *inputTF;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *unitLabel;
@end

@implementation JLUploadWorkMoneyInputView
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
    [self addSubview:self.priceLabel];
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
//        make.right.equalTo(self.unitLabel.mas_left);
        make.right.mas_equalTo(-15.0f);
        make.bottom.equalTo(self.titleLabel.mas_bottom);
        make.width.mas_equalTo(110.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTF.mas_left);
        make.right.equalTo(self.inputTF.mas_right);
        make.top.equalTo(self.inputTF.mas_bottom);
        make.height.mas_equalTo(1.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputTF.mas_left).offset(-8.0f);
        make.centerY.equalTo(self.inputTF.mas_centerY);
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
        if (weakSelf.inputContentChangeBlock) {
            weakSelf.inputContentChangeBlock();
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
        _inputTF.keyboardType = UIKeyboardTypeDecimalPad;
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
        _unitLabel = [JLUIFactory labelInitText:@"/份" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
        _unitLabel.hidden = YES;
    }
    return _unitLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"¥" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _priceLabel;
}

- (void)refreshWithTitle:(NSString *)title showUnit:(BOOL)showUnit {
    self.titleLabel.text = title;
    self.inputTF.text = @"";
    if (showUnit) {
        self.unitLabel.hidden = NO;
        [self.inputTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.unitLabel.mas_left);
            make.bottom.equalTo(self.titleLabel.mas_bottom);
            make.width.mas_equalTo(70.0f);
        }];
    } else {
        self.unitLabel.hidden = YES;
        [self.inputTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15.0f);
            make.bottom.equalTo(self.titleLabel.mas_bottom);
            make.width.mas_equalTo(110.0f);
        }];
    }
}

@end
