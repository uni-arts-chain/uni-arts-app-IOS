//
//  JLWalletPointCell.m
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWalletPointCell.h"

@interface JLWalletPointCell ()
@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLWalletPointCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.maskImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.numLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26.0f);
        make.top.mas_equalTo(24.0f);
        make.size.mas_equalTo(20.0f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maskImageView.mas_right).offset(15.0f);
        make.top.mas_equalTo(26.0f);
        make.height.mas_equalTo(16.0f);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-17.0f);
        make.top.mas_equalTo(26.0f);
         make.height.mas_equalTo(16.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self.contentView);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [JLUIFactory imageViewInitImageName:@"icon_home_wallet_point"];
    }
    return _maskImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"积分" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [JLUIFactory labelInitText:@"288" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _numLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}
@end
