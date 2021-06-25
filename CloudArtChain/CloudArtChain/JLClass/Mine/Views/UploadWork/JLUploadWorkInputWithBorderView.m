//
//  JLUploadWorkInputWithBorderView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLUploadWorkInputWithBorderView.h"
#import "JLBaseTextField.h"

@interface JLUploadWorkInputWithBorderView ()
@property (nonatomic, assign) NSInteger maxInput;
@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) JLBaseTextField *inputTF;
@property (nonatomic, strong) UILabel *maxInputLabel;
@end

@implementation JLUploadWorkInputWithBorderView
- (instancetype)initWithMaxInput:(NSInteger)maxInput placeholder:(NSString *)placeHolder {
    if (self = [super init]) {
        self.backgroundColor = JL_color_white_ffffff;
        self.maxInput = maxInput;
        self.placeholder = placeHolder;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    WS(weakSelf)
    [self addSubview:self.backView];
    [self.backView addSubview:self.inputTF];
    [self.backView addSubview:self.maxInputLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0f);
        make.right.mas_equalTo(-12.0f);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.backView);
        make.left.equalTo(self.backView).offset(8);
        make.width.mas_greaterThanOrEqualTo(200.0f);
    }];
    [self.maxInputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.backView);
        make.right.equalTo(self.backView).offset(-8);
        make.left.equalTo(self.inputTF.mas_right).offset(15.0f);
    }];

    [self.inputTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if (x.length > weakSelf.maxInput) {
            weakSelf.inputTF.text = [x substringToIndex:weakSelf.maxInput];
        }
        weakSelf.inputContent = weakSelf.inputTF.text;
        weakSelf.maxInputLabel.text = [NSString stringWithFormat:@"%lu/%ld", (unsigned long)weakSelf.inputTF.text.length, (long)weakSelf.maxInput];
        if (weakSelf.inputTF.text.length > 0) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:weakSelf.maxInputLabel.text];
            [attr addAttributes:@{NSForegroundColorAttributeName: JL_color_black_101220} range:NSMakeRange(0, [weakSelf.maxInputLabel.text rangeOfString:@"/"].location)];
            weakSelf.maxInputLabel.attributedText = attr;
        } else {
            weakSelf.maxInputLabel.textColor = JL_color_gray_87888F;
        }
        if (weakSelf.inputContentChangeBlock) {
            weakSelf.inputContentChangeBlock();
        }
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        ViewBorderRadius(_backView, 8.0f, 1.0f, JL_color_gray_B9B9B9);
    }
    return _backView;
}

- (JLBaseTextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[JLBaseTextField alloc]init];
        _inputTF.font = kFontPingFangSCRegular(12.0f);
        _inputTF.textColor = JL_color_black_101220;
        _inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _inputTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _inputTF.spellCheckingType = UITextSpellCheckingTypeNo;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_87888F, NSFontAttributeName: kFontPingFangSCRegular(12.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dic];
        _inputTF.attributedPlaceholder = attr;
    }
    return _inputTF;
}

- (UILabel *)maxInputLabel {
    if (!_maxInputLabel) {
        _maxInputLabel = [[UILabel alloc] init];
        _maxInputLabel.font = kFontPingFangSCRegular(12.0f);
        _maxInputLabel.textColor = JL_color_gray_87888F;
        _maxInputLabel.text = [NSString stringWithFormat:@"0/%ld", (long)self.maxInput];
        _maxInputLabel.textAlignment = NSTextAlignmentRight;
    }
    return _maxInputLabel;
}
@end
