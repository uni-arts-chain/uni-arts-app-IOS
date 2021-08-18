//
//  JLAuctionSubmitOrderContentBottomView.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionSubmitOrderContentBottomView.h"

@interface JLAuctionSubmitOrderContentBottomView ()

@property (nonatomic, strong) UILabel *payMoneyLabel;

@property (nonatomic, strong) UIButton *payBtn;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation JLAuctionSubmitOrderContentBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _payMoneyLabel = [[UILabel alloc] init];
    _payMoneyLabel.text = @"待支付：";
    _payMoneyLabel.textColor = JL_color_gray_212121;
    _payMoneyLabel.font = kFontPingFangSCRegular(14);
    [self addSubview:_payMoneyLabel];
    [_payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(27);
        make.centerY.equalTo(self).offset(-(KTouch_Responder_Height / 2));
    }];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.backgroundColor = JL_color_black;
    _payBtn.layer.cornerRadius = 15;
    _payBtn.layer.masksToBounds = YES;
    [_payBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [_payBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    _payBtn.titleLabel.font = kFontPingFangSCRegular(15);
    [_payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_payBtn];
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self).offset(-(KTouch_Responder_Height / 2));
        make.size.mas_equalTo(CGSizeMake(118, 30));
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(@1);
    }];
}

#pragma mark - event response
- (void)payBtnClick: (UIButton *)sender {
    if (self.payBlock) {
        self.payBlock(self.payMoney);
    }
}

#pragma mark - setters and getters
- (void)setPayMoney:(NSString *)payMoney {
    _payMoney = payMoney;
    
    if (![NSString stringIsEmpty:_payMoney]) {
        NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"待支付：￥%@",_payMoney]];
        [attrs addAttribute:NSForegroundColorAttributeName value:JL_color_red_D70000 range:NSMakeRange(attrs.length - _payMoney.length - 1, _payMoney.length + 1)];
        _payMoneyLabel.attributedText = attrs;
    }
}

@end
