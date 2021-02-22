//
//  JLOrderDetailAddressAddNewTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/4.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLOrderDetailAddressAddNewTableViewCell.h"

@interface JLOrderDetailAddressAddNewTableViewCell ()
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIImageView *addNewImageView;
@property (nonatomic, strong) UILabel *addNewTitleLabel;
@property (nonatomic, strong) UIButton *addNewButton;
@end

@implementation JLOrderDetailAddressAddNewTableViewCell
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
    [self.shadowView addSubview:self.centerView];
    [self.centerView addSubview:self.addNewImageView];
    [self.centerView addSubview:self.addNewTitleLabel];
    [self.shadowView addSubview:self.addNewButton];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(5.0f);
        make.bottom.mas_equalTo(-5.0f);
    }];
    [self.shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shadowView);
    }];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.shadowView);
        make.centerX.equalTo(self.shadowView.mas_centerX);
    }];
    [self.addNewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView);
        make.size.mas_equalTo(24.0f);
        make.centerY.equalTo(self.centerView.mas_centerY);
    }];
    [self.addNewTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addNewImageView.mas_right).offset(10.0f);
        make.right.top.bottom.equalTo(self.centerView);
        make.height.mas_equalTo(87.0f);
    }];
    [self.addNewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shadowView);
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

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
    }
    return _centerView;
}

- (UIImageView *)addNewImageView {
    if (!_addNewImageView) {
        _addNewImageView = [JLUIFactory imageViewInitImageName:@"icon_mine_address_add"];
    }
    return _addNewImageView;
}

- (UILabel *)addNewTitleLabel {
    if (!_addNewTitleLabel) {
        _addNewTitleLabel = [JLUIFactory labelInitText:@"添加收货地址" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _addNewTitleLabel;
}

- (UIButton *)addNewButton {
    if (!_addNewButton) {
        _addNewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addNewButton addTarget:self action:@selector(addNewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addNewButton;
}

- (void)addNewButtonClick {
    if (self.addNewBlock) {
        self.addNewBlock();
    }
}

@end
