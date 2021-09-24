//
//  JLMultiChainWalletImportCell.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletImportCell.h"

@interface JLMultiChainWalletImportCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UILabel *importTypeLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, assign) JLMultiChainWalletImportCellStyle style;
@property (nonatomic, assign) JLMultiChainWalletImportCellEditType editType;

@end

@implementation JLMultiChainWalletImportCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = JL_color_gray_101010;
    _titleLabel.font = kFontPingFangSCRegular(16);
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    _arrowImgView = [[UIImageView alloc] init];
    _arrowImgView.image = [UIImage imageNamed:@"icon_wallet_import_arrow"];
    [self.contentView addSubview:_arrowImgView];
    [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(10, 6));
    }];
    
    _importTypeLabel = [[UILabel alloc] init];
    _importTypeLabel.textColor = JL_color_gray_101010;
    _importTypeLabel.font = kFontPingFangSCRegular(16);
    _importTypeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_importTypeLabel];
    [_importTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImgView.mas_left).offset(-10);
        make.centerY.equalTo(self.arrowImgView);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(@1);
    }];
    
    _rightLabel = [[UILabel alloc] init];
    _rightLabel.hidden = YES;
    _rightLabel.textColor = JL_color_gray_909090;
    _rightLabel.font = kFontPingFangSCRegular(14.0f);
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.contentView addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(130);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
    
    _textField = [[UITextField alloc] init];
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
    [_textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}

#pragma mark - event response
- (void)textFieldChange: (UITextField *)textField {
    if ([[UIApplication sharedApplication].textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            NSString *result = [JLUtils trimSpace:textField.text];
            if (_editType == JLMultiChainWalletImportCellEditTypeWalletName &&
                result.length > 20) {
                result = [result substringToIndex:20];
            }
            textField.text = result;
        }
    } else {
        NSString *result = [JLUtils trimSpace:textField.text];
        if (_editType == JLMultiChainWalletImportCellEditTypeWalletName &&
            result.length > 20) {
            result = [result substringToIndex:20];
        }
        textField.text = result;
    }
    
    if (_editBlock) {
        _editBlock(textField.text);
    }
}

#pragma mark - public methods
- (void)setTitle: (NSString *)title placeholder: (NSString *)placeholder defaultText: (NSString *)defaultText style: (JLMultiChainWalletImportCellStyle)style eidtType: (JLMultiChainWalletImportCellEditType)editType {
    _style = style;
    _editType = editType;
    
    _titleLabel.text = title;
    if (_style == JLMultiChainWalletImportCellStyleEdit) {
        _textField.hidden = NO;
        _importTypeLabel.hidden = YES;
        _arrowImgView.hidden = YES;
        _rightLabel.hidden = YES;
        if (![NSString stringIsEmpty:placeholder]) {
            NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_909090, NSFontAttributeName: kFontPingFangSCRegular(14.0f)};
            NSAttributedString *attr = [[NSAttributedString alloc] initWithString:placeholder attributes:dic];
            _textField.attributedPlaceholder = attr;
        }
    }else if (_style == JLMultiChainWalletImportCellStylePaste) {
        _textField.hidden = YES;
        _importTypeLabel.hidden = YES;
        _arrowImgView.hidden = YES;
        _rightLabel.hidden = NO;
        
        _rightLabel.text = placeholder;
    }else {
        _textField.hidden = YES;
        _importTypeLabel.hidden = NO;
        _arrowImgView.hidden = NO;
        _rightLabel.hidden = YES;
        _importTypeLabel.text = placeholder;
    }
    
    if (![NSString stringIsEmpty:defaultText]) {
        _textField.text = defaultText;
        _rightLabel.text = defaultText;
        
        _rightLabel.textColor = JL_color_gray_101010;
    }
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
