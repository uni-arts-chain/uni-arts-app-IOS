//
//  JLAuctionDepositPayView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/20.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionDepositPayView.h"

static JLAuctionDepositPayView *payView;

@interface JLAuctionDepositPayView ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UILabel *payMoneyLabel;

@property (nonatomic, strong) UILabel *payTypeTitleLabel;

@property (nonatomic, strong) UIView *payTypeBgView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *payBtn;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *tipTitle;

@property (nonatomic, copy) NSString *payMoney;

@property (nonatomic, copy) NSString *cashAccountBalance;

@property (nonatomic, assign) JLAuctionDepositPayViewPayType payType;

@property (nonatomic, copy) NSArray *payTypeImageArray;

@property (nonatomic, copy) NSArray *payTypeTitleArray;

@property (nonatomic, copy) JLAuctionDepositPayViewCompleteBlock completeBlock;

@end

@implementation JLAuctionDepositPayView

- (instancetype)initWithFrame:(CGRect)frame title: (NSString *)title tipTitle: (NSString *)tipTitle payMoney: (NSString *)payMoney cashAccountBalance: (NSString *)cashAccountBalance
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _tipTitle = tipTitle;
        _payMoney = payMoney;
        _cashAccountBalance = cashAccountBalance;
        
        NSDecimalNumber *balance = [NSDecimalNumber decimalNumberWithString:_cashAccountBalance];
        NSDecimalNumber *buyTotal = [NSDecimalNumber decimalNumberWithString:_payMoney];
        if ([buyTotal isGreaterThan:balance]) {
            _payType = JLAuctionDepositPayViewPayTypeWechat;
        }else {
            _payType = JLAuctionDepositPayViewPayTypeCashAccount;
        }
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _maskView = [[UIView alloc] initWithFrame:self.bounds];
    _maskView.backgroundColor = JL_color_black;
    _maskView.alpha = 0;
    _maskView.userInteractionEnabled = YES;
    [_maskView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewDidTap:)]];
    [self addSubview:_maskView];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frameHeight, self.frameWidth, 402 + KTouch_Responder_Height)];
    _bgView.backgroundColor = JL_color_white_ffffff;
    [self addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = _title;
    _titleLabel.textColor = JL_color_gray_212121;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = kFontPingFangSCSCSemibold(18);
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(18);
        make.right.equalTo(self.bgView).offset(-55);
        make.left.equalTo(self.bgView).offset(55);
    }];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"icon_common_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.bgView);
        make.width.height.mas_equalTo(@51);
    }];
    
    _payMoneyLabel = [[UILabel alloc] init];
    _payMoneyLabel.text = @"需支付：";
    _payMoneyLabel.textColor = JL_color_gray_212121;
    _payMoneyLabel.textAlignment = NSTextAlignmentCenter;
    _payMoneyLabel.font = kFontPingFangSCRegular(14);
    [_bgView addSubview:_payMoneyLabel];
    [_payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(64);
    }];
    
    _payTypeTitleLabel = [[UILabel alloc] init];
    _payTypeTitleLabel.text = @"支付方式";
    _payTypeTitleLabel.textColor = JL_color_gray_212121;
    _payTypeTitleLabel.font = kFontPingFangSCMedium(17);
    [_bgView addSubview:_payTypeTitleLabel];
    [_payTypeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(106);
        make.left.equalTo(self.bgView).offset(21);
    }];
    
    _payTypeBgView = [[UIView alloc] init];
    [_bgView addSubview:_payTypeBgView];
    [_payTypeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(_payTypeTitleLabel.mas_bottom).offset(12);
    }];
    
    for (int i = 0; i < self.payTypeTitleArray.count; i++) {
        UIView *payBgView = [[UIView alloc] init];
        payBgView.tag = 100 + i;
        payBgView.userInteractionEnabled = YES;
        [payBgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payBgViewDidTap:)]];
        [_payTypeBgView addSubview:payBgView];
        [payBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.payTypeBgView).offset(42 * i);
            make.left.right.equalTo(self.payTypeBgView);
            make.height.mas_equalTo(@42);
            if (i == self.payTypeTitleArray.count - 1) {
                make.bottom.equalTo(self.payTypeBgView);
            }
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.tag = 200 + i;
        imgView.image = self.payTypeImageArray[i];
        [payBgView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(payBgView).offset(26);
            make.centerY.equalTo(payBgView);
            make.width.height.mas_equalTo(@20);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 300 + i;
        titleLabel.text = self.payTypeTitleArray[i];
        titleLabel.textColor = JL_color_gray_212121;
        titleLabel.font = kFontPingFangSCRegular(14);
        [payBgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(14);
            make.centerY.equalTo(imgView);
        }];
        
        if (i == 0) {
            // 账户余额
            titleLabel.text = [NSString stringWithFormat:@"%@（￥%@）", self.payTypeTitleArray[i], _cashAccountBalance];
            NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:titleLabel.text];
            [attrs addAttribute:NSForegroundColorAttributeName value:JL_color_gray_999999 range:NSMakeRange(((NSString *)self.payTypeTitleArray[i]).length, attrs.length - ((NSString *)self.payTypeTitleArray[i]).length)];
            titleLabel.attributedText = attrs;
        }
        
        UIImageView *statusImgView = [[UIImageView alloc] init];
        statusImgView.tag = 400 + i;
        if (i == _payType) {
            statusImgView.image = [UIImage imageNamed:@"icon_pay_method_selected"];
        }else {
            statusImgView.image = [UIImage imageNamed:@"icon_pay_method_normal"];
        }
        [payBgView addSubview:statusImgView];
        [statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(payBgView).offset(-37);
            make.centerY.equalTo(imgView);
            make.width.height.mas_equalTo(@12);
        }];
    }
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.backgroundColor = JL_color_gray_101010;
    [_payBtn setTitle:@"支付" forState:UIControlStateNormal];
    [_payBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    _payBtn.titleLabel.font = kFontPingFangSCRegular(17);
    [_payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_payBtn];
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.bottom.equalTo(self.bgView).offset(-(25 + KTouch_Responder_Height));
        make.height.mas_equalTo(@47);
    }];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.text = _tipTitle;
    _tipLabel.textColor = JL_color_gray_212121;
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.font = kFontPingFangSCRegular(12);
    [_bgView addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.bottom.equalTo(self.payBtn.mas_top).offset(-17);
    }];
    
    if (![NSString stringIsEmpty:_payMoney]) {
        NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"需支付：￥%@", _payMoney]];
        [attrs addAttribute:NSFontAttributeName value:kFontPingFangSCSCSemibold(19) range:NSMakeRange(attrs.length - _payMoney.length - 1, _payMoney.length + 1)];
        [attrs addAttribute:NSForegroundColorAttributeName value:JL_color_red_D70000 range:NSMakeRange(attrs.length - _payMoney.length - 1, _payMoney.length + 1)];
        _payMoneyLabel.attributedText = attrs;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.5;
        self.bgView.frame = CGRectMake(0, self.frameHeight - self.bgView.frameHeight, self.frameWidth, self.bgView.frameHeight);
    } completion:nil];
}

