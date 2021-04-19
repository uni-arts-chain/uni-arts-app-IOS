//
//  JLFocusFansTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/4.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLFocusFansTableViewCell.h"

@interface JLFocusFansTableViewCell ()
@property (nonatomic, strong) UIView *avatarView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *productNumMaskImageView;
@property (nonatomic, strong) UILabel *productNumLabel;
@property (nonatomic, strong) UIButton *cancelFocusButton;
@property (nonatomic, strong) UIButton *focusButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) Model_art_author_Data *authorData;
@end

@implementation JLFocusFansTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.avatarView];
    [self.avatarView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.productNumMaskImageView];
    [self.contentView addSubview:self.productNumLabel];
    [self.contentView addSubview:self.cancelFocusButton];
    [self.contentView addSubview:self.focusButton];
    [self.contentView addSubview:self.lineView];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.0f);
        make.size.mas_equalTo(54.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.avatarView).insets(UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_top);
        make.left.equalTo(self.avatarView.mas_right).offset(18.0f);
        make.height.mas_equalTo(32.0f);
    }];
    [self.productNumMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8.0f);
        make.left.equalTo(self.avatarView.mas_right).offset(23.0f);
        make.width.mas_equalTo(13.0f);
        make.height.mas_equalTo(10.0f);
    }];
    [self.productNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNumMaskImageView.mas_right).offset(8.0f);
        make.centerY.equalTo(self.productNumMaskImageView.mas_centerY);
    }];
    [self.cancelFocusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.0f);
        make.width.mas_equalTo(63.0f);
        make.height.mas_equalTo(25.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.0f);
        make.width.mas_equalTo(63.0f);
        make.height.mas_equalTo(25.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.0f);
        make.bottom.equalTo(self.contentView);
        make.right.mas_equalTo(-16.0f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (UIView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIView alloc] init];
        _avatarView.backgroundColor = JL_color_gray_E2E2E2;
        ViewBorderRadius(_avatarView, 27.0f, 0, JL_color_clear);
    }
    return _avatarView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        ViewBorderRadius(_avatarImageView, 25.0f, 0.0f, JL_color_clear);
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (UIImageView *)productNumMaskImageView {
    if (!_productNumMaskImageView) {
        _productNumMaskImageView = [JLUIFactory imageViewInitImageName:@"icon_mine_focus_product"];
    }
    return _productNumMaskImageView;
}

- (UILabel *)productNumLabel {
    if (!_productNumLabel) {
        _productNumLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(11.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _productNumLabel;
}

- (UIButton *)cancelFocusButton {
    if (!_cancelFocusButton) {
        _cancelFocusButton = [JLUIFactory buttonInitTitle:@"取消关注" titleColor:JL_color_gray_101010 backgroundColor:JL_color_white_ffffff font:kFontPingFangSCRegular(11.0f) addTarget:self action:@selector(cancelFocusButtonClick)];
        [_cancelFocusButton setContentEdgeInsets:UIEdgeInsetsZero];
        ViewBorderRadius(_cancelFocusButton, 12.5f, 1.0f, JL_color_gray_101010);
        _cancelFocusButton.hidden = YES;
    }
    return _cancelFocusButton;
}

- (void)cancelFocusButtonClick {
    if (self.cancleFocusBlock) {
        self.cancleFocusBlock(self.authorData);
    }
}

- (UIButton *)focusButton {
    if (!_focusButton) {
        _focusButton = [JLUIFactory buttonInitTitle:@"关注" titleColor:JL_color_white_ffffff backgroundColor:JL_color_gray_101010 font:kFontPingFangSCRegular(11.0f) addTarget:self action:@selector(focusButtonClick)];
        [_focusButton setContentEdgeInsets:UIEdgeInsetsZero];
        ViewBorderRadius(_focusButton, 12.5f, 0.0f, JL_color_clear);
        _focusButton.hidden = YES;
    }
    return _focusButton;
}

- (void)focusButtonClick {
    if (self.focusBlock) {
        self.focusBlock(self.authorData);
    }
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}

- (void)setAuthor:(Model_art_author_Data *)authorData isLastCell:(BOOL)isLast {
    self.authorData = authorData;
    if (authorData.follow_by_me) {
        self.cancelFocusButton.hidden = NO;
        self.focusButton.hidden = YES;
    } else {
        self.cancelFocusButton.hidden = YES;
        self.focusButton.hidden = NO;
    }
    self.lineView.hidden = isLast;
    
    if (![NSString stringIsEmpty:authorData.avatar[@"url"]]) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:authorData.avatar[@"url"]] placeholderImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"]];
    } else {
        self.avatarImageView.image = [UIImage imageNamed:@"icon_mine_avatar_placeholder"];
    }
    self.nameLabel.text = [NSString stringIsEmpty:authorData.display_name] ? @"未设置昵称" : authorData.display_name;
    self.productNumLabel.text = [NSString stringWithFormat:@"%ld个作品", authorData.art_size];
}

@end
