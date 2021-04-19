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
@property (nonatomic, strong) UIImageView *lineImageView;
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
    [self addSubview:self.lineImageView];
    [self addSubview:self.maxInputLabel];
    
    
    [self.maxInputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.mas_equalTo(-15.0f);
        make.centerY.equalTo(self.inputTF.mas_centerY);
    }];
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self.maxInputLabel.mas_bottom);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(0.5f);
    }];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self.lineImageView.mas_top);
        make.right.equalTo(self.maxInputLabel.mas_left).offset(-16.0f);
        make.height.mas_equalTo(50.0f);
        make.width.mas_greaterThanOrEqualTo(200.0f);
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
            weakSelf.maxInputLabel.textColor = JL_color_gray_909090;
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
        NSDictionary *dic = @{NSForegroundColorAttributeName:JL_color_gray_909090,NSFontAttributeName:kFontPingFangSCRegular(16.0f)};
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
        _maxInputLabel.font = kFontPingFangSCRegular(16.0f);
        _maxInputLabel.textColor = JL_color_gray_909090;
        _maxInputLabel.text = [NSString stringWithFormat:@"0/%ld", (long)self.maxInput];
        _maxInputLabel.textAlignment = NSTextAlignmentRight;
    }
    return _maxInputLabel;
}

- (UIImageView *)lineImageView {
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.image = [UIImage imageNamed:@"icon_calcinput_line"];
    }
    return _lineImageView;
}
@end
