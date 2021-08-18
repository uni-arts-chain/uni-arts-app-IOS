//
//  JLAuctionOrderDetailOrderInfoView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/20.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionOrderDetailOrderInfoView.h"
#import "NSDate+Extension.h"

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
        self.backgroundColor = JL_color_white_ffffff;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _bgView = [[UIView alloc] init];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
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
    _timeLabel.textColor = JL_color_gray_212121;
    _timeLabel.font = kFontPingFangSCRegular(14);
    [_bgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNoTitleLabel);
        make.top.equalTo(self.orderNoLabel.mas_bottom).offset(16);
        make.bottom.equalTo(self.bgView).offset(-30);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addShadow:JL_color_gray_999999 cornerRadius:5 offset:CGSizeMake(0, 0)];
}

#pragma mark - event response
- (void)pasetBtnClick: (UIButton *)sender {
    [UIPasteboard generalPasteboard].string = _orderNoLabel.text;
    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"复制成功" hideTime:KToastDismissDelayTimeInterval];
}

- (void)setOrderData:(Model_arts_sold_Data *)orderData {
    _orderData = orderData;
    
    _orderNoLabel.text = _orderData.sn;
    NSDate *buy_time = [NSDate dateWithTimeIntervalSince1970:_orderData.finished_at.doubleValue];
    _timeLabel.text = [buy_time dateWithCustomFormat:@"yyyy/MM/dd HH:mm:ss"];
}

@end
