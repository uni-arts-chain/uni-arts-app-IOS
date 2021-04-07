//
//  JLLaunchAuctionPriceInputView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/7.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLLaunchAuctionPriceInputView.h"
#import "JLBaseTextField.h"

@interface JLLaunchAuctionPriceInputView()
@property (nonatomic, strong) NSString *titleDesc;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) UIKeyboardType keyboardType;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JLBaseTextField *startPriceTF;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLLaunchAuctionPriceInputView
- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType {
    if (self = [super init]) {
        self.titleDesc = title;
        self.placeholder = placeholder;
        self.keyboardType = keyboardType;
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    WS(weakSelf)
    [self addSubview:self.titleLabel];
    [self addSubview:self.startPriceTF];
    [self addSubview:self.unitLabel];
    [self addSubview:self.lineView];
    
    CGFloat bottomViewHeight = 40.0f;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(bottomViewHeight);
    }];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.0f);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(bottomViewHeight);
    }];
    [self.startPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(bottomViewHeight);
        make.right.mas_equalTo(self.unitLabel.mas_left).offset(-12.0f);
        make.width.mas_greaterThanOrEqualTo(kScreenWidth - 85.0f - 70.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.startPriceTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.startPriceTF markedTextRange];
            UITextPosition *position = [weakSelf.startPriceTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                weakSelf.startPriceTF.text = result;
                weakSelf.inputContent = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            weakSelf.startPriceTF.text = result;
            weakSelf.inputContent = result;
        }
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:self.titleDesc font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (JLBaseTextField *)startPriceTF {
    if (!_startPriceTF) {
        _startPriceTF = [[JLBaseTextField alloc] init];
        _startPriceTF.font = kFontPingFangSCRegular(16.0f);
        _startPriceTF.textColor = JL_color_gray_212121;
        _startPriceTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _startPriceTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _startPriceTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _startPriceTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _startPriceTF.keyboardType = self.keyboardType;
        _startPriceTF.textAlignment = NSTextAlignmentRight;
        if (![NSString stringIsEmpty:self.placeholder]) {
            NSDictionary *dic = @{NSForegroundColorAttributeName:JL_color_gray_BBBBBB, NSFontAttributeName:kFontPingFangSCRegular(16.0f)};
            NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dic];
            _startPriceTF.attributedPlaceholder = attr;
        }
    }
    return _startPriceTF;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [JLUIFactory labelInitText:@"UART" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentRight];
    }
    return _unitLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}

- (void)setDefaultContent:(NSString *)content {
    if (![NSString stringIsEmpty:content]) {
        self.startPriceTF.text = content;
        self.inputContent = content;
    }
}
@end
