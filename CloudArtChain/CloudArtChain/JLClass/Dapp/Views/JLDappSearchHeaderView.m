//
//  JLDappSearchHeaderView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/26.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappSearchHeaderView.h"

@interface JLDappSearchHeaderView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *scanBtn;
 
@end

@implementation JLDappSearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgView.layer.cornerRadius = self.frameHeight / 2;
}

- (void)setupUI {
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = JL_color_gray_F3F3F3;
    _bgView.userInteractionEnabled = YES;
    [_bgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewDidTap:)]];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.bottom.equalTo(self);
    }];
    
    _leftImgView = [[UIImageView alloc] init];
    _leftImgView.image = [UIImage imageNamed:@"icon_dapp_search_logo"];
    [_bgView addSubview:_leftImgView];
    [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(12);
        make.centerY.equalTo(self.bgView);
        make.width.height.mas_equalTo(@15);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"搜索或输入 DApp 网址";
    _titleLabel.textColor = JL_color_gray_BEBEBE;
    _titleLabel.font = kFontPingFangSCRegular(13);
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImgView.mas_right).offset(10);
        make.right.equalTo(self.bgView).offset(-50);
        make.centerY.equalTo(self.bgView);
    }];
    
    _scanBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_scanBtn setImage:[[UIImage imageNamed:@"icon_dapp_search_scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_scanBtn];
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView);
        make.top.bottom.equalTo(self.bgView);
        make.width.mas_equalTo(@45);
    }];
}

#pragma mark - event response
- (void)bgViewDidTap: (UITapGestureRecognizer *)ges {
    if (_searchBlock) {
        _searchBlock();
    }
}

- (void)scanBtnClick: (UIButton *)sender {
    if (_scanBlock) {
        _scanBlock();
    }
}

@end
