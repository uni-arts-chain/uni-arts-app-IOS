//
//  JLOrderDetailContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLOrderDetailContentView.h"
#import "NSDate+Extension.h"

@interface JLOrderDetailContentView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *successBgView;

@property (nonatomic, strong) UIImageView *successImgView;

@property (nonatomic, strong) UILabel *successTitleLabel;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *orderNoLabel;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *cerAddressLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *totalTitleLabel;
@property (nonatomic, strong) UILabel *priceTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *royaltyLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *orderInfoTitleLabel;
@property (nonatomic, strong) UILabel *orderNoTitleLabel;
@property (nonatomic, strong) UILabel *orderNoNumLabel;
@property (nonatomic, strong) UILabel *timeTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *pasteBtn;
@end

@implementation JLOrderDetailContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _scrollView = [[UIScrollView alloc] init];
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.image = [[UIImage imageNamed:@"order_detail_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(300, 100, 50, 100) resizingMode:UIImageResizingModeStretch];
    [_scrollView addSubview:_bgImgView];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    _successBgView = [[UIView alloc] init];
    [_bgImgView addSubview:_successBgView];
    [_successBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView).offset(KStatus_Bar_Height + 55.0f);
        make.centerX.equalTo(self.bgImgView);
    }];
    
    _successImgView = [[UIImageView alloc] init];
    _successImgView.image = [UIImage imageNamed:@"order_detail_success_icon"];
    [_successBgView addSubview:_successImgView];
    [_successImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.successBgView);
        make.width.height.mas_equalTo(@81);
    }];
    
    _successTitleLabel = [[UILabel alloc] init];
    _successTitleLabel.text = @"订单详情";
    _successTitleLabel.textColor = JL_color_white_ffffff;
    _successTitleLabel.font = kFontPingFangSCSCSemibold(19);
    [_successBgView addSubview:_successTitleLabel];
    [_successTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.successImgView.mas_right).offset(17);
        make.right.equalTo(self.successBgView);
        make.centerY.equalTo(self.successImgView);
    }];
    
    _bgView = [[UIView alloc] init];
    [_scrollView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.successBgView.mas_bottom).offset(64);
        make.left.equalTo(self.bgImgView).offset(28);
        make.right.equalTo(self.bgImgView).offset(-28);
        make.bottom.equalTo(self.bgImgView).offset(-22);
    }];
    
    _orderNoLabel = [[UILabel alloc] init];
    _orderNoLabel.textColor = JL_color_gray_87888F;
    _orderNoLabel.font = kFontPingFangSCMedium(13.0f);
    [_bgView addSubview:_orderNoLabel];
    [_orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
    }];
    
    _productImageView = [[UIImageView alloc] init];
    _productImageView.contentMode = UIViewContentModeScaleAspectFit;
    _productImageView.layer.cornerRadius = 5;
    _productImageView.clipsToBounds = YES;
    [_bgImgView addSubview:_productImageView];
    [_productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNoLabel.mas_bottom).offset(13);
        make.left.equalTo(self.orderNoLabel);
        make.width.height.mas_equalTo(@56);
    }];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.textColor = JL_color_gray_101010;
    _numLabel.font = kFontPingFangSCRegular(13.0f);
    [_bgView addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.productImageView.mas_top);
    }];
    
    _productNameLabel = [[UILabel alloc] init];
    _productNameLabel.font = kFontPingFangSCSCSemibold(15.0f);
    _productNameLabel.textColor = JL_color_black_101220;
    [_bgView addSubview:_productNameLabel];
    [_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(12.0f);
        make.top.equalTo(self.productImageView.mas_top).offset(-3.0f);
        make.right.equalTo(self.bgView).offset(-30.0f);
    }];
    
    _authorLabel = [[UILabel alloc] init];
    _authorLabel.textColor = JL_color_black_40414D;
    _authorLabel.font = kFontPingFangSCRegular(13.0f);
    [_bgView addSubview:_authorLabel];
    [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
        make.right.equalTo(self.bgView);
        make.centerY.equalTo(self.productImageView.mas_centerY).offset(2.0f);
    }];
    
    _cerAddressLabel = [[UILabel alloc] init];
    _cerAddressLabel.textColor = JL_color_black_40414D;
    _cerAddressLabel.font = kFontPingFangSCRegular(13.0f);
    [_bgView addSubview:_cerAddressLabel];
    [_cerAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productNameLabel.mas_left);
        make.bottom.equalTo(self.productImageView.mas_bottom).offset(3.0f);
        make.right.equalTo(self.bgView);
    }];
    
    _totalTitleLabel = [[UILabel alloc] init];
    _totalTitleLabel.text = @"商品总价";
    _totalTitleLabel.textColor = JL_color_black_40414D;
    _totalTitleLabel.font = kFontPingFangSCRegular(13.0f);
    [_bgView addSubview:_totalTitleLabel];
    [_totalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productImageView.mas_bottom).offset(14);
        make.left.equalTo(self.productImageView);
    }];
    
    _royaltyLabel = [[UILabel alloc] init];
    _royaltyLabel.textColor = JL_color_red_EF4136;
    _royaltyLabel.font = kFontPingFangSCRegular(14.0f);
    _royaltyLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_royaltyLabel];
    [_royaltyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView);
        make.centerY.equalTo(self.totalTitleLabel);
    }];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = JL_color_red_EF4136;
    _priceLabel.font = kFontPingFangSCRegular(14.0f);
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.royaltyLabel.mas_left);
        make.centerY.equalTo(self.totalTitleLabel);
    }];
    
    _priceTitleLabel = [[UILabel alloc] init];
    _priceTitleLabel.text = @"实收款 ";
    _priceTitleLabel.textColor = JL_color_red_EF4136;
    _priceTitleLabel.font = kFontPingFangSCRegular(14.0f);
    _priceTitleLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_priceTitleLabel];
    [_priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel.mas_left);
        make.centerY.equalTo(self.totalTitleLabel);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_EDEDEE;
    [_bgView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalTitleLabel.mas_bottom).offset(14);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(@1);
    }];
    
    _orderInfoTitleLabel = [[UILabel alloc] init];
    _orderInfoTitleLabel.text = @"订单信息";
    _orderInfoTitleLabel.font = kFontPingFangSCSCSemibold(16.0f);
    _orderInfoTitleLabel.textColor = JL_color_black_101220;
    [_bgView addSubview:_orderInfoTitleLabel];
    [_orderInfoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(16);
        make.left.equalTo(self.bgView);
    }];
    
    _orderNoTitleLabel = [[UILabel alloc] init];
    _orderNoTitleLabel.text = @"订单编号";
    _orderNoTitleLabel.textColor = JL_color_gray_87888F;
    _orderNoTitleLabel.font = kFontPingFangSCRegular(14);
    [_bgView addSubview:_orderNoTitleLabel];
    [_orderNoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderInfoTitleLabel);
        make.top.equalTo(self.orderInfoTitleLabel.mas_bottom).offset(10);
    }];
    
    _orderNoNumLabel = [[UILabel alloc] init];
    _orderNoNumLabel.textColor = JL_color_black_40414D;
    _orderNoNumLabel.font = kFontPingFangSCRegular(14.0f);
    [_bgView addSubview:_orderNoNumLabel];
    [_orderNoNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(72);
        make.centerY.equalTo(self.orderNoTitleLabel);
        make.right.equalTo(self.bgView).offset(-65);
    }];
    
    _timeTitleLabel = [[UILabel alloc] init];
    _timeTitleLabel.text = @"创建时间";
    _timeTitleLabel.textColor = JL_color_gray_87888F;
    _timeTitleLabel.font = kFontPingFangSCRegular(14);
    [_bgView addSubview:_timeTitleLabel];
    [_timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderInfoTitleLabel);
        make.top.equalTo(self.orderNoTitleLabel.mas_bottom).offset(17);
        make.bottom.equalTo(self.bgView);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = JL_color_black_40414D;
    _timeLabel.font = kFontPingFangSCRegular(14.0f);
    [_bgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.orderNoNumLabel);
        make.centerY.equalTo(self.timeTitleLabel);
    }];
    
    _pasteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pasteBtn setTitle:@"复制" forState:UIControlStateNormal];
    [_pasteBtn setTitleColor:JL_color_red_EF4136 forState:UIControlStateNormal];
    _pasteBtn.titleLabel.font = kFontPingFangSCRegular(12.0f);
    [_pasteBtn addTarget:self action:@selector(pasteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_pasteBtn];
    [_pasteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(10);
        make.centerY.equalTo(self.orderNoTitleLabel);
        make.width.height.mas_equalTo(@44);
    }];
    
}

