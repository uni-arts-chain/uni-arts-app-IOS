//
//  JLBoxTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/16.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBoxTableViewCell.h"

@interface JLBoxTableViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation JLBoxTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
}

- (void)createSubViews {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleImageView];
    [self.backView addSubview:self.bottomView];
    
    [self.bottomView addSubview:self.titleLabel];
    [self.bottomView addSubview:self.unitLabel];
    [self.bottomView addSubview:self.priceLabel];
    [self.bottomView addSubview:self.descLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.contentView).offset(8.0f);
        make.height.mas_equalTo(245.0f);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backView);
        make.left.mas_equalTo(13.0f);
        make.right.mas_equalTo(-13.0f);
        make.height.mas_equalTo(80.0f);
    }];
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.backView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bottomView);
        make.height.mas_offset(30.0f);
        make.width.mas_greaterThanOrEqualTo(200.0f);
    }];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.unitLabel.mas_left).offset(-4.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.titleLabel.mas_right).offset(16.0f);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.bottomView).offset(-12.0f);
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth - 15.0f * 2, 245.0f)];
        _backView.backgroundColor = JL_color_white_ffffff;
        [_backView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
    }
    return _backView;
}

- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth - 15.0f * 2, 165.0f)];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_titleImageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
    }
    return _titleImageView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"¥95" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentRight];
    }
    return _priceLabel;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [JLUIFactory labelInitText:@"/次" font:kFontPingFangSCRegular(11.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentRight];
    }
    return _unitLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentLeft];
    }
    return _descLabel;
}

- (void)setBoxData:(Model_blind_boxes_Data *)boxData {
    if (![NSString stringIsEmpty:boxData.app_img_path]) {
        [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:boxData.app_img_path]];
    } else {
        self.titleImageView.image = nil;
    }
    self.titleLabel.text = boxData.title;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:[NSString strToAttriWithStr:boxData.desc]];
    [attr addAttributes:@{NSFontAttributeName: kFontPingFangSCRegular(12.0f), NSForegroundColorAttributeName: JL_color_gray_999999} range:NSMakeRange(0, [NSString strToAttriWithStr: boxData.desc].length)];
    self.descLabel.attributedText = attr;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", boxData.price];
}

@end
