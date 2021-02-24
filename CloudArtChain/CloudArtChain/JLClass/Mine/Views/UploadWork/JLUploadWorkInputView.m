//
//  JLUploadWorkInputView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/18.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLUploadWorkInputView.h"
#import "JLBaseTextField.h"

@interface JLUploadWorkInputView ()
@property (nonatomic, assign) NSInteger maxInput;
@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) JLBaseTextField *inputTF;
@property (nonatomic, strong) UILabel *maxInputLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLUploadWorkInputView
- (instancetype)initWithMaxInput:(NSInteger)maxInput placeholder:(NSString *)placeHolder {
    if (self = [super init]) {
        self.maxInput = maxInput;
        self.placeholder = placeHolder;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    WS(weakSelf)
    [self addSubview:self.inputTF];
    [self addSubview:self.maxInputLabel];
    [self addSubview:self.lineView];
    
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.mas_equalTo(15.0f);
        make.height.mas_equalTo(46.0f);
        make.width.mas_greaterThanOrEqualTo(200.0f);
    }];
    [self.maxInputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(42.0f);
        make.left.equalTo(self.inputTF.mas_right).offset(15.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];

    [self.inputTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if (x.length > weakSelf.maxInput) {
            weakSelf.inputTF.text = [x substringToIndex:weakSelf.maxInput];
        }
        weakSelf.inputContent = weakSelf.inputTF.text;
        weakSelf.maxInputLabel.text = [NSString stringWithFormat:@"%lu/%ld", (unsigned long)weakSelf.inputTF.text.length, (long)weakSelf.maxInput];
        if (weakSelf.inputTF.text.length > 0) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:weakSelf.maxInputLabel.text];
            [attr addAttributes:@{NSForegroundColorAttributeName: JL_color_gray_101010} range:NSMakeRange(0, [weakSelf.maxInputLabel.text rangeOfString:@"/"].location)];
            weakSelf.maxInputLabel.attributedText = attr;
        } else {
            weakSelf.maxInputLabel.textColor = JL_color_gray_BBBBBB;
        }
    }];
}

- (JLBaseTextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[JLBaseTextField alloc]init];
        _inputTF.font = kFontPingFangSCRegular(16.0f);
        _inputTF.textColor = JL_color_gray_101010;
        _inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _inputTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _inputTF.spellCheckingType = UITextSpellCheckingTypeNo;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_909090, NSFontAttributeName: kFontPingFangSCRegular(16.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dic];
        _inputTF.attributedPlaceholder = attr;
    }
    return _inputTF;
}

- (UILabel *)maxInputLabel {
    if (!_maxInputLabel) {
        _maxInputLabel = [[UILabel alloc] init];
        _maxInputLabel.font = kFontPingFangSCRegular(14.0f);
        _maxInputLabel.textColor = JL_color_gray_BBBBBB;
        _maxInputLabel.text = [NSString stringWithFormat:@"0/%ld", (long)self.maxInput];
        _maxInputLabel.textAlignment = NSTextAlignmentRight;
    }
    return _maxInputLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}
@end
