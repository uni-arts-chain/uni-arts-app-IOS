//
//  JLAuctionOrderDetailOrderInfoView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/20.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionOrderDetailOrderInfoView.h"

@interface JLAuctionOrderDetailOrderInfoView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *orderNoTitleLabel;

@property (nonatomic, strong) UILabel *orderNoLabel;

@property (nonatomic, strong) UIButton *pasetBtn;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation JLAuctionOrderDetailOrderInfoView

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
    _bgView.backgroundColor = JL_color_white_ffffff;
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.shadowColor = [UIColor colorWithHexString:@"#404040" alpha:0.16].CGColor;
    _bgView.layer.shadowOpacity = 1.0f;
    _bgView.layer.shadowOffset = CGSizeMake(0, 0);
    _bgView.layer.shadowRadius = 5.0f;
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-5);
        make.right.equalTo(self).offset(-15);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"订单信息";
    _titleLabel.textColor = JL_color_gray_212121;
    _titleLabel.font = kFontPingFangSCMedium(15);
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(16);
        make.left.equalTo(self.bgView).offset(10);
    }];
    
    _orderNoTitleLabel = [[UILabel alloc] init];
    _orderNoTitleLabel.text = @"订单号：";
    _orderNoTitleLabel.textColor = JL_color_gray_212121;
    _orderNoTitleLabel.font = kFontPingFangSCRegular(14);
    [_bgView addSubview:_orderNoTitleLabel];
    [_orderNoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(19);
        make.left.equalTo(self.titleLabel);
    }];
    
    _orderNoLabel = [[UILabel alloc] init];
    _orderNoLabel.text = @"fdafkjifsajofsosjiofjsaio";
    _orderNoLabel.textColor = JL_color_gray_212121;
    _orderNoLabel.font = kFontPingFangSCRegular(14);
    _orderNoLabel.numberOfLines = 0;
    _orderNoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_bgView addSubview:_orderNoLabel];
    [_orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNoTitleLabel);
        make.left.equalTo(self.orderNoTitleLabel.mas_right);
        make.right.equalTo(self.bgView).offset(-60);
    }];
    
    _pasetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pasetBtn setTitle:@"复制" forState:UIControlStateNormal];
    [_pasetBtn setTitleColor:JL_color_red_D70000 forState:UIControlStateNormal];
    _pasetBtn.titleLabel.font = kFontPingFangSCRegular(14);
    [_pasetBtn addTarget:self action:@selector(pasetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_pasetBtn];
    [_pasetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView);
        make.centerY.equalTo(self.orderNoTitleLabel);
        make.width.height.mas_equalTo(@60);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"创建时间：2020/08/16 12:36:28";
    _timeLabel.textColor = JL_color_gray_212121;
    _timeLabel.font = kFontPingFangSCRegular(14);
    [_bgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNoTitleLabel);
        make.top.equalTo(self.orderNoLabel.mas_bottom).offset(16);
        make.bottom.equalTo(self.bgView).offset(-30);
    }];
    
}

#pragma mark - event response
- (void)pasetBtnClick: (UIButton *)sender {
    [UIPasteboard generalPasteboard].string = _orderNoLabel.text;
    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"复制成功" hideTime:KToastDismissDelayTimeInterval];
}

@end
