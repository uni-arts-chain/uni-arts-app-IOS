//
//  JLUploadWorkDescriptionView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/18.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLUploadWorkDescriptionView.h"

@interface JLUploadWorkDescriptionView ()<UITextViewDelegate>
@property (nonatomic, assign) NSInteger maxInput;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeHolderColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *inputNoticeLabel;
@property (nonatomic, strong) UILabel *maxInputLabel;
@end

@implementation JLUploadWorkDescriptionView
- (instancetype)initWithMax:(NSInteger)maxInput placeholder:(NSString *)placeholder placeHolderColor:(UIColor *)placeHolderColor textFont:(UIFont *)textFont textColor:(UIColor *)textColor borderColor:(UIColor *)borderColor {
    if (self = [super init]) {
        self.maxInput = maxInput;
        self.placeholder = placeholder;
        self.placeHolderColor = placeHolderColor ?: JL_color_gray_87888F;
        self.textFont = textFont ?: kFontPingFangSCRegular(12.0f);
        self.textColor = textColor ?: JL_color_black_101220;
        self.borderColor = borderColor;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    WS(weakSelf)
       
    [self addSubview:self.backView];
    [self.backView addSubview:self.inputNoticeLabel];
    [self.backView addSubview:self.textView];
    [self.backView addSubview:self.maxInputLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.top.equalTo(self).offset(7);
        make.bottom.equalTo(self);
    }];
    [self.maxInputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backView);
        make.right.equalTo(self.backView).offset(-10);
        make.height.mas_equalTo(34.0f);
    }];
    [self.inputNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(11);
        make.top.equalTo(self.backView).offset(11);
        make.right.equalTo(self.backView).offset(-11);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(2);
        make.left.right.equalTo(self.backView);
        make.bottom.equalTo(self.maxInputLabel.mas_top);
    }];

    [self.textView.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if (x.length > weakSelf.maxInput) {
            weakSelf.textView.text = [x substringToIndex:weakSelf.maxInput];
        }
        weakSelf.inputContent = weakSelf.textView.text;
        weakSelf.maxInputLabel.text = [NSString stringWithFormat:@"%lu/%ld", (unsigned long)weakSelf.textView.text.length, (long)weakSelf.maxInput];
        if (weakSelf.textView.text.length > 0) {
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
        _backView.backgroundColor = JL_color_white_ffffff;
        ViewBorderRadius(_backView, 8.0f, 1.0f, self.borderColor == nil ? JL_color_gray_B9B9B9 : self.borderColor);
    }
    return _backView;
}

- (UILabel *)inputNoticeLabel {
    if (!_inputNoticeLabel) {
        _inputNoticeLabel = [[UILabel alloc] init];
        _inputNoticeLabel.numberOfLines = 0;
        _inputNoticeLabel.font = self.textFont;
        _inputNoticeLabel.textColor = self.placeHolderColor;
        _inputNoticeLabel.text = self.placeholder;
        _inputNoticeLabel.textAlignment = NSTextAlignmentLeft;
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 10.0f;
        paragraph.alignment = NSTextAlignmentLeft;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_inputNoticeLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _inputNoticeLabel.text.length)];
        _inputNoticeLabel.attributedText = attr;
    }
    return _inputNoticeLabel;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = self.textFont;
        _textView.textContainer.lineFragmentPadding = 10.0f;
        _textView.backgroundColor = JL_color_clear;
        _textView.delegate = self;
        _textView.textColor  = self.textColor;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _textView;
}

#pragma mark textview 代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([textView isFirstResponder]) {
        self.inputNoticeLabel.hidden = (textView.text.length + (text.length - range.length) > 0);
        if (textView.text.length + (text.length - range.length) > self.maxInput) {
            return NO;
        }
        //判断键盘是不是九宫格键盘
        if ([JLTool isNineKeyBoard:text]) {
            return YES;
        } else {
            if ([JLTool hasEmoji:text] || [JLTool stringContainsEmoji:text]) {
                return NO;
            }
        }
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0 && [JLTool stringContainsEmoji:textView.text]) {
        // 禁止系统表情的输入
        NSString *text = [JLTool disable_emoji:[textView text]];
        if (![text isEqualToString:textView.text]) {
            NSRange textRange = [textView selectedRange];
            textView.text = text;
            [textView setSelectedRange:textRange];
        }
    }
}

- (UILabel *)maxInputLabel {
    if (!_maxInputLabel) {
        _maxInputLabel = [[UILabel alloc] init];
        _maxInputLabel.font = kFontPingFangSCRegular(12.0f);
        _maxInputLabel.textColor = JL_color_gray_87888F;
        _maxInputLabel.text = [NSString stringWithFormat:@"0/%ld", (long)self.maxInput];
    }
    return _maxInputLabel;
}
@end
