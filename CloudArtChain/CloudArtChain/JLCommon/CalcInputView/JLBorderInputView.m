//
//  JLBorderInputView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/3/3.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBorderInputView.h"
#import "JLBaseTextField.h"

@interface JLBorderInputView ()
@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) JLBaseTextField *inputTextFiled;
@end

@implementation JLBorderInputView
- (instancetype)initWithPlaceholder:(NSString *)placeholder content:(NSString *)content {
    if (self = [super init]) {
        self.placeholder = placeholder;
        self.inputContent = content;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    WS(weakSelf)
       
    [self addSubview:self.backView];
    [self.backView addSubview:self.inputTextFiled];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
    }];
    [self.inputTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView).insets(UIEdgeInsetsMake(0.0f, 12.0f, 0.0f, 12.0f));
    }];
    
    [self.inputTextFiled.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.inputTextFiled markedTextRange];
            UITextPosition *position = [weakSelf.inputTextFiled positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                weakSelf.inputTextFiled.text = result;
                weakSelf.inputContent = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            weakSelf.inputTextFiled.text = result;
            weakSelf.inputContent = result;
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

- (JLBaseTextField *)inputTextFiled {
    if (!_inputTextFiled) {
        _inputTextFiled = [[JLBaseTextField alloc] init];
        _inputTextFiled.font = kFontPingFangSCRegular(13.0f);
        _inputTextFiled.textColor = JL_color_gray_101010;
        _inputTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTextFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _inputTextFiled.autocorrectionType = UITextAutocorrectionTypeNo;
        _inputTextFiled.spellCheckingType = UITextSpellCheckingTypeNo;
        if (![NSString stringIsEmpty:self.inputContent]) {
            _inputTextFiled.text = self.inputContent;
        }
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_BBBBBB, NSFontAttributeName: kFontPingFangSCRegular(13.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dic];
        _inputTextFiled.attributedPlaceholder = attr;
    }
    return _inputTextFiled;
}

@end
