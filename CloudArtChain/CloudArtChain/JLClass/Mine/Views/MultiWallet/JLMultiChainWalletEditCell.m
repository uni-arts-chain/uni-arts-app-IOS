//
//  JLMultiChainWalletEditCell.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletEditCell.h"
#import "JLBaseTextField.h"

@interface JLMultiChainWalletEditCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) JLBaseTextField *textField;
@property (nonatomic, strong) UIView *rightView;

@end

@implementation JLMultiChainWalletEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = JL_color_gray_101010;
    _titleLabel.font = kFontPingFangSCRegular(15.0f);
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    _arrowImgView = [[UIImageView alloc] init];
    _arrowImgView.image = [UIImage imageNamed:@"icon_applycert_arrowright"];
    [self.contentView addSubview:_arrowImgView];
    [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(@1);
    }];
    
    _textField = [[JLBaseTextField alloc] init];
    _textField.hidden = YES;
    _textField.font = kFontPingFangSCRegular(14.0f);
    _textField.textColor = JL_color_gray_101010;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.spellCheckingType = UITextSpellCheckingTypeNo;
    _textField.textAlignment = NSTextAlignmentRight;
    NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_909090, NSFontAttributeName: kFontPingFangSCRegular(14.0f)};
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"请输入钱包名" attributes:dic];
    _textField.attributedPlaceholder = attr;
    _textField.rightView = self.rightView;
    _textField.rightViewMode = UITextFieldViewModeUnlessEditing;
    _textField.rightView.userInteractionEnabled = NO;
    [_textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}

- (void)textFieldChange: (JLBaseTextField *)textField {
    if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            NSString *result = [JLUtils trimSpace:textField.text];
            if (result.length > 20) {
                result = [result substringToIndex:20];
            }
            textField.text = result;
            _walletName = textField.text;
        }
    } else {
        NSString *result = [JLUtils trimSpace:textField.text];
        if (result.length > 20) {
            result = [result substringToIndex:20];
        }
        textField.text = result;
        _walletName = textField.text;
    }
    
    if (_editWalletNameBlock) {
        _editWalletNameBlock(_walletName);
    }
}

#pragma mark - setters and getters
- (void)setStyle:(JLMultiChainWalletEditCellStyle)style {
    _style = style;
    
    _textField.hidden = YES;
    _arrowImgView.hidden = NO;
    if (_style == JLMultiChainWalletEditCellStyleEdit) {
        _textField.hidden = NO;
        _arrowImgView.hidden = YES;
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    _titleLabel.text = _title;
}

- (void)setWalletName:(NSString *)walletName {
    _walletName = walletName;
    
    _textField.text = _walletName;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 33)];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 13, 13)];
        imgView.image = [UIImage imageNamed:@"icon_wallet_edit"];
        [_rightView addSubview:imgView];
    }
    return _rightView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
