//
//  JLHomeNaviView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLHomeNaviView.h"

@interface JLHomeNaviView ()
@property (nonatomic, strong) UIButton *customerServiceBtn;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIButton *messageBtn;
@property (nonatomic, strong) UIView *unreadMessageView;
@end

@implementation JLHomeNaviView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.customerServiceBtn];
    [self addSubview:self.searchView];
    [self addSubview:self.searchBtn];
    [self addSubview:self.messageBtn];
    [self addSubview:self.unreadMessageView];
    
    [self.customerServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self);
        make.top.mas_equalTo(KStatus_Bar_Height);
        make.width.mas_equalTo(KNavigation_Height);
    }];
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self);
        make.top.mas_equalTo(KStatus_Bar_Height);
        make.width.mas_equalTo(KNavigation_Height);
    }];
    [self.unreadMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageBtn).offset(8.0f);
        make.right.equalTo(self.messageBtn).offset(-8.0f);
        make.size.mas_equalTo(8.0f);
    }];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customerServiceBtn.mas_right);
        make.top.mas_equalTo(KStatus_Bar_Height + 6.0f);
        make.right.equalTo(self.messageBtn.mas_left);
        make.bottom.equalTo(self).offset(-6.0f);
    }];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customerServiceBtn.mas_right);
        make.top.mas_equalTo(KStatus_Bar_Height + 6.0f);
        make.right.equalTo(self.messageBtn.mas_left);
        make.bottom.equalTo(self).offset(-6.0f);
    }];
}

- (UIButton *)customerServiceBtn {
    if (!_customerServiceBtn) {
        _customerServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_customerServiceBtn setImage:[UIImage imageNamed:@"icon_navi_customer_service"] forState:UIControlStateNormal];
        [_customerServiceBtn addTarget:self action:@selector(customerServiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customerServiceBtn;
}

- (UIButton *)messageBtn {
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setImage:[UIImage imageNamed:@"icon_navi_message"] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}

- (UIView *)unreadMessageView {
    if (!_unreadMessageView) {
        _unreadMessageView = [[UIView alloc] init];
        _unreadMessageView.backgroundColor = JL_color_red_D70000;
        _unreadMessageView.hidden = YES;
        ViewBorderRadius(_unreadMessageView, 4.0f, 0.0f, JL_color_clear);
    }
    return _unreadMessageView;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ViewBorderRadius(_searchBtn, (KNavigation_Height - 6.0f * 2) * 0.5f, 0.0f, JL_color_clear);
        [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.backgroundColor = JL_color_gray_F3F3F3;
        ViewBorderRadius(_searchView, (KNavigation_Height - 6.0f * 2) * 0.5f, 0.0f, JL_color_clear);
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_common_search"]];
        [_searchView addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = kFontPingFangSCRegular(13.0f);
        titleLabel.textColor = JL_color_gray_BBBBBB;
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

- (void)customerServiceBtnClick {
    if (self.customerServiceBlock) {
        self.customerServiceBlock();
    }
}

- (void)messageBtnClick {
    if (self.messageBlock) {
        self.messageBlock();
    }
}

- (void)searchBtnClick {
    if (self.searchBlock) {
        self.searchBlock();
    }
}

- (void)refreshHasMessagesUnread:(BOOL)haveMessages {
    self.unreadMessageView.hidden = !haveMessages;
}

@end
