//
//  JLWorkListBaseTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWorkListBaseTableViewCell.h"

@interface JLWorkListBaseTableViewCell()
@property (nonatomic, strong) UIImageView *workImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLWorkListBaseTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.workImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.workImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(20.0f);
        make.bottom.mas_equalTo(-20.0f);
        make.width.mas_equalTo(102.0f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.workImageView.mas_right).offset(15.0f);
        make.top.equalTo(self.workImageView.mas_top);
        make.height.mas_equalTo(25.0f);
        make.right.mas_equalTo(-105.0f);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.workImageView.mas_right).offset(15.0f);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(25.0f);
        make.right.mas_equalTo(-105.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.workImageView.mas_right).offset(15.0f);
        make.top.equalTo(self.addressLabel.mas_bottom);
        make.height.mas_equalTo(25.0f);
        make.right.mas_equalTo(-105.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self.contentView);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
}

- (UIImageView *)workImageView {
    if (!_workImageView) {
        _workImageView = [[UIImageView alloc] init];
        ViewBorderRadius(_workImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _workImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFontPingFangSCMedium(15.0f);
        _titleLabel.textColor = JL_color_gray_212121;
    }
    return _titleLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = kFontPingFangSCRegular(12.0f);
        _addressLabel.textColor = JL_color_gray_212121;
        _addressLabel.text = @"证书地址:";
    }
    return _addressLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = kFontPingFangSCRegular(15.0f);
        _priceLabel.textColor = JL_color_gray_212121;
    }
    return _priceLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    _artDetailData = artDetailData;
    if (![NSString stringIsEmpty:artDetailData.img_main_file1[@"url"]]) {
        [self.workImageView sd_setImageWithURL:[NSURL URLWithString:artDetailData.img_main_file1[@"url"]]];
    }
    self.titleLabel.text = artDetailData.name;
    self.addressLabel.text = [NSString stringWithFormat:@"证书地址:%@", [NSString stringIsEmpty:artDetailData.item_hash] ? @"" : artDetailData.item_hash];
    self.priceLabel.text = [NSString stringWithFormat:@"%@ UART", artDetailData.price];
}
@end
