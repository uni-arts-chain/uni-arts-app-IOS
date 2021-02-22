//
//  JLLogisticsView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/19.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLLogisticsView.h"
#import "UIButton+TouchArea.h"

@interface JLLogisticsView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UILabel *LogisticsOrderNoLabel;
@property (nonatomic, strong) UIButton *noCopyButton;
@end

@implementation JLLogisticsView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeButton];
    [self addSubview:self.noticeLabel];
    [self addSubview:self.LogisticsOrderNoLabel];
    [self addSubview:self.noCopyButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(65.0f);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12.0f);
        make.right.mas_equalTo(-14.0f);
        make.size.mas_equalTo(13.0f);
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(29.0f);
    }];
    [self.LogisticsOrderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.noticeLabel.mas_bottom);
        make.height.mas_equalTo(75.0f);
    }];
    [self.noCopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.LogisticsOrderNoLabel.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(156.0f);
        make.height.mas_equalTo(40.0f);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"查看物流" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"icon_order_logistics_close"] forState:UIControlStateNormal];
        [_closeButton edgeTouchAreaWithTop:12.0f right:12.0f bottom:12.0f left:12.0f];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)closeButtonClick {
    [LEEAlert closeWithCompletionBlock:nil];
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [JLUIFactory labelInitText:@"复制物流单号，使用支付宝查询信息" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentCenter];
    }
    return _noticeLabel;
}

- (UILabel *)LogisticsOrderNoLabel {
    if (!_LogisticsOrderNoLabel) {
        _LogisticsOrderNoLabel = [JLUIFactory labelInitText:@"JT5023428523176" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _LogisticsOrderNoLabel;
}

- (UIButton *)noCopyButton {
    if (!_noCopyButton) {
        _noCopyButton = [JLUIFactory buttonInitTitle:@"复制" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_50C3FF font:kFontPingFangSCRegular(16.0f) addTarget:self action:@selector(noCopyButtonClick)];
        _noCopyButton.contentEdgeInsets = UIEdgeInsetsZero;
        ViewBorderRadius(_noCopyButton, 20.0f, 0.0f, JL_color_clear);
    }
    return _noCopyButton;
}

- (void)noCopyButtonClick {
    [UIPasteboard generalPasteboard].string = self.LogisticsOrderNoLabel.text;
    [[JLLoading sharedLoading] showMBFailedTipMessage:@"复制成功" hideTime:KToastDismissDelayTimeInterval];
}

@end
