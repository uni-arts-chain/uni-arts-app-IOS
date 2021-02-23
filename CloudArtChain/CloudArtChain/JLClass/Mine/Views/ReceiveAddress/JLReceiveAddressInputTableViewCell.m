//
//  JLReceiveAddressInputTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/28.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLReceiveAddressInputTableViewCell.h"
#import "JLBaseTextField.h"

@interface JLReceiveAddressInputTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JLBaseTextField *inputTF;
@end

@implementation JLReceiveAddressInputTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    WS(weakSelf)
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.inputTF];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.width.mas_equalTo(90.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.right.mas_equalTo(-15.0f);
    }];
    
    [self.inputTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.inputTF markedTextRange];
            UITextPosition *position = [weakSelf.inputTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                weakSelf.inputTF.text = result;
                weakSelf.inputContent = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            weakSelf.inputTF.text = result;
            weakSelf.inputContent = result;
        }
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(16.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (JLBaseTextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[JLBaseTextField alloc] init];
        _inputTF.font = kFontPingFangSCRegular(15.0f);
        _inputTF.textColor = JL_color_gray_666666;
        _inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _inputTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _inputTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _inputTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _inputTF;
}

- (void)setTitle:(NSString *)title placeholder:(NSString *)placeholder {
    self.titleLabel.text = title;
    NSDictionary *dic = @{NSForegroundColorAttributeName : JL_color_gray_999999, NSFontAttributeName : kFontPingFangSCRegular(15.0f)};
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:placeholder attributes:dic];
    self.inputTF.attributedPlaceholder = attr;
}

@end
