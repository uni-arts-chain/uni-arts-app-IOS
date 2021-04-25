//
//  JLHomePageEditHeaderView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/16.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLHomePageEditHeaderView.h"

@interface JLHomePageEditHeaderView ()
@property (nonatomic, strong) UIView *avatarBackView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIButton *avatarEditButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *nameEditButton;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *infoEditButton;
@end

@implementation JLHomePageEditHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.avatarBackView];
    [self addSubview:self.nameLabel];
    [self.nameLabel addSubview:self.nameEditButton];
    [self addSubview:self.infoLabel];
    [self.infoLabel addSubview:self.infoEditButton];
    
    [self.avatarBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18.0f);
        make.size.mas_equalTo(116.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.avatarBackView.mas_bottom).offset(20.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.nameEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.nameLabel);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(17.0f);
        make.left.mas_equalTo(40.0f);
        make.right.mas_equalTo(-40.0f);
        make.bottom.equalTo(self).offset(-20.0f);
    }];
    [self.infoEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.infoLabel);
    }];
}

- (UIView *)avatarBackView {
    if (!_avatarBackView) {
        _avatarBackView = [[UIView alloc] init];
        _avatarBackView.backgroundColor = JL_color_purple_F0F5FF;
        ViewBorderRadius(_avatarBackView, 58.0f, 0.0f, JL_color_clear);
        
        UIView *innerView = [[UIView alloc] init];
        innerView.backgroundColor = JL_color_purple_CADEFF;
        ViewBorderRadius(innerView, 50.0f, 0.0f, JL_color_clear);
        [_avatarBackView addSubview:innerView];
        
        [innerView addSubview:self.avatarImageView];
        [innerView addSubview:self.avatarEditButton];
        
        [innerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_avatarBackView).insets(UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f));
        }];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(innerView).insets(UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f));
        }];
        [self.avatarEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(innerView).insets(UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f));
        }];
    }
    return _avatarBackView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        ViewBorderRadius(_avatarImageView, 45.0f, 0.0f, JL_color_clear);
    }
    return _avatarImageView;
}

- (UIButton *)avatarEditButton {
    if (!_avatarEditButton) {
        _avatarEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_avatarEditButton addTarget:self action:@selector(avatarEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarEditButton;
}

- (void)avatarEditButtonClick {
    if (self.avatarEditBlock) {
        self.avatarEditBlock();
    }
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFontPingFangSCSCSemibold(15.0f);
        _nameLabel.textColor = JL_color_gray_101010;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.userInteractionEnabled = YES;
    }
    return _nameLabel;
}

- (UIButton *)nameEditButton {
    if (!_nameEditButton) {
        _nameEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameEditButton addTarget:self action:@selector(nameEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nameEditButton;
}

- (void)nameEditButtonClick {
    if (self.nameEditBlock) {
        self.nameEditBlock();
    }
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel= [[UILabel alloc] init];
        _infoLabel.font = kFontPingFangSCRegular(13.0f);
        _infoLabel.textColor = JL_color_gray_101010;
        _infoLabel.numberOfLines = 0;
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.userInteractionEnabled = YES;
    }
    return _infoLabel;
}

- (UIButton *)infoEditButton {
    if (!_infoEditButton) {
        _infoEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_infoEditButton addTarget:self action:@selector(infoEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoEditButton;
}

- (void)infoEditButtonClick {
    if (self.descEditBlock) {
        self.descEditBlock();
    }
}

- (void)setUserData:(UserDataBody *)userData {
    if (![NSString stringIsEmpty:userData.avatar[@"url"]]) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userData.avatar[@"url"]] placeholderImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"]];
    } else {
        self.avatarImageView.image = [UIImage imageNamed:@"icon_mine_avatar_placeholder"];
    }
    self.nameLabel.text = [NSString stringIsEmpty:userData.display_name] ? @"未设置昵称" : userData.display_name;
    
    NSString *showDesc =  [NSString stringIsEmpty:userData.desc] ? @"请输入描述内容" : userData.desc;
    if (![NSString stringIsEmpty:showDesc]) {
        self.infoLabel.text = showDesc;
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 10.0f;
        paraStyle.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.infoLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paraStyle} range:NSMakeRange(0, self.infoLabel.text.length)];
        self.infoLabel.attributedText = attr;
    }
}
@end
