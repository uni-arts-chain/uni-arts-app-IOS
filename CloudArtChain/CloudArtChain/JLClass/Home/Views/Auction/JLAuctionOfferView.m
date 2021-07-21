//
//  JLAuctionOfferView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionOfferView.h"

static JLAuctionOfferView *offerView;
@interface JLAuctionOfferView ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *currentPriceLabel;

@property (nonatomic, strong) UILabel *offerPriceLabel;

@property (nonatomic, strong) UILabel *addPriceLabel;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, copy) NSString *currentPrice;

@property (nonatomic, copy) NSString *offerPrice;

@property (nonatomic, copy) NSString *addPrice;

@property (nonatomic, copy) JLAuctionOfferViewOfferBlock offerBlock;

@end

@implementation JLAuctionOfferView

- (instancetype)initWithFrame:(CGRect)frame currentPrice: (NSString *)currentPrice offerPrice: (NSString *)offerPrice addPrice: (NSString *)addPrice
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentPrice = currentPrice;
        _offerPrice = offerPrice;
        _addPrice = addPrice;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _maskView = [[UIView alloc] initWithFrame:self.bounds];
    _maskView.backgroundColor = JL_color_black;
    _maskView.alpha = 0;
    [self addSubview:_maskView];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 284, 300)];
    _bgView.alpha = 0;
    _bgView.center = self.center;
    _bgView.backgroundColor = JL_color_white_ffffff;
    [self addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"确认出价";
    _titleLabel.textColor = JL_color_gray_212121;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = kFontPingFangSCSCSemibold(18);
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(32);
        make.left.right.equalTo(self.bgView);
    }];
    
    _currentPriceLabel = [[UILabel alloc] init];
    _currentPriceLabel.textColor = JL_color_gray_212121;
    _currentPriceLabel.textAlignment = NSTextAlignmentCenter;
    _currentPriceLabel.font = kFontPingFangSCRegular(14);
    [_bgView addSubview:_currentPriceLabel];
    [_currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(11);
        make.left.right.equalTo(self.titleLabel);
    }];
    
    _offerPriceLabel = [[UILabel alloc] init];
    _offerPriceLabel.text = [NSString stringWithFormat:@"您已出价 ￥%@", _offerPrice];
    _offerPriceLabel.textColor = JL_color_gray_212121;
    _offerPriceLabel.textAlignment = NSTextAlignmentCenter;
    _offerPriceLabel.font = kFontPingFangSCRegular(15);
    [_bgView addSubview:_offerPriceLabel];
    [_offerPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentPriceLabel.mas_bottom).offset(40);
        make.left.right.equalTo(self.currentPriceLabel);
    }];
    
    _addPriceLabel = [[UILabel alloc] init];
    _addPriceLabel.text = [NSString stringWithFormat:@"至少还需加价 ￥%@", _offerPrice];
    _addPriceLabel.textColor = JL_color_gray_212121;
    _addPriceLabel.textAlignment = NSTextAlignmentCenter;
    _addPriceLabel.font = kFontPingFangSCRegular(15);
    [_bgView addSubview:_addPriceLabel];
    [_addPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.offerPriceLabel.mas_bottom).offset(1);
        make.left.right.equalTo(self.offerPriceLabel);
    }];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"icon_common_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.bgView);
        make.width.height.mas_equalTo(@51);
    }];
    
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn.backgroundColor = JL_color_gray_101010;
    [_doneBtn setTitle:@"立即出价" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = kFontPingFangSCRegular(16);
    [_doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_doneBtn];
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(35);
        make.right.equalTo(self.bgView).offset(-35);
        make.bottom.equalTo(self.bgView).offset(-35);
        make.height.mas_equalTo(@47);
    }];
    
    [self updateData];
    
    _bgView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.maskView.alpha = 0.5;
        self.bgView.alpha = 1;
        self.bgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
}

#pragma mark - event response
- (void)closeBtnClick: (UIButton *)sender {
    [self dismiss];
}

- (void)doneBtnClick: (UIButton *)sender {
    
    NSDecimalNumber *current = [NSDecimalNumber decimalNumberWithString:_currentPrice];
    NSDecimalNumber *add = [NSDecimalNumber decimalNumberWithString:_addPrice];
    NSDecimalNumber *result = [current decimalNumberByAdding:add];
    
    if (self.offerBlock) {
        self.offerBlock(result.stringValue);
    }
    [self dismiss];
}

#pragma mark - public methods
/// 出价
/// @param currentPrice 当前最高出价
/// @param offerPrice 自己已经出价
/// @param addPrice 每次加价
/// @param done 完成回调
+ (void)showWithCurrentPrice: (NSString *)currentPrice offerPrice: (NSString *)offerPrice addPrice: (NSString *)addPrice done: (JLAuctionOfferViewOfferBlock)done {
    offerView = [[JLAuctionOfferView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) currentPrice:currentPrice offerPrice:offerPrice addPrice:addPrice];
    offerView.offerBlock = done;
    [[UIApplication sharedApplication].keyWindow addSubview:offerView];
}

#pragma mark - private methods
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
        offerView = nil;
    }];
}

- (void)updateData {
    NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前价：￥%@", _currentPrice]];
    [attrs addAttribute:NSForegroundColorAttributeName value:JL_color_red_D70000 range:NSMakeRange(attrs.length - _currentPrice.length - 1, _currentPrice.length + 1)];
    _currentPriceLabel.attributedText = attrs;
    
    NSDecimalNumber *current = [NSDecimalNumber decimalNumberWithString:_currentPrice];
    NSDecimalNumber *offer = [NSDecimalNumber decimalNumberWithString:_offerPrice];
    NSDecimalNumber *add = [NSDecimalNumber decimalNumberWithString:_addPrice];
    NSDecimalNumber *lessThanAdd = [[current decimalNumberBySubtracting:offer] decimalNumberByAdding:add];
    _addPriceLabel.text = [NSString stringWithFormat:@"至少还需加价 ￥%@", lessThanAdd.stringValue];

    NSDecimalNumber *result = [current decimalNumberByAdding:add];
    [_doneBtn setTitle:[NSString stringWithFormat:@"立即出价￥%@", result.stringValue] forState:UIControlStateNormal];
}

- (void)dealloc
{
    NSLog(@"释放了: %@", self.class);
}

@end
