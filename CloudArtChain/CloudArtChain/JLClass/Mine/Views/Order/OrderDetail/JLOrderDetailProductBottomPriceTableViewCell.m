//
//  JLOrderDetailProductBottomPriceTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/4.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLOrderDetailProductBottomPriceTableViewCell.h"
#import "JLBaseTextField.h"

@interface JLOrderDetailProductBottomPriceTableViewCell ()
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *authorNameLabel;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *certifyAddressLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *noteTitleLabel;
@property (nonatomic, strong) JLBaseTextField *noteTextField;
@property (nonatomic, strong) UILabel *totalPriceTitleLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@end

@implementation JLOrderDetailProductBottomPriceTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.shadowView];
    [self.shadowView addSubview:self.shadowImageView];
    [self.shadowView addSubview:self.titleLabel];
    [self.shadowView addSubview:self.productImageView];
    [self.shadowView addSubview:self.authorNameLabel];
    [self.shadowView addSubview:self.productNameLabel];
    [self.shadowView addSubview:self.certifyAddressLabel];
    [self.shadowView addSubview:self.priceLabel];
    [self.shadowView addSubview:self.noteTitleLabel];
    [self.shadowView addSubview:self.noteTextField];
    [self.contentView addSubview:self.totalPriceTitleLabel];
    [self.contentView addSubview:self.totalPriceLabel];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(5.0f);
        make.bottom.mas_equalTo(-5.0f);
    }];
    [self.shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shadowView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0f);
        make.top.mas_equalTo(17.0f);
    }];
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(17.0f);
        make.width.mas_equalTo(102.0f);
        make.height.mas_equalTo(76.0f);
    }];
    [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(15.0f);
        make.top.equalTo(self.productImageView.mas_top);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13.0f);
        make.centerY.equalTo(self.authorNameLabel.mas_centerY);
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorNameLabel.mas_left);
        make.centerY.equalTo(self.productImageView.mas_centerY);
    }];
    [self.certifyAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorNameLabel.mas_left);
        make.bottom.equalTo(self.productImageView.mas_bottom);
    }];
    [self.noteTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_left);
        make.top.equalTo(self.productImageView.mas_bottom).offset(25.0f);
        make.width.mas_equalTo(80.0f);
    }];
    [self.noteTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.noteTitleLabel.mas_right);
        make.top.equalTo(self.productImageView.mas_bottom).offset(25.0f);
        make.right.mas_equalTo(-13.0f);
        make.bottom.mas_equalTo(-20.0f);
    }];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16.0f);
        make.top.equalTo(self.shadowView.mas_bottom).offset(20.0f);
    }];
    [self.totalPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.totalPriceLabel.mas_left).offset(-8.0f);
        make.top.equalTo(self.totalPriceLabel.mas_top);
    }];
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
    }
    return _shadowView;
}

- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [JLUIFactory imageViewInitImageName:@"icon_address_back"];
    }
    return _shadowImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"作品信息" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UIImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] init];
        _productImageView.backgroundColor = [UIColor randomColor];
        ViewBorderRadius(_productImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _productImageView;
}

- (UILabel *)authorNameLabel {
    if (!_authorNameLabel) {
        _authorNameLabel = [JLUIFactory labelInitText:@"伍静" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _authorNameLabel;
}

- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [JLUIFactory labelInitText:@"金葡萄" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _productNameLabel;
}

- (UILabel *)certifyAddressLabel {
    if (!_certifyAddressLabel) {
        _certifyAddressLabel = [JLUIFactory labelInitText:@"证书地址：00000010111..." font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentLeft];
    }
    return _certifyAddressLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"¥950" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentRight];
    }
    return _priceLabel;
}

- (UILabel *)noteTitleLabel {
    if (!_noteTitleLabel) {
        _noteTitleLabel = [JLUIFactory labelInitText:@"留言备注：" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _noteTitleLabel;
}

- (JLBaseTextField *)noteTextField {
    if (!_noteTextField) {
        _noteTextField = [[JLBaseTextField alloc]init];
        _noteTextField.font = kFontPingFangSCRegular(14.0f);
        _noteTextField.textColor = JL_color_gray_212121;
        _noteTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _noteTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _noteTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _noteTextField.spellCheckingType = UITextSpellCheckingTypeNo;
        NSDictionary *dic = @{NSForegroundColorAttributeName:JL_color_gray_BEBEBE,NSFontAttributeName:kFontPingFangSCRegular(14.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"如有特殊要求，请留言备注" attributes:dic];
        _noteTextField.attributedPlaceholder = attr;
    }
    return _noteTextField;
}

- (UILabel *)totalPriceTitleLabel {
    if (!_totalPriceTitleLabel) {
        _totalPriceTitleLabel = [JLUIFactory labelInitText:@"作品合计" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _totalPriceTitleLabel;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [JLUIFactory labelInitText:@"¥950" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentLeft];
    }
    return _totalPriceLabel;
}
@end
