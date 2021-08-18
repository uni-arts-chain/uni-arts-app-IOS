//
//  JLAuctionSubmitOrderContentPayTypeView.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionSubmitOrderContentPayTypeView.h"

static const CGFloat KMethodViewHeight = 43.0f;

@interface JLAuctionSubmitOrderContentPayTypeView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *payMethodView;
@property (nonatomic, strong) NSArray *payImageArray;
@property (nonatomic, strong) NSArray *payTitleArray;
@property (nonatomic, strong) NSMutableArray *selectedButtonArray;

/// 现金账户余额
@property (nonatomic, copy) NSString *cashAccountBalance;
/// 当前需要购买的总金额
@property (nonatomic, copy) NSString *payMoney;
/// 当前选择的支付方式
@property (nonatomic, assign) JLOrderPayTypeName payType;

@end

@implementation JLAuctionSubmitOrderContentPayTypeView

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
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.payMethodView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(17.0f);
    }];
    [self.payMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(self.payImageArray.count * KMethodViewHeight);
        make.bottom.equalTo(self.bgView).offset(-10.0f);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addShadow:JL_color_gray_999999 cornerRadius:5 offset:CGSizeMake(0, 0)];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"支付方式" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UIView *)payMethodView {
    if (!_payMethodView) {
        _payMethodView = [[UIView alloc] init];
        [self.selectedButtonArray removeAllObjects];
        for (int i = 0; i < self.payImageArray.count; i++) {
            UIView *methodView = [self createMethodView:i];
            [_payMethodView addSubview:methodView];
            [methodView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_payMethodView);
                make.height.mas_equalTo(KMethodViewHeight);
                make.top.mas_equalTo(i * KMethodViewHeight);
            }];
        }
    }
    return _payMethodView;
}

- (UIView *)createMethodView:(NSInteger)index  {
    UIView *methodView = [[UIView alloc] init];
    
    UIImageView *maskImageView = [[UIImageView alloc] init];
    maskImageView.image = self.payImageArray[index];
    [methodView addSubview:maskImageView];
    
    UILabel *titleLabel = [JLUIFactory labelInitText:self.payTitleArray[index] font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    [methodView addSubview:titleLabel];
    
    UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedButton setImage:[UIImage imageNamed:@"icon_pay_method_normal"] forState:UIControlStateNormal];
    [selectedButton setImage:[UIImage imageNamed:@"icon_pay_method_selected"] forState:UIControlStateSelected];
    [methodView addSubview:selectedButton];
    
    if (index == [self payTypeIndex]) {
        selectedButton.selected = YES;
        self.payType = [self payTypeFromIndex:index];
        if (self.selectedMethodBlock) {
            self.selectedMethodBlock(self.payType);
        }
    }
    [self.selectedButtonArray addObject:selectedButton];
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.tag = index;
    [selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [methodView addSubview:selectButton];
    
    [maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(3.0f);
        make.size.mas_equalTo(23.0f);
        make.centerY.equalTo(methodView.mas_centerY);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maskImageView.mas_right).offset(13.0f);
        make.centerY.equalTo(methodView.mas_centerY);
    }];
    [selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(methodView);
        make.size.mas_equalTo(13.0f);
        make.centerY.equalTo(methodView.mas_centerY);
    }];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(methodView);
    }];
    return methodView;
}

- (void)selectButtonClick:(UIButton *)sender {
    for (UIButton *selectedButton in self.selectedButtonArray) {
        selectedButton.selected = NO;
    }
    
    NSDecimalNumber *balance = [NSDecimalNumber decimalNumberWithString:_cashAccountBalance];
    NSDecimalNumber *buyTotal = [NSDecimalNumber decimalNumberWithString:_payMoney];
    if (sender.tag == 0 && [buyTotal isGreaterThan:balance]) {
        // 余额不足支付
        if (self.payType == JLOrderPayTypeNameAccount) {
            self.payType = JLOrderPayTypeNameWepay;
        }
        
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"当前现金账户余额不足，已切换为其他支付方式!" hideTime:KToastDismissDelayTimeInterval];
    }else {
        self.payType = [self payTypeFromIndex:sender.tag];
    }
    UIButton *currentSelectedBtn = self.selectedButtonArray[[self payTypeIndex]];
    currentSelectedBtn.selected = YES;
    if (self.selectedMethodBlock) {
        self.selectedMethodBlock(self.payType);
    }
}

- (NSInteger)payTypeIndex {
    NSInteger index = 0;
    if (self.payType == JLOrderPayTypeNameAccount) {
        index = 0;
    }else if (self.payType == JLOrderPayTypeNameWepay) {
        index = 1;
    }else if (self.payType == JLOrderPayTypeNameAlipay) {
        index = 2;
    }
    return index;
}

- (JLOrderPayTypeName)payTypeFromIndex: (NSInteger)index {
    JLOrderPayTypeName payType = JLOrderPayTypeNameAccount;
    if (index == 0) {
        payType = JLOrderPayTypeNameAccount;
    }else if (index == 1) {
        payType = JLOrderPayTypeNameWepay;
    }else if (index == 2) {
        payType = JLOrderPayTypeNameAlipay;
    }
    return payType;
}

- (NSArray *)payImageArray {
    if (!_payImageArray) {
        _payImageArray = @[[UIImage imageNamed:@"cash_account_icon"],
                           [UIImage imageNamed:@"icon_paymethod_wechat"],
                           [UIImage imageNamed:@"icon_paymethod_alipay"]];
    }
    return _payImageArray;
}

- (NSArray *)payTitleArray {
    if (!_payTitleArray) {
        _payTitleArray = @[@"账户余额",@"微信支付", @"支付宝支付"];
    }
    return _payTitleArray;
}

- (NSMutableArray *)selectedButtonArray {
    if (!_selectedButtonArray) {
        _selectedButtonArray = [NSMutableArray array];
    }
    return _selectedButtonArray;
}

#pragma mark - public
- (void)setCashAccountBalance: (NSString *)cashAccountBalance payMoney: (NSString *)payMoney payType:(JLOrderPayTypeName)payType {
    _cashAccountBalance = cashAccountBalance;
    _payMoney = payMoney;
    _payType = payType;
    
    NSDecimalNumber *balance = [NSDecimalNumber decimalNumberWithString:_cashAccountBalance];
    NSDecimalNumber *buyTotal = [NSDecimalNumber decimalNumberWithString:_payMoney];
    
    if (self.payType == JLOrderPayTypeNameAccount) {
        if ([buyTotal isGreaterThan:balance]) {
            // 余额不足
            [[JLLoading sharedLoading] showMBFailedTipMessage:@"当前现金账户余额不足，已切换为其他支付方式!" hideTime:KToastDismissDelayTimeInterval];
            
            self.payType = JLOrderPayTypeNameWepay;
            for (UIButton *selectedButton in self.selectedButtonArray) {
                selectedButton.selected = NO;
            }
            UIButton *currentSelectedBtn = self.selectedButtonArray[[self payTypeIndex]];
            currentSelectedBtn.selected = YES;
            if (self.selectedMethodBlock) {
                self.selectedMethodBlock(self.payType);
            }
        }
    }else {
        for (UIButton *selectedButton in self.selectedButtonArray) {
            selectedButton.selected = NO;
        }
        UIButton *currentSelectedBtn = self.selectedButtonArray[[self payTypeIndex]];
        currentSelectedBtn.selected = YES;
    }
}

@end
