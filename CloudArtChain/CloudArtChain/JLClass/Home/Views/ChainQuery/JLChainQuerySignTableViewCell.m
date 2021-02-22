//
//  JLChainQuerySignTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/2.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLChainQuerySignTableViewCell.h"

@interface JLChainQuerySignTableViewCell ()
@property (nonatomic, strong) UILabel *orderLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLChainQuerySignTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.orderLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.0f);
        make.size.mas_equalTo(42.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderLabel.mas_right).offset(18.0f);
        make.top.equalTo(self.orderLabel.mas_top);
        make.height.mas_equalTo(15.0f);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(6.0f);
        make.top.mas_equalTo(self.nameLabel.mas_top).offset(-2.0f);
        make.width.mas_equalTo(34.0f);
        make.height.mas_equalTo(17.0f);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.orderLabel.mas_bottom);
        make.height.mas_equalTo(14.0f);
        make.right.mas_equalTo(-15.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self.contentView);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
}

- (UILabel *)orderLabel {
    if (!_orderLabel) {
        _orderLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(24.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
        ViewBorderRadius(_orderLabel, 21.0f, 0.0f, JL_color_clear);
    }
    return _orderLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [JLUIFactory labelInitText:@"张大千" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [JLUIFactory labelInitText:@"机构" font:kFontPingFangSCMedium(13.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentCenter];
        _typeLabel.backgroundColor = JL_color_orange_FF8150;
        ViewBorderRadius(_typeLabel, 5.0f, 0.0f, JL_color_clear);
    }
    return _typeLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [JLUIFactory labelInitText:@"0xsbd354sdf4241d354sdf4241d35 " font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    }
    return _addressLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.orderLabel.backgroundColor = JL_color_blue_88D6FF;
        self.typeLabel.text = @"作者";
        self.typeLabel.backgroundColor = JL_color_yellow_FFCA50;
    } else {
        self.orderLabel.backgroundColor = JL_color_green_9DDC81;
    }
    self.orderLabel.text = @(indexPath.row + 1).stringValue;
}
@end
