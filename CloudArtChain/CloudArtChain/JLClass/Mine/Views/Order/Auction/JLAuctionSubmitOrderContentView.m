//
//  JLAuctionSubmitOrderContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionSubmitOrderContentView.h"
#import "JLAuctionSubmitOrderContentInfoView.h"
#import "JLAuctionSubmitOrderContentPayTypeView.h"
#import "JLAuctionSubmitOrderContentBottomView.h"
#import "LSTTimer.h"

@interface JLAuctionSubmitOrderContentView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) JLAuctionSubmitOrderContentInfoView *infoView;

@property (nonatomic, strong) JLAuctionSubmitOrderContentPayTypeView *payTypeView;

@property (nonatomic, strong) JLAuctionSubmitOrderContentBottomView *bottomView;

@property (nonatomic, strong) UILabel *countdownLabel;

@property (nonatomic, strong) Model_auctions_Data *auctionsData;

@property (nonatomic, copy) NSString *cashAccountBalance;

@property (nonatomic, assign) JLOrderPayTypeName payType;

@end

@implementation JLAuctionSubmitOrderContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _payType = JLOrderPayTypeNameAccount;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    WS(weakSelf)
    
    _bottomView = [[JLAuctionSubmitOrderContentBottomView alloc] init];
    _bottomView.hidden = YES;
    _bottomView.payBlock = ^(NSString * _Nonnull payMoney) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(payOrder:money:)]) {
            [weakSelf.delegate payOrder:weakSelf.payType money:payMoney];
        }
    };
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(@(45 + KTouch_Responder_Height));
    }];
    
    _countdownLabel = [[UILabel alloc] init];
    _countdownLabel.hidden = YES;
    _countdownLabel.textColor = JL_color_red_D70000;
    _countdownLabel.font = kFontPingFangSCRegular(14);
    _countdownLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_countdownLabel];
    [_countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-15);
    }];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.hidden = YES;
    _scrollView.backgroundColor = JL_color_white_ffffff;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.mj_header = [JLRefreshHeader headerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshData)]) {
            [weakSelf.delegate refreshData];
        }
    }];
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.countdownLabel.mas_top).offset(-10);
    }];
    
    _bgView = [[UIView alloc] init];
    [_scrollView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    _infoView = [[JLAuctionSubmitOrderContentInfoView alloc] init];
    [_bgView addSubview:_infoView];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.top.equalTo(self.bgView).offset(20);
    }];
    
    _payTypeView = [[JLAuctionSubmitOrderContentPayTypeView alloc] init];
    _payTypeView.selectedMethodBlock = ^(JLOrderPayTypeName  _Nonnull payType) {
        weakSelf.payType = payType;
    };
    [_bgView addSubview:_payTypeView];
    [_payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.top.equalTo(self.infoView.mas_bottom).offset(20);
        make.bottom.equalTo(self.bgView).offset(-10);
    }];
}

- (void)createTimer {
    WS(weakSelf)
    // 剩余支付时间
    NSInteger hasPayTime = _auctionsData.end_time.integerValue + _auctionsData.pay_timeout.integerValue - _auctionsData.server_timestamp.integerValue;
    //时分秒
    [LSTTimer addMinuteTimerForTime:hasPayTime handle:^(NSString * _Nonnull day, NSString * _Nonnull hour, NSString * _Nonnull minute, NSString * _Nonnull second, NSString * _Nonnull ms) {
        
        NSInteger realHour = day.integerValue * 24 + hour.integerValue;
        NSString *realHourStr = @(realHour).stringValue;
        if (realHour < 10) {
            realHourStr = [NSString stringWithFormat:@"0%ld", realHour];
        }
        weakSelf.countdownLabel.text = [NSString stringWithFormat:@"请在%@:%@:%@内完成支付，否则将会扣除保证金", realHourStr, minute, second];
        
        NSInteger secondResult = 0;
        if (![day isEqualToString:@"00"]) {
            secondResult = day.integerValue * 24 * 60 * 60;
        }
        if (![hour isEqualToString:@"00"]) {
            secondResult = secondResult + hour.integerValue * 60 * 60;
        }
        if (![minute isEqualToString:@"00"]) {
            secondResult = secondResult + minute.integerValue * 60;
        }
        if (![second isEqualToString:@"00"]) {
            secondResult = secondResult + second.integerValue;
        }
        
        if (secondResult == 0) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(overduePayment)]) {
                [weakSelf.delegate overduePayment];
            }
        }
    }];
}

/// 最终实付款
- (NSDecimalNumber *)getResultPayMoney {
    // 拍中价格
    NSDecimalNumber *winPrice = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    if (![NSString stringIsEmpty:_auctionsData.win_price]) {
        winPrice = [NSDecimalNumber decimalNumberWithString:_auctionsData.win_price];
    }
    // 版税价格
    NSDecimalNumber *royaltyPrice = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    if (![NSString stringIsEmpty:_auctionsData.royalty] &&
        [[NSDecimalNumber decimalNumberWithString:_auctionsData.royalty] isGreaterThanZero]) {
        royaltyPrice = [NSDecimalNumber decimalNumberWithString:_auctionsData.royalty];
    }
    // 保证金
    NSDecimalNumber *depositPrice = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    if (![NSString stringIsEmpty:_auctionsData.deposit_amount]) {
        depositPrice = [NSDecimalNumber decimalNumberWithString:_auctionsData.deposit_amount];
    }
    // 最终实付价格
    NSDecimalNumber *resultPrice = [[winPrice decimalNumberByAdding:royaltyPrice] decimalNumberBySubtracting: depositPrice];
    
    return resultPrice;
}

#pragma mark - public
- (void)setAuctionsData:(Model_auctions_Data *)auctionsData cashAccountBalance:(NSString *)cashAccountBalance {
    _auctionsData = auctionsData;
    _cashAccountBalance = cashAccountBalance;
    
    if ([_scrollView.mj_header isRefreshing]) {
        [_scrollView.mj_header endRefreshing];
    }
    
    _scrollView.hidden = NO;
    _bottomView.hidden = NO;
    _countdownLabel.hidden = NO;
    
    [self createTimer];
    
    // 最终实付价格
    NSDecimalNumber *resultPrice = [self getResultPayMoney];
    
    _infoView.auctionsData = _auctionsData;
    
    [_payTypeView setCashAccountBalance:_cashAccountBalance payMoney:resultPrice.stringValue payType:_payType];
    
    _bottomView.payMoney = resultPrice.stringValue;
}

@end
