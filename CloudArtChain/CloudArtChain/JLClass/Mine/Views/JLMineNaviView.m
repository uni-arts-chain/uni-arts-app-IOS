//
//  JLMineNaviView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLMineNaviView.h"
#import "UIButton+TouchArea.h"

@interface JLMineNaviView ()
@property (nonatomic, strong) UIView *avatarView;
@property (nonatomic, strong) UIButton *avatarBtn;
@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) UIImageView *realNameMaskImageView;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UIButton *focusButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *fansButton;
@end

@implementation JLMineNaviView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.avatarView];
    [self.avatarView addSubview:self.avatarBtn];
    [self addSubview:self.nameLabel];
//    [self addSubview:self.realNameMaskImageView];
    [self addSubview:self.settingBtn];
    [self addSubview:self.focusButton];
    [self addSubview:self.lineView];
    [self addSubview:self.fansButton];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(KStatus_Bar_Height + 22.0f);
        make.size.mas_equalTo(54.0f);
    }];
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.avatarView).insets(UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f));
    }];
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KStatus_Bar_Height + 30.0f);
        make.right.mas_equalTo(-16.0f);
        make.width.mas_equalTo(21.0f);
        make.height.mas_equalTo(21.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarView.mas_right).offset(20.0f);
        make.top.mas_equalTo(KStatus_Bar_Height + 30.0f);
        make.height.mas_equalTo(17.0f);
    }];
//    [self.realNameMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.nameLabel.mas_right).offset(10.0f);
//        make.bottom.equalTo(self.nameLabel);
//        make.size.mas_equalTo(14.0f);
//    }];
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(12.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.focusButton.mas_right).offset(10.0f);
        make.centerY.equalTo(self.focusButton.mas_centerY);
        make.height.mas_equalTo(11.0f);
        make.width.mas_equalTo(0.5f);
    }];
    [self.fansButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(10.0f);
        make.top.equalTo(self.focusButton.mas_top);
    }];
}

- (UIView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 22.0f, 54.0f, 54.0f)];
        _avatarView.backgroundColor = JL_color_white_ffffff;
        _avatarView.layer.cornerRadius = 27.0f;
        _avatarView.layer.masksToBounds = NO;
        _avatarView.layer.shadowColor = JL_color_black.CGColor;
        _avatarView.layer.shadowOpacity = 0.13f;
        _avatarView.layer.shadowOffset = CGSizeZero;
        _avatarView.layer.shadowRadius = 5.0f;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:_avatarView.bounds];
        _avatarView.layer.shadowPath = path.CGPath;
    }
    return _avatarView;
}

- (UIButton *)avatarBtn {
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (![NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]]) {
            [_avatarBtn sd_setImageWithURL:[NSURL URLWithString:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"]];
        } else {
            [_avatarBtn setImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"] forState:UIControlStateNormal];
        }
        [_avatarBtn addTarget:self action:@selector(avatarBtnClick) forControlEvents:UIControlEventTouchUpInside];
        ViewBorderRadius(_avatarBtn, 25.0f, 0.0f, JL_color_clear);
    }
    return _avatarBtn;
}

- (void)avatarBtnClick {
    if (self.avatarBlock) {
        self.avatarBlock();
    }
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFontPingFangSCMedium(17.0f);
        _nameLabel.textColor = JL_color_gray_101010;
        _nameLabel.text = [NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.display_name] ? @"未设置昵称" : [AppSingleton sharedAppSingleton].userBody.display_name;
    }
    return _nameLabel;
}

//- (UIImageView *)realNameMaskImageView {
//    if (!_realNameMaskImageView) {
//        _realNameMaskImageView = [JLUIFactory imageViewInitImageName:@"icon_mine_no_realname"];
//    }
//    return _realNameMaskImageView;
//}

- (UIButton *)settingBtn {
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn setImage:[UIImage imageNamed:@"icon_mine_setting"] forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}

- (void)settingBtnClick {
    if (self.settingBlock) {
        self.settingBlock();
    }
}

- (UIButton *)focusButton {
    if (!_focusButton) {
        _focusButton = [JLUIFactory buttonInitTitle:[NSString stringWithFormat:@"关注%ld", [AppSingleton sharedAppSingleton].userBody.following_user_size] titleColor:JL_color_gray_101010 backgroundColor:JL_color_white_ffffff font:kFontPingFangSCRegular(11.0f) addTarget:self action:@selector(focusButtonClick)];
        _focusButton.contentEdgeInsets = UIEdgeInsetsZero;
        [_focusButton edgeTouchAreaWithTop:10.0f right:10.0f bottom:10.0f left:10.0f];
    }
    return _focusButton;
}

- (void)focusButtonClick {
    if (self.focusBlock) {
        self.focusBlock();
    }
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_101010;
    }
    return _lineView;
}

- (UIButton *)fansButton {
    if (!_fansButton) {
        _fansButton = [JLUIFactory buttonInitTitle:[NSString stringWithFormat:@"粉丝%ld", [AppSingleton sharedAppSingleton].userBody.follow_user_size] titleColor:JL_color_gray_101010 backgroundColor:JL_color_white_ffffff font:kFontPingFangSCRegular(11.0f) addTarget:self action:@selector(fansButtonClick)];
        _fansButton.contentEdgeInsets = UIEdgeInsetsZero;
        [_fansButton edgeTouchAreaWithTop:10.0f right:10.0f bottom:10.0f left:10.0f];
    }
    return _fansButton;
}

- (void)fansButtonClick {
    if (self.fansBlock) {
        self.fansBlock();
    }
}

- (void)refreshInfo {
    if (![NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]]) {
        [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"]];
    } else {
        [self.avatarBtn setImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"] forState:UIControlStateNormal];
    }
    self.nameLabel.text = [NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.display_name] ? @"未设置昵称" : [AppSingleton sharedAppSingleton].userBody.display_name;
    [self.focusButton setTitle:[NSString stringWithFormat:@"关注%ld", [AppSingleton sharedAppSingleton].userBody.following_user_size] forState:UIControlStateNormal];
    [self.fansButton setTitle:[NSString stringWithFormat:@"粉丝%ld", [AppSingleton sharedAppSingleton].userBody.follow_user_size] forState:UIControlStateNormal];
}

@end
