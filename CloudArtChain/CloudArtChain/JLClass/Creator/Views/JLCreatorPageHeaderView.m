//
//  JLCreatorPageHeaderView.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/24.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLCreatorPageHeaderView.h"

@interface JLCreatorPageHeaderView ()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *authorBgView;

@property (nonatomic, strong) UIImageView *authorImgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JLCreatorPageHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.image = [UIImage imageNamed:@"home_page_top_bg"];
    [self addSubview:_bgImgView];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(@(KStatusBar_Navigation_Height + 96));
    }];
    
    _authorBgView = [[UIView alloc] init];
    _authorBgView.backgroundColor = JL_color_white_ffffff;
    _authorBgView.layer.cornerRadius = 5;
    _authorBgView.layer.shadowColor = JL_color_gray_ECECEC.CGColor;
    _authorBgView.layer.shadowOffset = CGSizeMake(0,3);
    _authorBgView.layer.shadowRadius = 5;
    _authorBgView.layer.shadowOpacity = 1;
    [self addSubview:_authorBgView];
    [_authorBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(KStatusBar_Navigation_Height + 22);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self).offset(-17);
    }];
    
    _authorImgView = [[UIImageView alloc] init];
    _authorImgView.image = [UIImage imageNamed:@"icon_mine_avatar_placeholder"];
    _authorImgView.layer.cornerRadius = 33;
    _authorImgView.layer.borderWidth = 2;
    _authorImgView.layer.borderColor = JL_color_white_ffffff.CGColor;
    _authorImgView.clipsToBounds = YES;
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
    [_authorBgView addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.left.right.equalTo(self.nameLabel);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_EDEDEE;
    [_authorBgView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.authorBgView);
        make.height.mas_equalTo(@1);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"TA出售的商品";
    _titleLabel.textColor = JL_color_gray_87888F;
    _titleLabel.font = kFontPingFangSCRegular(14);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_authorBgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(11);
        make.centerX.equalTo(self.authorBgView);
        make.bottom.equalTo(self.authorBgView).offset(-12);
    }];
}

#pragma mark - setters and getters
- (void)setAuthorData:(Model_art_author_Data *)authorData {
    _authorData = authorData;
    
    [_authorImgView sd_setImageWithURL:[NSURL URLWithString:_authorData.avatar[@"url"]] placeholderImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"]];
    _nameLabel.text = [NSString stringIsEmpty:_authorData.display_name] ? @"未设置昵称" : _authorData.display_name;
    NSString *showDesc = [NSString stringIsEmpty:_authorData.desc] ? @"未设置描述" : _authorData.desc;
    if (![NSString stringIsEmpty:showDesc]) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 2.0f;
        paraStyle.alignment = NSTextAlignmentCenter;
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:showDesc];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paraStyle} range:NSMakeRange(0, attr.length)];
        _descLabel.attributedText = attr;
    }else {
        _descLabel.text = showDesc;
    }
}

@end
