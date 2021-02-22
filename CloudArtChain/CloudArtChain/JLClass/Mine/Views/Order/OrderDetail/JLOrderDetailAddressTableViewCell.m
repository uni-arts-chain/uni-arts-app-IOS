//
//  JLOrderDetailAddressTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/28.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLOrderDetailAddressTableViewCell.h"

@interface JLOrderDetailAddressTableViewCell ()
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIImageView *addressMaskImageView;
@property (nonatomic, strong) UILabel *addressLabel;
@end

@implementation JLOrderDetailAddressTableViewCell
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
    [self.shadowView addSubview:self.nameLabel];
    [self.shadowView addSubview:self.phoneLabel];
    [self.shadowView addSubview:self.addressMaskImageView];
    [self.shadowView addSubview:self.addressLabel];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(5.0f);
        make.bottom.mas_equalTo(-5.0f);
    }];
    [self.shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shadowView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(20.0f);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(15.0f);
        make.bottom.equalTo(self.nameLabel.mas_bottom);
    }];
    [self.addressMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(20.0f);
        make.width.mas_equalTo(12.0f);
        make.height.mas_equalTo(14.0f);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressMaskImageView.mas_right).offset(15.0f);
        make.top.equalTo(self.addressMaskImageView.mas_top).offset(-3.0f);
        make.right.mas_equalTo(-15.0f);
        make.bottom.mas_equalTo(-20.0f);
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

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [JLUIFactory labelInitText:@"宁静" font:kFontPingFangSCMedium(16.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [JLUIFactory labelInitText:@"15815858598" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _phoneLabel;
}

- (UIImageView *)addressMaskImageView {
    if (!_addressMaskImageView) {
        _addressMaskImageView = [JLUIFactory imageViewInitImageName:@"icon_address"];
    }
    return _addressMaskImageView;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [JLUIFactory labelInitText:@"江苏省南京市建邺区万达中心B座1403" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

@end
