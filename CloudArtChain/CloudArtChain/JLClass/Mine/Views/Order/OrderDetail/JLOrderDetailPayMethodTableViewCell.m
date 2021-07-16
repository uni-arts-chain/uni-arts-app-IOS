//
//  JLOrderDetailPayMethodTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/15.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLOrderDetailPayMethodTableViewCell.h"

static const CGFloat KMethodViewHeight = 43.0f;

@interface JLOrderDetailPayMethodTableViewCell ()
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *payMethodView;
@property (nonatomic, strong) NSArray *payImageArray;
@property (nonatomic, strong) NSArray *payTitleArray;
@property (nonatomic, strong) NSMutableArray *selectedButtonArray;
@end

@implementation JLOrderDetailPayMethodTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.shadowView];
    [self.shadowView addSubview:self.shadowImageView];
    [self.shadowView addSubview:self.titleLabel];
    [self.shadowView addSubview:self.payMethodView];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(5.0f);
        make.bottom.mas_equalTo(-5.0f);
    }];
    [self.shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shadowView);
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
        make.bottom.equalTo(self.shadowView).offset(-10.0f);
    }];
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
    }
    return _shadowView;
}

- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [JLUIFactory imageViewInitImageName:@"icon_address_back"];
    }
    return _shadowImageView;
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
    
    if (index == self.payType) {
        selectedButton.selected = YES;
        self.payType = index;
        if (self.selectedMethodBlock) {
            self.selectedMethodBlock(index);
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
    NSDecimalNumber *buyTotal = [NSDecimalNumber decimalNumberWithString:_buyTotalPrice];
    if (sender.tag == JLOrderPayTypeCashAccount && [buyTotal isGreaterThan:balance]) {
        // 余额不足支付
        if (self.payType == JLOrderPayTypeCashAccount) {
            self.payType = JLOrderPayTypeWeChat;
        }
        
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"当前现金账户余额不足，已切换为其他支付方式!" hideTime:KToastDismissDelayTimeInterval];
    }else {
        self.payType = sender.tag;
    }
    UIButton *currentSelectedBtn = self.selectedButtonArray[self.payType];
    currentSelectedBtn.selected = YES;
    if (self.selectedMethodBlock) {
        self.selectedMethodBlock(self.payType);
    }
}

- (void)setBuyTotalPrice:(NSString *)buyTotalPrice {
    _buyTotalPrice = buyTotalPrice;
    
    NSDecimalNumber *balance = [NSDecimalNumber decimalNumberWithString:_cashAccountBalance];
    NSDecimalNumber *buyTotal = [NSDecimalNumber decimalNumberWithString:_buyTotalPrice];
    
    if (self.payType == JLOrderPayTypeCashAccount) {
        if ([buyTotal isGreaterThan:balance]) {
            // 余额不足
            [[JLLoading sharedLoading] showMBFailedTipMessage:@"当前现金账户余额不足，已切换为其他支付方式!" hideTime:KToastDismissDelayTimeInterval];
            
            self.payType = JLOrderPayTypeWeChat;
            for (UIButton *selectedButton in self.selectedButtonArray) {
                selectedButton.selected = NO;
            }
            UIButton *currentSelectedBtn = self.selectedButtonArray[self.payType];
            currentSelectedBtn.selected = YES;
            if (self.selectedMethodBlock) {
                self.selectedMethodBlock(self.payType);
            }
        }
    }else {
        for (UIButton *selectedButton in self.selectedButtonArray) {
            selectedButton.selected = NO;
        }
        UIButton *currentSelectedBtn = self.selectedButtonArray[self.payType];
        currentSelectedBtn.selected = YES;
    }
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
@end
