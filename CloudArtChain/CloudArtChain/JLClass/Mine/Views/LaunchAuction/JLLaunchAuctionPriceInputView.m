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
@property (nonatomic, strong) MASConstraint *textFieldWidthConstraint;
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
        make.left.mas_equalTo(17.0f);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(bottomViewHeight);
    }];
    [self.startPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-17.0f);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(bottomViewHeight);
        self.textFieldWidthConstraint = make.width.mas_equalTo(70.0f);
    }];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.startPriceTF.mas_left).offset(-10.0f);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(bottomViewHeight);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.startPriceTF);
        make.bottom.equalTo(self).offset(-7.0f);
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
        
        if ([NSString stringIsEmpty:weakSelf.startPriceTF.text]) {
            CGFloat width = [JLTool getAdaptionSizeWithText:[NSString stringIsEmpty:weakSelf.placeholder] ? @"" : weakSelf.placeholder labelHeight:bottomViewHeight font:kFontPingFangSCRegular(16.0f)].width + 20;
            [weakSelf updateTextFieldConstraint:width];
        }else {
            CGFloat width = [JLTool getAdaptionSizeWithText:weakSelf.startPriceTF.text labelHeight:bottomViewHeight font:kFontPingFangSCRegular(16.0f)].width + 30;
            [weakSelf updateTextFieldConstraint:width];
        }
    }];
}

- (void)updateTextFieldConstraint: (CGFloat)width {
    if (width > 70) {
        if (width > kScreenWidth - 150) {
            width = kScreenWidth - 150;
        }
        [self.textFieldWidthConstraint uninstall];
        [self.startPriceTF mas_updateConstraints:^(MASConstraintMaker *make) {
            self.textFieldWidthConstraint = make.width.mas_equalTo(@(width));
        }];
    }else {
        [self.textFieldWidthConstraint uninstall];
        [self.startPriceTF mas_updateConstraints:^(MASConstraintMaker *make) {
            self.textFieldWidthConstraint = make.width.mas_equalTo(70.0f);
        }];
    }
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
        _startPriceTF.textAlignment = NSTextAlignmentCenter;
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
        _unitLabel = [JLUIFactory labelInitText:@"￥" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentRight];
    }
    return _unitLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_BEBEBE;
    }
    return _lineView;
}

- (void)setDefaultContent:(NSString *)content {
    if (![NSString stringIsEmpty:content]) {
        self.startPriceTF.text = content;
        self.inputContent = content;
        
        CGFloat width = [JLTool getAdaptionSizeWithText:self.startPriceTF.text labelHeight:40 font:kFontPingFangSCRegular(16.0f)].width + 30;
        [self updateTextFieldConstraint:width];
    }
}
@end
