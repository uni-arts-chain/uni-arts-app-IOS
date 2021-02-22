//
//  JLNoAddressView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLNoAddressView.h"

@interface JLNoAddressView ()
@property (nonatomic, strong) UIImageView *typeImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *addNewButton;
@end

@implementation JLNoAddressView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createView];
    }
    return self;
}

- (void)createView {
    [self addSubview:self.typeImage];
    [self addSubview:self.nameLabel];
    [self addSubview:self.addNewButton];
    
    [self.typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(154.0f, 148.0f));
        make.centerX.equalTo(self);
        make.top.mas_equalTo(49.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.typeImage.mas_bottom).offset(15.0f);
    }];
    [self.addNewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(35.0f);
        make.width.mas_equalTo(265.0f);
        make.height.mas_equalTo(46.0f);
        make.centerX.equalTo(self);
    }];
}

- (UIImageView *)typeImage {
    if (!_typeImage) {
        _typeImage = [UIImageView new];
        _typeImage.image = [UIImage imageNamed:@"icon_address_blank"];
    }
    return _typeImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"赶紧添加收货地址吧~";
        _nameLabel.textColor = JL_color_gray_909090;
        _nameLabel.font = kFontPingFangSCRegular(16.0f);
        _nameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _nameLabel;
}

- (UIButton *)addNewButton {
    if (!_addNewButton) {
        _addNewButton = [JLUIFactory buttonInitTitle:@"添加新地址" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_50C3FF font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(addNewButtonClick)];
        ViewBorderRadius(_addNewButton, 23.0f, 0, JL_color_clear);
    }
    return _addNewButton;
}

- (void)addNewButtonClick {
    if (self.addNewAddressBlock) {
        self.addNewAddressBlock();
    }
}

@end
