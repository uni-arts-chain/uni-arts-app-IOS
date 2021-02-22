//
//  JLApplyCertSelfSignCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLApplyCertSelfSignCell.h"

@interface JLApplyCertSelfSignCell ()
@property (nonatomic, strong) UIImageView *worksImageView;
@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *signTimeLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLApplyCertSelfSignCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.worksImageView];
    [self.contentView addSubview:self.maskImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.signTimeLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.lineView];
    
    [self.worksImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.width.mas_equalTo(102.0f);
        make.height.mas_equalTo(76.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.worksImageView.mas_right).offset(18.0f);
        make.top.equalTo(self.worksImageView.mas_top).offset(3.0f);
        make.size.mas_equalTo(14.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maskImageView.mas_right).offset(6.0f);
        make.centerY.equalTo(self.maskImageView.mas_centerY);
        make.right.mas_equalTo(-15.0f);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maskImageView);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(17.0f);
        make.height.mas_equalTo(12.0f);
        make.right.mas_equalTo(-54.0f);
    }];
    [self.signTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maskImageView);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(17.0f);
        make.height.mas_equalTo(12.0f);
        make.right.mas_equalTo(-54.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.0f);
        make.width.mas_equalTo(8.0f);
        make.height.mas_equalTo(15.0f);
        make.centerY.equalTo(self.contentView);
    }];
}

- (UIImageView *)worksImageView {
    if (!_worksImageView) {
        _worksImageView = [[UIImageView alloc] init];
        _worksImageView.backgroundColor = [UIColor randomColor];
        ViewBorderRadius(_worksImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _worksImageView;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] init];
        _maskImageView.image = [UIImage imageNamed:@"icon_applycert_works"];
    }
    return _maskImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [JLUIFactory labelInitText:@"金发夫人" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [JLUIFactory labelInitText:@"证书地址：0000001011101001001..." font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _addressLabel;
}

- (UILabel *)signTimeLabel {
    if (!_signTimeLabel) {
        _signTimeLabel = [JLUIFactory labelInitText:@"签名时间：2020/08/20 12:35:26" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _signTimeLabel;
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