#pragma mark - event response
- (void)pasteBtnClick: (UIButton *)sender {
    [UIPasteboard generalPasteboard].string = self.orderData.sn;
    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"复制成功" hideTime:KToastDismissDelayTimeInterval];
}

#pragma mark - setters and getters
- (void)setOrderData:(Model_arts_sold_Data *)orderData {
    _orderData = orderData;
    
    self.orderNoLabel.text = [NSString stringWithFormat:@"订单编号: %@", orderData.sn];
    if (![NSString stringIsEmpty:orderData.art.img_main_file1[@"url"]]) {
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:orderData.art.img_main_file1[@"url"]]];
    }
    self.authorLabel.text = [NSString stringIsEmpty:orderData.art.author.display_name] ? @"" : orderData.art.author.display_name;
    self.productNameLabel.text = orderData.art.name;
    self.cerAddressLabel.text = [NSString stringWithFormat:@"NFT地址：%@", [NSString stringIsEmpty:orderData.art.item_hash] ? @"" : orderData.art.item_hash];
    self.numLabel.text = [NSString stringWithFormat:@"x%@", [NSDecimalNumber decimalNumberWithString:orderData.amount].stringValue];
    _orderNoNumLabel.text = orderData.sn;
    NSDate *buy_time = [NSDate dateWithTimeIntervalSince1970:orderData.finished_at.doubleValue];
    _timeLabel.text = [NSString stringWithFormat:@"%@", [buy_time dateWithCustomFormat:@"yyyy/MM/dd HH:mm:ss"]];
    
    if (_orderDetailType == JLOrderDetailTypeSell) {
        NSDecimalNumber *priceNumber = [NSDecimalNumber decimalNumberWithString:orderData.price];
        NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:orderData.amount];
        NSDecimalNumber *totalPriceNumber = [priceNumber decimalNumberByMultiplyingBy:amountNumber];
        self.priceTitleLabel.text = @"实收款 ";
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", totalPriceNumber.stringValue];
        self.royaltyLabel.text = @"";
    } else {
        self.priceTitleLabel.text = @"实付款 ";
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", orderData.total_price];
        self.royaltyLabel.text = [NSString stringWithFormat:@"(含版税¥%@)", orderData.royalty];
    }
}

@end
