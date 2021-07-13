//
//  JLArtAuthorDetailView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/1.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLArtAuthorDetailView.h"
#import "UIButton+AxcButtonContentLayout.h"

@interface JLArtAuthorDetailView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *goToHomePageView;
@end

@implementation JLArtAuthorDetailView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.bgView];
    
    [self.bgView addSubview:self.avatarImageView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.descLabel];
    [self.bgView addSubview:self.goToHomePageView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(48.0f);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(12.0f);
        make.top.equalTo(self.bgView).offset(23.0f);
        make.size.mas_equalTo(70.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(13.0f);
        make.top.equalTo(self.avatarImageView).offset(-4.0f);
        make.right.equalTo(self.bgView).offset(-15.0f);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5.0f);
    }];
    [self.goToHomePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.bgView);
        make.height.mas_equalTo(36.0f);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"品牌简介";
        _titleLabel.textColor = JL_color_black_101220;
        _titleLabel.font = kFontPingFangSCSCSemibold(15);
        _titleLabel.jl_contentInsets = UIEdgeInsetsMake(5, 13, 0, 0);
    }
    return _titleLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = JL_color_white_ffffff;
    }
    return _bgView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        ViewBorderRadius(_avatarImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentLeft];
        _nameLabel.numberOfLines = 1;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCMedium(12.0f) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentLeft];
        _descLabel.numberOfLines = 3;
        _descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _descLabel;
}

- (UIView *)goToHomePageView {
    if (!_goToHomePageView) {
        _goToHomePageView = [[UIView alloc] init];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = JL_color_gray_EDEDEE;
        [_goToHomePageView addSubview:lineView];
        
        UILabel *titleLabel = [JLUIFactory labelInitText:@"查看更多商品" font:kFontPingFangSCMedium(13.0f) textColor:JL_color_black_40414D textAlignment:NSTextAlignmentLeft];
        titleLabel.tag = 100;
        [_goToHomePageView addSubview:titleLabel];
        
        UIImageView *arrowImageView = [JLUIFactory imageViewInitImageName:@"icon_launch_auction_arrow"];
        arrowImageView.image = [UIImage jl_changeImage:arrowImageView.image color:JL_color_black_40414D];
        [_goToHomePageView addSubview:arrowImageView];
        
        UIButton *goToHomePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [goToHomePageBtn addTarget:self action:@selector(goToHomePageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_goToHomePageView addSubview:goToHomePageBtn];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_goToHomePageView);
            make.height.mas_equalTo(@1);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_goToHomePageView);
        }];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(8.0f);
            make.width.mas_equalTo(6.0f);
            make.height.mas_equalTo(11.0f);
            make.centerY.equalTo(_goToHomePageView.mas_centerY);
        }];
        [goToHomePageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_goToHomePageView);
        }];
    }
    return _goToHomePageView;
}

- (void)goToHomePageBtnClick {
    if (self.introduceBlock) {
        self.introduceBlock();
    }
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    if (![NSString stringIsEmpty:artDetailData.author.avatar[@"url"]]) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:artDetailData.author.avatar[@"url"]] placeholderImage:[UIImage imageNamed:@"icon_mine_avatar_placeholder"]];
    } else {
        self.avatarImageView.image = [UIImage imageNamed:@"icon_mine_avatar_placeholder"];
    }
    self.nameLabel.text = artDetailData.author.display_name;
    
    if ([NSString stringIsEmpty:artDetailData.author.desc]) {
        self.descLabel.text = artDetailData.author.desc;
    }else {
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
        para.lineSpacing = 4;
        para.lineBreakMode = NSLineBreakByTruncatingTail;
        NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:artDetailData.author.desc];
        [attrs addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, attrs.length)];
        self.descLabel.attributedText = attrs;
    }
}
@end
