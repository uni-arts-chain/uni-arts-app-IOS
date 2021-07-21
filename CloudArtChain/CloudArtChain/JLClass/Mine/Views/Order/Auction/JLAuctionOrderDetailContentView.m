//
//  JLAuctionOrderDetailContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/20.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionOrderDetailContentView.h"
#import "JLAuctionOrderDetailArtInfoView.h"
#import "JLAuctionOrderDetailOrderInfoView.h"
#import "JLAuctionOrderDetailBottomView.h"
#import "LSTTimer.h"

@interface JLAuctionOrderDetailContentView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UILabel *countdownLabel;

@property (nonatomic, strong) JLAuctionOrderDetailArtInfoView *artInfoView;

@property (nonatomic, strong) JLAuctionOrderDetailOrderInfoView *orderInfoView;

@property (nonatomic, strong) JLAuctionOrderDetailBottomView *bottomView;

@property (nonatomic, strong) MASConstraint *scrollViewBottomConstraint;

@end

@implementation JLAuctionOrderDetailContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    WS(weakSelf)
    _bottomView = [[JLAuctionOrderDetailBottomView alloc] init];
    _bottomView.payMoney = @"950.0";
    _bottomView.payBlock = ^(NSString * _Nonnull payMoney) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(payOrder:)]) {
            [weakSelf.delegate payOrder:payMoney];
        }
    };
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(@(45 + KTouch_Responder_Height));
    }];
    
    _countdownLabel = [[UILabel alloc] init];
    _countdownLabel.text = @"请在47:59:59内完成支付，否则将会扣除保证金";
    _countdownLabel.textColor = JL_color_red_D70000;
    _countdownLabel.font = kFontPingFangSCRegular(14);
    _countdownLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_countdownLabel];
    [_countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-15);
    }];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = JL_color_white_ffffff;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        self.scrollViewBottomConstraint =  make.bottom.equalTo(self.countdownLabel.mas_top).offset(-10);
    }];
    
    _bgView = [[UIView alloc] init];
    [_scrollView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.text = @"待支付";
    _statusLabel.textColor = JL_color_gray_212121;
    _statusLabel.font = kFontPingFangSCMedium(21);
    [_bgView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(12);
        make.left.equalTo(self.bgView).offset(15);
    }];
    
    _artInfoView = [[JLAuctionOrderDetailArtInfoView alloc] init];
    [_bgView addSubview:_artInfoView];
    [_artInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(13);
    }];
    
    _orderInfoView = [[JLAuctionOrderDetailOrderInfoView alloc] init];
    [_bgView addSubview:_orderInfoView];
    [_orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.artInfoView.mas_bottom).offset(8);
        make.bottom.equalTo(self.bgView);
    }];
    
    
    [self createTimer];
}

- (void)createTimer {
    
    WS(weakSelf)
    //时分秒
    [LSTTimer addMinuteTimerForTime:10000 handle:^(NSString * _Nonnull day, NSString * _Nonnull hour, NSString * _Nonnull minute, NSString * _Nonnull second, NSString * _Nonnull ms) {
        
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
            weakSelf.statusLabel.text = @"交易关闭";
            weakSelf.countdownLabel.hidden = YES;
            weakSelf.bottomView.hidden = YES;
            [weakSelf.scrollViewBottomConstraint uninstall];
            [weakSelf.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                weakSelf.scrollViewBottomConstraint =  make.bottom.equalTo(weakSelf);
            }];
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshData)]) {
                [weakSelf.delegate refreshData];
            }
        }
    }];
}

- (void)dealloc
{
    NSLog(@"释放了: %@", self.class);
}

@end
