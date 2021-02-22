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
        _avatarImageView.backgroundColor = [UIColor randomColor];
        ViewBorderRadius(_avatarImageView, 45.0f, 0.0f, JL_color_clear);
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFontPingFangSCSCSemibold(15.0f);
        _nameLabel.textColor = JL_color_gray_101010;
        _nameLabel.text = @"张小菲";
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
        _infoLabel.text = @"出生于南京\r\n现就读于南京艺术学院\r\n师从于李晓璇、李金等当代名家\r\n南京工笔重彩画会 会员";
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 10.0f;
        paraStyle.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_infoLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paraStyle} range:NSMakeRange(0, _infoLabel.text.length)];
        _infoLabel.attributedText = attr;
    }
    return _infoLabel;
}
@end
