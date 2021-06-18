//
//  JLCategoryNaviView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCategoryNaviView.h"

@interface JLCategoryNaviView ()
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIButton *searchBtn;
@end

@implementation JLCategoryNaviView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_navBgColor;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.searchView];
    [self addSubview:self.searchBtn];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0f);
        make.top.mas_equalTo(KStatus_Bar_Height + 3.0f);
        make.right.mas_equalTo(-12.0f);
        make.bottom.equalTo(self).offset(-7.0f);
    }];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0f);
        make.top.mas_equalTo(KStatus_Bar_Height + 3.0f);
        make.right.mas_equalTo(-12.0f);
        make.bottom.equalTo(self).offset(-7.0f);
    }];
}

- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.backgroundColor = JL_color_gray_F5F5F5;
        ViewBorderRadius(_searchView, (KNavigation_Height - 5.0f * 2) * 0.5f, 0.0f, JL_color_clear);
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_common_search"]];
        [_searchView addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = kFontPingFangSCRegular(13.0f);
        titleLabel.textColor = JL_color_gray_87888F;
        titleLabel.text = @"请输入关键字搜索作品";
        [_searchView addSubview:titleLabel];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13.0f);
            make.size.mas_equalTo(14.0f);
            make.centerY.equalTo(_searchView.mas_centerY);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).offset(6.0f);
            make.top.bottom.right.equalTo(_searchView);
        }];
    }
    return _searchView;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ViewBorderRadius(_searchBtn, (KNavigation_Height - 6.0f * 2) * 0.5f, 0.0f, JL_color_clear);
        [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (void)searchBtnClick {
    if (self.searchBlock) {
        self.searchBlock();
    }
}
@end
