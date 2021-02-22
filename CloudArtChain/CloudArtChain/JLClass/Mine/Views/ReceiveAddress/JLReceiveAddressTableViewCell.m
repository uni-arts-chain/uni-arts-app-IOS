//
//  JLReceiveAddressTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLReceiveAddressTableViewCell.h"
#import "UIButton+TouchArea.h"

@interface JLReceiveAddressTableViewCell ()
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneNumberLabel;
@property (nonatomic, strong) UIImageView *addressMaskImageView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *editButton;
@end

@implementation JLReceiveAddressTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.shadowView];
    [self.shadowView addSubview:self.shadowImageView];
    [self.shadowView addSubview:self.nameLabel];
    [self.shadowView addSubview:self.phoneNumberLabel];
    [self.shadowView addSubview:self.addressMaskImageView];
    [self.shadowView addSubview:self.addressLabel];
    [self.shadowView addSubview:self.editButton];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f));
    }];
    [self.shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shadowView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(20.0f);
    }];
    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(15.0f);
        make.bottom.equalTo(self.nameLabel.mas_bottom);
        make.right.mas_greaterThanOrEqualTo(-35.0f);
    }];
    [self.addressMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(20.0f);
        make.width.mas_equalTo(12.0f);
        make.height.mas_equalTo(14.0f);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressMaskImageView.mas_right).offset(14.0f);
        make.top.equalTo(self.addressMaskImageView.mas_top).offset(-3.0f);
        make.right.mas_equalTo(-60.0f);
        make.bottom.mas_equalTo(-20.0f);
    }];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.shadowView).offset(-20.0f);
        make.centerY.equalTo(self.shadowView);
        make.width.mas_equalTo(15.0f);
        make.height.mas_equalTo(21.0f);
    }];
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = JL_color_white_ffffff;
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

- (UILabel *)phoneNumberLabel {
    if (!_phoneNumberLabel) {
        _phoneNumberLabel = [JLUIFactory labelInitText:@"15815858598" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _phoneNumberLabel;
}

- (UIImageView *)addressMaskImageView {
    if (!_addressMaskImageView) {
        _addressMaskImageView = [JLUIFactory imageViewInitImageName:@"icon_address_mask"];
    }
    return _addressMaskImageView;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [JLUIFactory labelInitText:@"江苏省南京市建邺区江东商业文化旅游中心区江东中路106号万达中心b座1403" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setBackgroundImage:[UIImage imageNamed:@"icon_address_edit"] forState:UIControlStateNormal];
        [_editButton setBackgroundImage:[UIImage imageNamed:@"icon_address_edit"] forState:UIControlStateHighlighted];
        [_editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_editButton edgeTouchAreaWithTop:10.0f right:10.0f bottom:10.0f left:10.0f];
    }
    return _editButton;
}

- (void)editButtonClick {
    if (self.editAddressBlock) {
        self.editAddressBlock();
    }
}

@end
