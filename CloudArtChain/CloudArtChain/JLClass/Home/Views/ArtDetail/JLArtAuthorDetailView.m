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
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *goToHomePageView;
@end

@implementation JLArtAuthorDetailView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    UIView *titleView = [JLUIFactory titleViewWithTitle:@"创作者简介"];
    [self addSubview:titleView];
    
    [self addSubview:self.avatarImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.goToHomePageView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(65.0f);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(titleView.mas_bottom).offset(8.0f);
        make.size.mas_equalTo(110.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(20.0f);
        make.top.equalTo(self.avatarImageView);
        make.height.mas_equalTo(25.0f);
        make.right.mas_equalTo(-50.0f);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(20.0f);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5.0f);
        make.height.mas_equalTo(55.0f);
        make.right.mas_equalTo(-28.0f);
    }];
    [self.goToHomePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(20.0f);
        make.top.equalTo(self.descLabel.mas_bottom).offset(5.0f);
        make.height.mas_equalTo(25.0f);
    }];
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.backgroundColor = [UIColor randomColor];
        ViewBorderRadius(_avatarImageView, 55.0f, 0.0f, JL_color_clear);
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        _nameLabel.numberOfLines = 1;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
        _descLabel.numberOfLines = 2;
        _descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _descLabel;
}

- (UIView *)goToHomePageView {
    if (!_goToHomePageView) {
        _goToHomePageView = [[UIView alloc] init];
        
        UILabel *titleLabel = [JLUIFactory labelInitText:@"进入创作者主页" font:kFontPingFangSCMedium(14.0f) textColor:JL_color_blue_337FFF textAlignment:NSTextAlignmentLeft];
        [_goToHomePageView addSubview:titleLabel];
        
        UIImageView *arrowImageView = [JLUIFactory imageViewInitImageName:@"icon_home_artdetail_arrow"];
        [_goToHomePageView addSubview:arrowImageView];
        
        UIButton *goToHomePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [goToHomePageBtn addTarget:self action:@selector(goToHomePageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_goToHomePageView addSubview:goToHomePageBtn];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_goToHomePageView);
        }];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(4.0f);
            make.right.equalTo(_goToHomePageView);
            make.width.mas_equalTo(19.0f);
            make.height.mas_equalTo(8.0f);
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
    self.descLabel.text = artDetailData.author.desc;
}
@end
