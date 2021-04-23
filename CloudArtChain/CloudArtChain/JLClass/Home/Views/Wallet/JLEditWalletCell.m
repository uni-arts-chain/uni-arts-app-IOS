//
//  JLEditWalletCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/4.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLEditWalletCell.h"
#import "JLBaseTextField.h"
#import "UIButton+TouchArea.h"

@interface JLEditWalletCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) JLBaseTextField *editTF;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLEditWalletCell
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
    [self.contentView addSubview:self.statusView];
    [self.contentView addSubview:self.editTF];
    [self.statusView addSubview:self.statusLabel];
    [self.statusView addSubview:self.editBtn];
    [self.statusView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_lessThanOrEqualTo(150.0f);
    }];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.right.mas_equalTo(-15.0f);
        make.top.bottom.equalTo(self.contentView);
    }];
    [self.editTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.bottom.equalTo(self.contentView);
    }];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statusView).offset(-4.0f);
        make.size.mas_equalTo(13.0f);
        make.centerY.equalTo(self.statusView.mas_centerY);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editBtn.mas_left).offset(-7.0f);
        make.top.bottom.equalTo(self.statusView);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statusView).offset(-6.0f);
        make.width.mas_equalTo(8.0f);
        make.height.mas_equalTo(15.0f);
        make.centerY.equalTo(self.statusView.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self.contentView);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
    
    [self.editTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [weakSelf.editTF markedTextRange];
            UITextPosition *position = [weakSelf.editTF positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                NSString *result = [JLUtils trimSpace:x];
                if (result.length > 20) {
                    result = [result substringToIndex:20];
                }
                weakSelf.editTF.text = result;
                weakSelf.editContent = result;
            }
        } else {
            NSString *result = [JLUtils trimSpace:x];
            if (result.length > 20) {
                result = [result substringToIndex:20];
            }
            weakSelf.editTF.text = result;
            weakSelf.editContent = result;
        }
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (JLBaseTextField *)editTF {
    if (!_editTF) {
        _editTF = [[JLBaseTextField alloc] init];
        _editTF.font = kFontPingFangSCRegular(14.0f);
        _editTF.textColor = JL_color_gray_101010;
        _editTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _editTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _editTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _editTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _editTF.textAlignment = NSTextAlignmentRight;
        NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_909090, NSFontAttributeName: kFontPingFangSCRegular(14.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"请输入钱包名" attributes:dic];
        _editTF.attributedPlaceholder = attr;
        _editTF.hidden = YES;
        _editTF.delegate = self;
        [_editTF addTarget:self action:@selector(editTFEndEdit) forControlEvents:UIControlEventEditingDidEndOnExit];
    }
    return _editTF;
}

- (void)editTFEndEdit {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.statusLabel.text = self.editContent;
    self.statusView.hidden = NO;
    self.editTF.hidden = YES;
}

- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] init];
    }
    return _statusView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentRight];
    }
    return _statusLabel;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"icon_wallet_edit"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_editBtn edgeTouchAreaWithTop:20.0f right:20.0f bottom:20.0f left:20.0f];
    }
    return _editBtn;
}

- (void)editBtnClick {
    self.statusView.hidden = YES;
    self.editTF.hidden = NO;
    self.editTF.text = self.statusLabel.text;
    [self.editTF becomeFirstResponder];
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [JLUIFactory imageViewInitImageName:@"icon_wallet_edit_arrowright"];
    }
    return _arrowImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}

- (void)setIsEdit:(BOOL)isEdit {
    if (isEdit) {
        self.statusLabel.hidden = NO;
        self.editBtn.hidden = NO;
        self.arrowImageView.hidden = YES;
    } else {
        self.statusLabel.hidden = YES;
        self.editBtn.hidden = YES;
        self.arrowImageView.hidden = NO;
    }
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setStatusText:(NSString *)statusText {
    self.statusLabel.text = statusText;
}
@end
