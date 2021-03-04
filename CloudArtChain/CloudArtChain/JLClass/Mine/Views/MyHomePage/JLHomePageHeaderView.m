//
//  JLHomePageHeaderView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLHomePageHeaderView.h"

@interface JLHomePageHeaderView ()
@property (nonatomic, strong) UIView *avatarBackView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation JLHomePageHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.avatarBackView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.infoLabel];
    
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
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(17.0f);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-50.0f);
    }];
}

- (UIView *)avatarBackView {
    if (!_avatarBackView) {
        _avatarBackView = [[UIView alloc] init];
        _avatarBackView.backgroundColor = JL_color_blue_EAF8FF;
        ViewBorderRadius(_avatarBackView, 58.0f, 0.0f, JL_color_clear);
        
        UIView *innerView = [[UIView alloc] init];
        innerView.backgroundColor = JL_color_blue_99DCFF;
        ViewBorderRadius(innerView, 50.0f, 0.0f, JL_color_clear);
        [_avatarBackView addSubview:innerView];
        
        [innerView addSubview:self.avatarImageView];
        
        [innerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_avatarBackView).insets(UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f));
        }];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFontPingFangSCSCSemibold(15.0f);
        _nameLabel.textColor = JL_color_gray_101010;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel= [[UILabel alloc] init];
        _infoLabel.font = kFontPingFangSCRegular(13.0f);
        _infoLabel.textColor = JL_color_gray_101010;
        _infoLabel.numberOfLines = 0;
        _infoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _infoLabel;
}

- (void)setAuthorData:(Model_art_author_Data *)authorData {
    if (![NSString stringIsEmpty:authorData.avatar[@"url"]]) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:authorData.avatar[@"url"]] placeholderImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"]];
    } else {
        self.avatarImageView.image = [UIImage imageNamed:@"icon_mine_avatar_placeholder"];
    }
    self.nameLabel.text = authorData.display_name;
    NSString *showDesc = [NSString stringWithFormat:@"%@\r\n%@\r\n%@", [NSString stringIsEmpty:authorData.residential_address] ? @"" : [NSString stringWithFormat:@"现居于%@", authorData.residential_address], [NSString stringIsEmpty:authorData.college] ? @"" : authorData.college, [NSString stringIsEmpty:authorData.desc] ? @"" : authorData.desc];
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

- (void)setUserData:(UserDataBody *)userData {
    if (![NSString stringIsEmpty:userData.avatar[@"url"]]) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userData.avatar[@"url"]] placeholderImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"]];
    } else {
        self.avatarImageView.image = [UIImage imageNamed:@"icon_mine_avatar_placeholder"];
    }
    self.nameLabel.text = userData.display_name;
    
    NSString *showDesc = [NSString stringWithFormat:@"%@\r\n%@\r\n%@", [NSString stringIsEmpty:userData.residential_address] ? @"" : [NSString stringWithFormat:@"现居于%@", userData.residential_address], [NSString stringIsEmpty:userData.college] ? @"" : userData.college, [NSString stringIsEmpty:userData.desc] ? @"" : userData.desc];
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
