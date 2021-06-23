//
//  JLCalcInputView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCalcInputView.h"
#import "JLBaseTextField.h"

@interface JLCalcInputView()
@property (nonatomic, assign) NSInteger maxInput;
@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) JLBaseTextField *inputTF;
@property (nonatomic, strong) UILabel *maxInputLabel;
@end

@implementation JLCalcInputView
- (instancetype)initWithMaxInput:(NSInteger)maxInput placeholder:(NSString *)placeHolder content:(NSString *)content {
    if (self = [super init]) {
        self.maxInput = maxInput;
        self.placeholder = placeHolder;
        self.inputContent = content;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    WS(weakSelf)
    [self addSubview:self.inputTF];
    [self addSubview:self.maxInputLabel];
    
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(12.0f);
        make.right.equalTo(self).offset(-12.0f);
        make.bottom.equalTo(self).offset(-27.0f);
    }];
    [self.maxInputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self.inputTF);
        make.height.mas_equalTo(@27.0f);
    }];
    

    [self.inputTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.inputTF markedTextRange];
            UITextPosition *position = [weakSelf.inputTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                if (result.length > weakSelf.maxInput) {
                    weakSelf.inputTF.text = [result substringToIndex:weakSelf.maxInput];
                }
                weakSelf.inputContent = weakSelf.inputTF.text;
                weakSelf.maxInputLabel.text = [NSString stringWithFormat:@"%lu/%ld", (unsigned long)weakSelf.inputTF.text.length, (long)weakSelf.maxInput];
                if (weakSelf.inputTF.text.length > 0) {
                    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:weakSelf.maxInputLabel.text];
                    [attr addAttributes:@{NSForegroundColorAttributeName: JL_color_gray_101010} range:NSMakeRange(0, [weakSelf.maxInputLabel.text rangeOfString:@"/"].location)];
                    weakSelf.maxInputLabel.attributedText = attr;
                } else {
                    weakSelf.maxInputLabel.textColor = JL_color_gray_909090;
                }
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            if (result.length > weakSelf.maxInput) {
                weakSelf.inputTF.text = [result substringToIndex:weakSelf.maxInput];
            }
            weakSelf.inputContent = weakSelf.inputTF.text;
            weakSelf.maxInputLabel.text = [NSString stringWithFormat:@"%lu/%ld", (unsigned long)weakSelf.inputTF.text.length, (long)weakSelf.maxInput];
            if (weakSelf.inputTF.text.length > 0) {
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:weakSelf.maxInputLabel.text];
                [attr addAttributes:@{NSForegroundColorAttributeName: JL_color_gray_101010} range:NSMakeRange(0, [weakSelf.maxInputLabel.text rangeOfString:@"/"].location)];
                weakSelf.maxInputLabel.attributedText = attr;
            } else {
                weakSelf.maxInputLabel.textColor = JL_color_gray_909090;
            }
        }
    }];
}

- (JLBaseTextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[JLBaseTextField alloc]init];
        _inputTF.backgroundColor = JL_color_white_ffffff;
        _inputTF.textAlignment = NSTextAlignmentCenter;
        _inputTF.layer.cornerRadius = 8;
        _inputTF.font = kFontPingFangSCRegular(16.0f);
        _inputTF.textColor = JL_color_black_101220;
        _inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _inputTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _inputTF.spellCheckingType = UITextSpellCheckingTypeNo;
        NSDictionary *dic = @{NSForegroundColorAttributeName:JL_color_gray_87888F,NSFontAttributeName:kFontPingFangSCRegular(13.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:self.placeholder attributes:dic];
        _inputTF.attributedPlaceholder = attr;
        if (![NSString stringIsEmpty:self.inputContent]) {
            _inputTF.text = self.inputContent;
        }
    }
    return _inputTF;
}

- (UILabel *)maxInputLabel {
    if (!_maxInputLabel) {
        _maxInputLabel = [[UILabel alloc] init];
        _maxInputLabel.font = kFontPingFangSCRegular(13.0f);
        _maxInputLabel.textColor = JL_color_gray_87888F;
        _maxInputLabel.text = [NSString stringWithFormat:@"0/%ld", (long)self.maxInput];
        _maxInputLabel.textAlignment = NSTextAlignmentRight;
    }
    return _maxInputLabel;
}

@end
