//
//  JLBoxOpenRecordTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBoxOpenRecordTableViewCell.h"

@interface JLBoxOpenRecordTableViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UILabel *cardNameLabel;
@property (nonatomic, strong) UILabel *cardAuthorLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *priceTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@end

@implementation JLBoxOpenRecordTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.cardImageView];
    [self.backView addSubview:self.cardNameLabel];
    [self.backView addSubview:self.cardAuthorLabel];
    [self.backView addSubview:self.addressLabel];
    [self.backView addSubview:self.timeLabel];
    [self.backView addSubview:self.priceTitleLabel];
    [self.backView addSubview:self.priceLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(10.0f);
        make.bottom.mas_equalTo(-10.0f);
    }];
    [self.cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0f);
        make.top.mas_equalTo(16.0f);
        make.width.mas_equalTo(102.0f);
        make.height.mas_equalTo(76.0f);
    }];
    [self.cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardImageView.mas_top);
        make.left.equalTo(self.cardImageView.mas_right).offset(13.0f);
        make.right.mas_equalTo(-12.0f);
    }];
    [self.cardAuthorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardNameLabel.mas_left);
        make.centerY.equalTo(self.cardImageView.mas_centerY);
        make.right.equalTo(self.cardNameLabel.mas_right);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardNameLabel.mas_left);
        make.bottom.equalTo(self.cardImageView.mas_bottom);
        make.right.equalTo(self.cardNameLabel.mas_right);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardImageView.mas_left);
        make.bottom.equalTo(self.backView);
        make.height.mas_equalTo(43.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.0f);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
    }];
    [self.priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel.mas_left).offset(-12.0f);
        make.centerY.equalTo(self.priceLabel.mas_centerY);
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 10.0f, kScreenWidth - 15.0f * 2, 150.0f)];
        _backView.backgroundColor = JL_color_white_ffffff;
        [_backView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
    }
    return _backView;
}

- (UIImageView *)cardImageView {
    if (!_cardImageView) {
        _cardImageView = [[UIImageView alloc] init];
        _cardImageView.backgroundColor = [UIColor randomColor];
        ViewBorderRadius(_cardImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _cardImageView;
}

- (UILabel *)cardNameLabel {
    if (!_cardNameLabel) {
        _cardNameLabel = [JLUIFactory labelInitText:@"爱丽丝梦游仙境盲盒" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _cardNameLabel;
}

- (UILabel *)cardAuthorLabel {
    if (!_cardAuthorLabel) {
        _cardAuthorLabel = [JLUIFactory labelInitText:@"荒野猎人" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _cardAuthorLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [JLUIFactory labelInitText:@"NFT地址：646sked841dfooa" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        _addressLabel.numberOfLines = 1;
    }
    return _addressLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [JLUIFactory labelInitText:@"2020/08/16 12:36:28" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (UILabel *)priceTitleLabel {
    if (!_priceTitleLabel) {
        _priceTitleLabel = [JLUIFactory labelInitText:@"实付款：" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _priceTitleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"¥950" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentRight];
    }
    return _priceLabel;
}
@end