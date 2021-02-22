//
//  JLApplyCertMechanismSignCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLApplyCertMechanismSignCell.h"

@interface JLApplyCertMechanismSignCell ()
@property (nonatomic, strong) UIImageView *mechanismImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timesLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation JLApplyCertMechanismSignCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.mechanismImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timesLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.arrowImageView];
    
    [self.mechanismImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.width.mas_equalTo(102.0f);
        make.height.mas_equalTo(76.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mechanismImageView.mas_right).offset(22.0f);
        make.top.equalTo(self.mechanismImageView.mas_top).offset(2.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.timesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(17.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.timesLabel.mas_bottom).offset(17.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.0f);
        make.width.mas_equalTo(8.0f);
        make.height.mas_equalTo(15.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self.contentView);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
}

- (UIImageView *)mechanismImageView {
    if (!_mechanismImageView) {
        _mechanismImageView = [[UIImageView alloc] init];
        _mechanismImageView.backgroundColor = [UIColor randomColor];
        ViewBorderRadius(_mechanismImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _mechanismImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [JLUIFactory labelInitText:@"南京艺术品鉴定机构" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)timesLabel {
    if (!_timesLabel) {
        _timesLabel = [JLUIFactory labelInitText:@"已签名：186次" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _timesLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"签名费用：￥99/次" font:kFontPingFangSCMedium(12.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentLeft];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_priceLabel.text];
        [attr addAttributes:@{NSFontAttributeName: kFontPingFangSCRegular(12.0f), NSForegroundColorAttributeName: JL_color_gray_212121} range:NSMakeRange(0, 5)];
        _priceLabel.attributedText = attr;
    }
    return _priceLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [JLUIFactory imageViewInitImageName:@"icon_applycert_arrowright"];
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

- (void)setIndex:(NSInteger)index total:(NSInteger)total {
    self.lineView.hidden = (index == total - 1);
}
@end
