//
//  JLChainQueryArtCertView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/2.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLChainQueryArtCertView.h"

#import "UIButton+TouchArea.h"

@interface JLChainQueryArtCertView ()
@property (nonatomic, strong) UIImageView *certImageView;
@property (nonatomic, strong) UIButton *certImageBtn;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *signTimesLabel;
@property (nonatomic, strong) UILabel *signMechanismLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLChainQueryArtCertView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    frame.size.height = self.lineView.frameBottom;
    self.frame = frame;
}

- (void)createSubViews {
    UILabel *titleLabel = [JLUIFactory labelInitText:@"签名证书" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    [self addSubview:titleLabel];
    
    UILabel *certImageTitleLabel = [JLUIFactory labelInitText:@"证书照片" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    [self addSubview:certImageTitleLabel];
    [self addSubview:self.certImageView];
    [self addSubview:self.certImageBtn];
    
    UILabel *addressTitleLabel = [JLUIFactory labelInitText:@"证书地址" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    [self addSubview:addressTitleLabel];
    [self addSubview:self.addressLabel];
    
    UILabel *signTimesTitleLabel = [JLUIFactory labelInitText:@"签名数" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    [self addSubview:signTimesTitleLabel];
    [self addSubview:self.signTimesLabel];
    
    UILabel *signMechanismTitleLabel = [JLUIFactory labelInitText:@"签名机构" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    [self addSubview:signMechanismTitleLabel];
    [self addSubview:self.signMechanismLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self addSubview:self.lineView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(21.0f);
        make.height.mas_equalTo(17.0f);
    }];
    [certImageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(titleLabel.mas_bottom).offset(27.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.certImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(certImageTitleLabel.mas_right);
        make.top.equalTo(titleLabel.mas_bottom).offset(16.0f);
        make.width.mas_equalTo(24.0f);
        make.height.mas_equalTo(33.0f);
    }];
    [self.certImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(certImageTitleLabel.mas_right);
        make.top.equalTo(titleLabel.mas_bottom).offset(16.0f);
        make.width.mas_equalTo(24.0f);
        make.height.mas_equalTo(33.0f);
    }];
    [addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(certImageTitleLabel.mas_bottom).offset(20.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressTitleLabel.mas_right);
        make.top.equalTo(addressTitleLabel.mas_top);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [signTimesTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(addressTitleLabel.mas_bottom).offset(20.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.signTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signTimesTitleLabel.mas_right);
        make.top.equalTo(signTimesTitleLabel.mas_top);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [signMechanismTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(signTimesTitleLabel.mas_bottom).offset(20.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.signMechanismLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signMechanismTitleLabel.mas_right);
        make.top.equalTo(signMechanismTitleLabel.mas_top);
        make.right.mas_equalTo(-15.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.signMechanismLabel.mas_bottom).offset(35.0f);
        make.height.mas_equalTo(1.0f);
    }];
}

- (UIImageView *)certImageView {
    if (!_certImageView) {
        _certImageView = [[UIImageView alloc] init];
        _certImageView.image = [UIImage imageNamed:@"1"];
    }
    return _certImageView;
}

- (UIButton *)certImageBtn {
    if (!_certImageBtn) {
        _certImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_certImageBtn edgeTouchAreaWithTop:20.0f right:20.0f bottom:20.0f left:20.0f];
        [_certImageBtn addTarget:self action:@selector(certImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _certImageBtn;
}

- (void)certImageBtnClick {
    if (self.certImageBlock) {
        self.certImageBlock();
    }
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [JLUIFactory labelInitText:@"0xsbd354sdf4241d354sdf4241d35" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _addressLabel;
}

- (UILabel *)signTimesLabel {
    if (!_signTimesLabel) {
        _signTimesLabel = [JLUIFactory labelInitText:@"3" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _signTimesLabel;
}

- (UILabel *)signMechanismLabel {
    if (!_signMechanismLabel) {
        _signMechanismLabel = [JLUIFactory labelInitText:@"南京艺术品鉴定中心、国家艺术品鉴定中心、国家艺术品鉴定中心" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _signMechanismLabel;
}
@end
