//
//  JLSettingTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/15.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLSettingTableViewCell.h"

@interface JLSettingTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation JLSettingTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = JL_color_white_ffffff;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.arrowImageView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.bottom.equalTo(self.contentView);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-22.0f);
        make.width.mas_equalTo(8.0f);
        make.height.mas_equalTo(15.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(-8.0f);
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.titleLabel.mas_right).offset(8.0f);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(-15.0f);
        make.size.mas_equalTo(34.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self.contentView);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_BBBBBB textAlignment:NSTextAlignmentRight];
    }
    return _statusLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        ViewBorderRadius(_avatarImageView, 17.0f, 0.0f, JL_color_clear);
    }
    return _avatarImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [JLUIFactory imageViewInitImageName:@"icon_wallet_edit_arrowright"];
    }
    return _arrowImageView;
}

- (void)setTitle:(NSString *)title status:(NSString *)status isAvatar:(BOOL)isAvatar showLine:(BOOL)showLine showArrow:(BOOL)showArrow {
    self.titleLabel.text = title;
    if (isAvatar) {
        self.statusLabel.hidden = YES;
        self.avatarImageView.hidden = NO;
        if (![NSString stringIsEmpty:status]) {
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:status] placeholderImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"]];
        } else {
            self.avatarImageView.image = [UIImage imageNamed:@"icon_mine_avatar_placeholder"];
        }
    } else {
        self.statusLabel.hidden = NO;
        self.avatarImageView.hidden = YES;
        self.statusLabel.text = status;
    }
    self.arrowImageView.hidden = !showArrow;
    self.lineView.hidden = !showLine;
    if (!showArrow) {
        [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-22.0f);
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.titleLabel.mas_right).offset(8.0f);
        }];
    } else {
        [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowImageView.mas_left).offset(-8.0f);
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.titleLabel.mas_right).offset(8.0f);
        }];
    }
}

- (void)setAvatarImage:(UIImage *)avatarImage {
    self.avatarImageView.image = avatarImage;
}
@end
