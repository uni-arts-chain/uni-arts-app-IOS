//
//  JLActionOfferView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLActionOfferView.h"
#import "UIButton+TouchArea.h"
#import "JLBaseTextField.h"

@interface JLActionOfferView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *priceNoticeLabel;
@property (nonatomic, strong) UIView *priceView;
@property (nonatomic, strong) JLBaseTextField *priceTF;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UIButton *offerButton;
@end

@implementation JLActionOfferView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeButton];
    [self addSubview:self.priceNoticeLabel];
    [self addSubview:self.priceView];
    [self.priceView addSubview:self.priceTF];
    [self addSubview:self.unitLabel];
    [self addSubview:self.noticeLabel];
    [self addSubview:self.offerButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(65.0f);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12.0f);
        make.right.mas_equalTo(-15.0f);
        make.size.mas_equalTo(13.0f);
    }];
    [self.priceNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32.0f);
        make.right.mas_equalTo(-32.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.0f);
    }];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceNoticeLabel.mas_bottom).offset(20.0f);
        make.width.mas_equalTo(155.0f);
        make.height.mas_equalTo(40.0f);
        make.centerX.equalTo(self);
    }];
    [self.priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.mas_equalTo(-20.0f);
        make.top.bottom.equalTo(self.priceView);
    }];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceView.mas_right).offset(13.0f);
        make.centerY.equalTo(self.priceView.mas_centerY);
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.priceView.mas_bottom).offset(25.0f);
    }];
    [self.offerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-25.0f);
        make.width.mas_equalTo(156.0f);
        make.height.mas_equalTo(40.0f);
        make.centerX.equalTo(self);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"确认出价" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"icon_action_offer_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton edgeTouchAreaWithTop:12.0f right:12.0f bottom:12.0f left:12.0f];
    }
    return _closeButton;
}

- (void)closeButtonClick {
    [LEEAlert closeWithCompletionBlock:nil];
}

- (UILabel *)priceNoticeLabel {
    if (!_priceNoticeLabel) {
        _priceNoticeLabel = [JLUIFactory labelInitText:@"当前价 1200 UART，您已出价 1100 UART，至少还需加价 200 UART" font:kFontPingFangSCRegular(11.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_priceNoticeLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0f;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, _priceNoticeLabel.text.length)];
        
        NSRange currentPriceRange = [_priceNoticeLabel.text rangeOfString:@"1200"];
        [attr addAttributes:@{NSFontAttributeName: kFontPingFangSCSCSemibold(11.0f)} range:NSMakeRange(currentPriceRange.location, 4)];
        
        NSRange offeredPriceRange = [_priceNoticeLabel.text rangeOfString:@"1100"];
        [attr addAttributes:@{NSFontAttributeName: kFontPingFangSCSCSemibold(11.0f)} range:NSMakeRange(offeredPriceRange.location, 4)];
        
        NSRange addPriceRange = [_priceNoticeLabel.text rangeOfString:@"200" options:NSBackwardsSearch];
        [attr addAttributes:@{NSForegroundColorAttributeName: JL_color_red_D70000, NSFontAttributeName: kFontPingFangSCSCSemibold(11.0f)} range:NSMakeRange(addPriceRange.location, 3)];
        _priceNoticeLabel.attributedText = attr;
    }
    return _priceNoticeLabel;
}

- (UIView *)priceView {
    if (!_priceView) {
        _priceView = [[UIView alloc] init];
        ViewBorderRadius(_priceView, 5.0f, 1.0f, JL_color_gray_A4A4A4);
    }
    return _priceView;
}

- (JLBaseTextField *)priceTF {
    if (!_priceTF) {
        _priceTF = [[JLBaseTextField alloc]init];
        _priceTF.font = kFontPingFangSCMedium(15.0f);
        _priceTF.textColor = JL_color_gray_101010;
        _priceTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _priceTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _priceTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _priceTF.spellCheckingType = UITextSpellCheckingTypeNo;
        _priceTF.keyboardType = UIKeyboardTypeDecimalPad;
        NSDictionary *dic = @{NSForegroundColorAttributeName:JL_color_gray_CCCCCC, NSFontAttributeName:kFontPingFangSCRegular(15.0f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"请输入价格" attributes:dic];
        _priceTF.attributedPlaceholder = attr;
    }
    return _priceTF;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [JLUIFactory labelInitText:@"UART" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _unitLabel;
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [JLUIFactory labelInitText:@"如未拍中，将在拍卖结束后退回出价金额" font:kFontPingFangSCRegular(11.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _noticeLabel;
}

- (UIButton *)offerButton {
    if (!_offerButton) {
        _offerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_offerButton setTitle:@"立即出价" forState:UIControlStateNormal];
        _offerButton.titleLabel.font = kFontPingFangSCRegular(16.0f);
        [_offerButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _offerButton.backgroundColor = JL_color_blue_50C3FF;
        ViewBorderRadius(_offerButton, 20.0f, 0.0f, JL_color_clear);
        [_offerButton addTarget:self action:@selector(offerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _offerButton;
}

- (void)offerButtonClick {
    if (![NSString stringIsEmpty:self.priceTF.text]) {
        [self endEditing:YES];
        [self closeButtonClick];
        if (self.offerBlock) {
            self.offerBlock(self.priceTF.text);
        }
    }
}
@end
