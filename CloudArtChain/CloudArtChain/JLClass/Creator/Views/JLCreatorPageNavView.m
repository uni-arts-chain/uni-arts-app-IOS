//
//  JLCreatorPageNavView.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/24.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLCreatorPageNavView.h"

@implementation JLCreatorPageNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = JL_color_navBgColor;
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage jl_changeImage:[UIImage imageNamed:@"icon_back"] color:JL_color_white_ffffff] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bgView);
        make.width.height.mas_equalTo(@44);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = JL_color_white_ffffff;
    _titleLabel.font = kFontPingFangSCSCSemibold(18);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn);
        make.left.equalTo(self.bgView).offset(50);
        make.right.equalTo(self.bgView).offset(-50);
    }];
}

#pragma mark - event response
- (void)backBtnClick {
    if (_backBlock) {
        _backBlock();
    }
}

@end
