//
//  JLHomePageEditHeaderView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/16.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLHomePageEditHeaderView.h"

@interface JLHomePageEditHeaderView ()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *authorBgView;

@property (nonatomic, strong) UIImageView *authorImgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *editDescBgView;

@property (nonatomic, strong) UILabel *editLabel;

@property (nonatomic, strong) UIImageView *editImgView;

@end

@implementation JLHomePageEditHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.image = [UIImage imageNamed:@"home_page_top_bg"];
    [self addSubview:_bgImgView];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(@(KStatusBar_Navigation_Height + 96));
    }];
    
    _authorBgView = [[UIView alloc] init];
    _authorBgView.backgroundColor = JL_color_white_ffffff;
    _authorBgView.layer.shadowColor = JL_color_gray_ECECEC.CGColor;
    _authorBgView.layer.shadowOffset = CGSizeMake(0,3);
    _authorBgView.layer.shadowRadius = 5;
    _authorBgView.layer.shadowOpacity = 1;
    [self addSubview:_authorBgView];
    [_authorBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(KStatusBar_Navigation_Height + 22);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self);
    }];
    
    _authorImgView = [[UIImageView alloc] init];
    _authorImgView.image = [UIImage imageNamed:@"icon_mine_avatar_placeholder"];
    _authorImgView.layer.cornerRadius = 33;
    _authorImgView.layer.borderWidth = 2;
    _authorImgView.layer.borderColor = JL_color_white_ffffff.CGColor;
    _authorImgView.clipsToBounds = YES;
    _authorImgView.userInteractionEnabled = YES;
    [_authorImgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorImgViewDidTap:)]];
    [self addSubview:_authorImgView];
    [_authorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.authorBgView);
        make.centerY.equalTo(self.authorBgView.mas_top);
        make.width.height.mas_equalTo(@66);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = JL_color_black_101220;
    _nameLabel.font = kFontPingFangSCSCSemibold(15);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.numberOfLines = 0;
    _nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _nameLabel.userInteractionEnabled = YES;
    [_nameLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameLabelDidTap:)]];
    [_authorBgView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorBgView).offset(40);
        make.left.equalTo(self.authorBgView).offset(12);
        make.right.equalTo(self.authorBgView).offset(-12);
    }];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textColor = JL_color_black_101220;
    _descLabel.font = kFontPingFangSCRegular(12);
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.numberOfLines = 0;
    _descLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _descLabel.userInteractionEnabled = YES;
    [_descLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(desLabelDidTap:)]];
    [_authorBgView addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.nameLabel);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_EDEDEE;
    [_authorBgView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.authorBgView);
        make.left.right.equalTo(self.authorBgView);
        make.height.mas_equalTo(@1);
    }];
    
    _editDescBgView = [[UIView alloc] init];
    _editDescBgView.hidden = YES;
    _editDescBgView.userInteractionEnabled = YES;
    [_editDescBgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editDescBgViewDidTap:)]];
    [_authorBgView addSubview:_editDescBgView];
    [_editDescBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(35);
        make.centerX.equalTo(self.authorBgView);
    }];
    
    _editLabel = [[UILabel alloc] init];
    _editLabel.text = @"请输入描述内容";
    _editLabel.textColor = JL_color_gray_87888F;
    _editLabel.textAlignment = NSTextAlignmentCenter;
    _editLabel.font = kFontPingFangSCRegular(12);
    [_editDescBgView addSubview:_editLabel];
    [_editLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.editDescBgView);
    }];
    
    _editImgView = [[UIImageView alloc] init];
    _editImgView.image = [UIImage imageNamed:@"home_page_placeholder_edit"];
    [_editDescBgView addSubview:_editImgView];
    [_editImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editLabel.mas_right).offset(21);
        make.centerY.equalTo(self.editLabel);
        make.right.equalTo(self.editDescBgView);
        make.width.height.mas_equalTo(@12);
    }];
}

#pragma mark - event response
- (void)authorImgViewDidTap: (UITapGestureRecognizer *)ges {
    if (self.avatarEditBlock) {
        self.avatarEditBlock();
    }
}

- (void)nameLabelDidTap: (UITapGestureRecognizer *)ges {
    if (self.nameEditBlock) {
        self.nameEditBlock();
    }
}

- (void)desLabelDidTap: (UITapGestureRecognizer *)ges {
    if (self.descEditBlock) {
        self.descEditBlock();
    }
}

- (void)editDescBgViewDidTap: (UITapGestureRecognizer *)ges {
    if (self.descEditBlock) {
        self.descEditBlock();
    }
}

#pragma mark - setters and getters
- (void)setUserData:(UserDataBody *)userData {
    if (![NSString stringIsEmpty:userData.avatar[@"url"]]) {
        [self.authorImgView sd_setImageWithURL:[NSURL URLWithString:userData.avatar[@"url"]] placeholderImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"]];
    } else {
        self.authorImgView.image = [UIImage imageNamed:@"icon_mine_avatar_placeholder"];
    }
    self.nameLabel.text = [NSString stringIsEmpty:userData.display_name] ? @"未设置昵称" : userData.display_name;
    
    self.descLabel.hidden = [NSString stringIsEmpty:userData.desc];
    
    self.editDescBgView.hidden = ![NSString stringIsEmpty:userData.desc];
    
    if (![NSString stringIsEmpty:userData.desc]) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 2.0f;
        paraStyle.alignment = NSTextAlignmentCenter;
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:userData.desc];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paraStyle} range:NSMakeRange(0, attr.length)];
        _descLabel.attributedText = attr;
    }
    
    [_authorBgView layoutIfNeeded];
    [_authorBgView setCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius: CGSizeMake(5, 5)];
}
@end
