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
    [self addSubview:self.titleLabel];
    [self addSubview:self.inputTF];
    [self addSubview:self.lineView];
    [self addSubview:self.unitLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(20.0f);
        make.width.mas_equalTo(75.0f);
    }];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40.0f);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(16.0f);
        make.width.mas_equalTo(16.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right);
        make.right.equalTo(self.unitLabel.mas_left).offset(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lineView);
        make.bottom.equalTo(self.lineView.mas_top);
        make.top.equalTo(self);
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
    }
    return _inputTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [JLUIFactory labelInitText:@"元" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _unitLabel;
}
@end