- (void)updatePayTypeUI {
    [_payTypeBgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag >= 100) {
            [obj.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.tag >= 400) {
                    if (obj.tag - 400 == self.payType) {
                        ((UIImageView *)obj).image = [UIImage imageNamed:@"icon_pay_method_selected"];
                    }else {
                        ((UIImageView *)obj).image = [UIImage imageNamed:@"icon_pay_method_normal"];
                    }
                }
            }];
        }
    }];
}

#pragma mark - event response
- (void)maskViewDidTap: (UITapGestureRecognizer *)ges {
    [self dismiss];
}

- (void)closeBtnClick: (UIButton *)sender {
    [self dismiss];
}

- (void)payBgViewDidTap: (UITapGestureRecognizer *)ges {
    if (_payType == ges.view.tag - 100) {
        return;
    }
    
    if (ges.view.tag - 100 == JLAuctionDepositPayViewPayTypeCashAccount) {
        NSDecimalNumber *balance = [NSDecimalNumber decimalNumberWithString:_cashAccountBalance];
        NSDecimalNumber *buyTotal = [NSDecimalNumber decimalNumberWithString:_payMoney];
        if ([buyTotal isGreaterThan:balance]) {
            // 余额不足
            [[JLLoading sharedLoading] showMBFailedTipMessage:@"当前现金账户余额不足!" hideTime:KToastDismissDelayTimeInterval];
            _payType = _payType == JLAuctionDepositPayViewPayTypeCashAccount ? JLAuctionDepositPayViewPayTypeWechat : _payType;
        }else {
            _payType = JLAuctionDepositPayViewPayTypeCashAccount;
        }
    }else {
        _payType = ges.view.tag - 100;
    }
    
    [self updatePayTypeUI];
}

- (void)payBtnClick: (UIButton *)sender {
    if (self.completeBlock) {
        self.completeBlock(self.payType);
    }
    [self dismiss];
}

#pragma mark - public methods
+ (void)showWithTitle: (NSString *)title tipTitle: (NSString *)tipTitle payMoney: (NSString *)payMoney cashAccountBalance: (NSString *)cashAccountBalance complete: (JLAuctionDepositPayViewCompleteBlock)complete {
    payView = [[JLAuctionDepositPayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:title tipTitle:tipTitle payMoney:payMoney cashAccountBalance:cashAccountBalance];
    payView.completeBlock = complete;
    [[UIApplication sharedApplication].keyWindow addSubview:payView];
}

#pragma mark - private methods
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.bgView.frame = CGRectMake(0, self.frameHeight, self.bgView.frameWidth, self.bgView.frameHeight);
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
        payView = nil;
    }];
}

#pragma mark - setters and getters
- (NSArray *)payTypeImageArray {
    if (!_payTypeImageArray) {
        _payTypeImageArray = @[[UIImage imageNamed:@"cash_account_icon"],
                               [UIImage imageNamed:@"icon_paymethod_wechat"],
                               [UIImage imageNamed:@"icon_paymethod_alipay"]];
    }
    return _payTypeImageArray;
}

- (NSArray *)payTypeTitleArray {
    if (!_payTypeTitleArray) {
        _payTypeTitleArray = @[@"账户余额",@"微信支付", @"支付宝支付"];
    }
    return _payTypeTitleArray;
}

- (void)dealloc
{
    NSLog(@"释放了: %@", self.class);
}

@end
