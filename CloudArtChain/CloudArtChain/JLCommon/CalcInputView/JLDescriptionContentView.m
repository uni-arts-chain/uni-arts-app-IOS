//
//  JLDescriptionContentView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLDescriptionContentView.h"

@interface JLDescriptionContentView ()<UITextViewDelegate>
@property (nonatomic, assign) NSInteger maxInput;
@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *inputNoticeLabel;
@property (nonatomic, strong) UILabel *maxInputLabel;
@end

@implementation JLDescriptionContentView
- (instancetype)initWithMax:(NSInteger)maxInput placeholder:(NSString *)placeholder {
    if (self = [super init]) {
        self.maxInput = maxInput;
        self.placeholder = placeholder;
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
        make.top.bottom.equalTo(self);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
    }];
    [self.maxInputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.mas_equalTo(-10.0f);
        make.height.mas_equalTo(28.0f);
    }];
    [self.inputNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8.0f);
        make.top.mas_equalTo(8.0f);
        make.right.mas_equalTo(-8.0f);
        make.bottom.equalTo(self.maxInputLabel.mas_top);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.0f);
        make.top.mas_equalTo(0.0f);
        make.right.mas_equalTo(-0.0f);
        make.bottom.equalTo(self.maxInputLabel.mas_top);
    }];

    [self.textView.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if (x.length > weakSelf.maxInput) {
            weakSelf.textView.text = [x substringToIndex:weakSelf.maxInput];
        }
        weakSelf.inputContent = weakSelf.textView.text;
        weakSelf.maxInputLabel.text = [NSString stringWithFormat:@"%ld/%ld", weakSelf.textView.text.length, weakSelf.maxInput];
        if (weakSelf.textView.text.length > 0) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:weakSelf.maxInputLabel.text];
            [attr addAttributes:@{NSForegroundColorAttributeName: JL_color_gray_101010} range:NSMakeRange(0, [weakSelf.maxInputLabel.text rangeOfString:@"/"].location)];
            weakSelf.maxInputLabel.attributedText = attr;
        } else {
            weakSelf.maxInputLabel.textColor = JL_color_gray_909090;
        }
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = JL_color_white_ffffff;
        ViewBorderRadius(_backView, 5.0f, 1.0f, JL_color_gray_DDDDDD);
    }
    return _backView;
}

- (UILabel *)inputNoticeLabel {
    if (!_inputNoticeLabel) {
        _inputNoticeLabel = [[UILabel alloc] init];
        _inputNoticeLabel.numberOfLines = 0;
        _inputNoticeLabel.font = kFontPingFangSCRegular(16.0f);
        _inputNoticeLabel.textColor = JL_color_gray_909090;
        _inputNoticeLabel.text = self.placeholder;
        _inputNoticeLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 10.0f;
        paragraph.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_inputNoticeLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _inputNoticeLabel.text.length)];
        _inputNoticeLabel.attributedText = attr;
    }
    return _inputNoticeLabel;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = kFontPingFangSCRegular(16.0f);
        _textView.textContainer.lineFragmentPadding = 10.0f;
        _textView.backgroundColor = JL_color_clear;
        _textView.delegate = self;
        _textView.textColor  = JL_color_gray_101010;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _textView;
}

#pragma mark textview 代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([textView isFirstResponder]) {
        self.inputNoticeLabel.hidden = (textView.text.length + (text.length - range.length) > 0);
        //限制 输入长度为300
        if (textView.text.length + (text.length - range.length) > self.maxInput) {
            return NO;
        }
        //判断键盘是不是九宫格键盘
        if ([JLTool isNineKeyBoard:text] ){
            return YES;
        }else{
            if ([JLTool hasEmoji:text] || [JLTool stringContainsEmoji:text]){
                return NO;
            }
        }
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
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
        _maxInputLabel.font = kFontPingFangSCRegular(14.0f);
        _maxInputLabel.textColor = JL_color_gray_909090;
        _maxInputLabel.text = [NSString stringWithFormat:@"0/%ld", self.maxInput];
    }
    return _maxInputLabel;
}

@end
