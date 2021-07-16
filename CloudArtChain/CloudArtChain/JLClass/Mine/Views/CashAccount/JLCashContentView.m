//
//  JLCashContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLCashContentView.h"

@interface JLCashContentView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *alipayQRCodeImgView;

@property (nonatomic, strong) UIImageView *wechatQRCodeImgView;

@property (nonatomic, strong) UIImageView *alipaySelectImgView;

@property (nonatomic, strong) UIImageView *wechatSelectImgView;

@property (nonatomic, strong) UIButton *alipayDeleteBtn;

@property (nonatomic, strong) UIButton *wechatDeleteBtn;

@property (nonatomic, strong) UIButton *alipayUpBtn;

@property (nonatomic, strong) UIButton *wechatUpBtn;

@property (nonatomic, strong) UIButton *withdrawBtn;

@property (nonatomic, strong) UIView *alipayBgView;

@property (nonatomic, strong) UIImageView *alipayIconImgView;

@property (nonatomic, strong) UILabel *alipayTitleLabel;

@property (nonatomic, strong) UIView *wechatBgView;

@property (nonatomic, strong) UIImageView *wechatIconImgView;

@property (nonatomic, strong) UILabel *wechatTitleLabel;

@property (nonatomic, strong) MASConstraint *alipayQRCodeImgViewHeightConstraint;

@property (nonatomic, strong) MASConstraint *wechatQRCodeImgViewHeightConstraint;

@property (nonatomic, strong) MASConstraint *withdrawBtnTopConstraint;

@property (nonatomic, strong) UIImage *alipayQRCodeImage;

@property (nonatomic, strong) UIImage *wechatQRCodeImage;

/// 1: 支付宝 2: 微信
@property (nonatomic, assign) NSInteger currentSelectQRCodeType;

@property (nonatomic, strong) UIImage *currentSelectQRCodeImage;

@end

@implementation JLCashContentView

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
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _bgView = [[UIView alloc] init];
    [_scrollView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    _alipayUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _alipayUpBtn.backgroundColor = JL_color_gray_EFEFEF;
    _alipayUpBtn.layer.cornerRadius = 5;
    [_alipayUpBtn setTitle:@"上传图片" forState:UIControlStateNormal];
    [_alipayUpBtn setTitleColor:JL_color_gray_666666 forState:UIControlStateNormal];
    _alipayUpBtn.titleLabel.font = kFontPingFangSCRegular(13);
    [_alipayUpBtn setImage:[UIImage imageNamed:@"icon_mine_upload_add"] forState:UIControlStateNormal];
    [_alipayUpBtn setImagePosition:LXMImagePositionTop spacing:10];
    [_alipayUpBtn addTarget:self action:@selector(alipayUpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_alipayUpBtn];
    [_alipayUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(18);
        make.left.equalTo(self.bgView).offset(40);
        make.width.height.mas_equalTo(@((self.frameWidth - 130) / 2));
    }];
    
    _alipayQRCodeImgView = [[UIImageView alloc] init];
    _alipayQRCodeImgView.hidden = YES;
    _alipayQRCodeImgView.layer.cornerRadius = 5;
    _alipayQRCodeImgView.clipsToBounds = YES;
    _alipayQRCodeImgView.userInteractionEnabled = YES;
    [_alipayQRCodeImgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alipayQRCodeImgViewDidTap:)]];
    [_bgView addSubview:_alipayQRCodeImgView];
    [_alipayQRCodeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(18);
        make.left.equalTo(self.bgView).offset(40);
        make.width.mas_equalTo(@((self.frameWidth - 130) / 2));
        self.alipayQRCodeImgViewHeightConstraint = make.height.mas_equalTo(@((self.frameWidth - 130) / 2));
    }];
    
    _alipaySelectImgView = [[UIImageView alloc] init];
    _alipaySelectImgView.hidden = YES;
    _alipaySelectImgView.image = [UIImage imageNamed:@"cash_qr_code_selected_icon"];
    [_alipayQRCodeImgView addSubview:_alipaySelectImgView];
    [_alipaySelectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.alipayQRCodeImgView).offset(-5);
        make.right.equalTo(self.alipayQRCodeImgView).offset(-5);
        make.width.height.mas_equalTo(@23);
    }];
    
    _alipayDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _alipayDeleteBtn.hidden = YES;
    [_alipayDeleteBtn setImage:[UIImage imageNamed:@"cash_qr_code_delete_icon"] forState:UIControlStateNormal];
    [_alipayDeleteBtn addTarget:self action:@selector(alipayDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_alipayDeleteBtn];
    [_alipayDeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alipayQRCodeImgView).offset(-12);
        make.right.equalTo(self.alipayQRCodeImgView).offset(12);
        make.width.height.mas_equalTo(@24);
    }];
    
    _wechatUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _wechatUpBtn.backgroundColor = JL_color_gray_EFEFEF;
    _wechatUpBtn.layer.cornerRadius = 5;
    [_wechatUpBtn setTitle:@"上传图片" forState:UIControlStateNormal];
    [_wechatUpBtn setTitleColor:JL_color_gray_666666 forState:UIControlStateNormal];
    _wechatUpBtn.titleLabel.font = kFontPingFangSCRegular(13);
    [_wechatUpBtn setImage:[UIImage imageNamed:@"icon_mine_upload_add"] forState:UIControlStateNormal];
    [_wechatUpBtn setImagePosition:LXMImagePositionTop spacing:10];
    [_wechatUpBtn addTarget:self action:@selector(wechatUpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_wechatUpBtn];
    [_wechatUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(18);
        make.right.equalTo(self.bgView).offset(-40);
        make.width.height.mas_equalTo(@((self.frameWidth - 130) / 2));
    }];
    
    _wechatQRCodeImgView = [[UIImageView alloc] init];
    _wechatQRCodeImgView.hidden = YES;
    _wechatQRCodeImgView.layer.cornerRadius = 5;
    _wechatQRCodeImgView.clipsToBounds = YES;
    _wechatQRCodeImgView.userInteractionEnabled = YES;
    [_wechatQRCodeImgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechatQRCodeImgViewDidTap:)]];
    [_bgView addSubview:_wechatQRCodeImgView];
    [_wechatQRCodeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(18);
        make.right.equalTo(self.bgView).offset(-40);
        make.width.mas_equalTo(@((self.frameWidth - 130) / 2));
        self.wechatQRCodeImgViewHeightConstraint = make.height.mas_equalTo(@((self.frameWidth - 130) / 2));
    }];
    
    _wechatSelectImgView = [[UIImageView alloc] init];
    _wechatSelectImgView.hidden = YES;
    _wechatSelectImgView.image = [UIImage imageNamed:@"cash_qr_code_selected_icon"];
    [_wechatQRCodeImgView addSubview:_wechatSelectImgView];
    [_wechatSelectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.wechatQRCodeImgView).offset(-5);
        make.right.equalTo(self.wechatQRCodeImgView).offset(-5);
        make.width.height.mas_equalTo(@23);
    }];
    
    _wechatDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _wechatDeleteBtn.hidden = YES;
    [_wechatDeleteBtn setImage:[UIImage imageNamed:@"cash_qr_code_delete_icon"] forState:UIControlStateNormal];
    [_wechatDeleteBtn addTarget:self action:@selector(wechatDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_wechatDeleteBtn];
    [_wechatDeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatQRCodeImgView).offset(-12);
        make.right.equalTo(self.wechatQRCodeImgView).offset(12);
        make.width.height.mas_equalTo(@24);
    }];
    
    _alipayBgView = [[UIView alloc] init];
    [_bgView addSubview:_alipayBgView];
    [_alipayBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alipayUpBtn.mas_bottom).offset(23);
        make.centerX.equalTo(self.alipayUpBtn);
    }];
    
    _alipayIconImgView = [[UIImageView alloc] init];
    _alipayIconImgView.image = [UIImage imageNamed:@"icon_paymethod_alipay"];
    [_alipayBgView addSubview:_alipayIconImgView];
    [_alipayIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.alipayBgView);
        make.width.height.mas_equalTo(@18);
    }];
    
    _alipayTitleLabel = [[UILabel alloc] init];
    _alipayTitleLabel.text = @"支付宝收款码";
    _alipayTitleLabel.textColor = JL_color_gray_101010;
    _alipayTitleLabel.font = kFontPingFangSCRegular(14);
    [_alipayBgView addSubview:_alipayTitleLabel];
    [_alipayTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.alipayBgView);
        make.left.equalTo(self.alipayIconImgView.mas_right).offset(5);
    }];
    
    _wechatBgView = [[UIView alloc] init];
    [_bgView addSubview:_wechatBgView];
    [_wechatBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatUpBtn.mas_bottom).offset(23);
        make.centerX.equalTo(self.wechatUpBtn);
    }];
    
    _wechatIconImgView = [[UIImageView alloc] init];
    _wechatIconImgView.image = [UIImage imageNamed:@"icon_paymethod_wechat"];
    [_wechatBgView addSubview:_wechatIconImgView];
    [_wechatIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.wechatBgView);
        make.width.height.mas_equalTo(@18);
    }];
    
    _wechatTitleLabel = [[UILabel alloc] init];
    _wechatTitleLabel.text = @"微信收款码";
    _wechatTitleLabel.textColor = JL_color_gray_101010;
    _wechatTitleLabel.font = kFontPingFangSCRegular(14);
    [_wechatBgView addSubview:_wechatTitleLabel];
    [_wechatTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.wechatBgView);
        make.left.equalTo(self.wechatIconImgView.mas_right).offset(5);
    }];
    
    _withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _withdrawBtn.hidden = YES;
    _withdrawBtn.backgroundColor = JL_color_black;
    [_withdrawBtn setTitle:@"申请提现" forState:UIControlStateNormal];
    [_withdrawBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    _withdrawBtn.titleLabel.font = kFontPingFangSCSCSemibold(16);
    _withdrawBtn.layer.cornerRadius = 22;
    _withdrawBtn.layer.masksToBounds = YES;
    [_withdrawBtn addTarget:self action:@selector(withdrawBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_withdrawBtn];
    [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        self.withdrawBtnTopConstraint = make.top.equalTo(self.alipayBgView.mas_bottom).offset(40);
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.height.mas_equalTo(@44);
        make.bottom.equalTo(self.bgView).offset(-20);
    }];
    
}

- (void)updateUI: (NSInteger)type {
    
    if (type == 0) {
        if (self.alipayQRCodeImage) {
            _alipayUpBtn.hidden = YES;
            _alipayQRCodeImgView.hidden = NO;
            _alipayDeleteBtn.hidden = NO;
            _alipayQRCodeImgView.image = self.alipayQRCodeImage;
            
            [_alipayQRCodeImgViewHeightConstraint uninstall];
            [_alipayQRCodeImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                self.alipayQRCodeImgViewHeightConstraint =  make.height.mas_equalTo(@(self.alipayQRCodeImage.size.height * ((self.frameWidth - 130) / 2) / self.alipayQRCodeImage.size.width));
            }];
            
            [_alipayBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.alipayQRCodeImgView.mas_bottom).offset(23);
                make.centerX.equalTo(self.alipayQRCodeImgView);
            }];
        }else {
            _alipayUpBtn.hidden = NO;
            _alipayQRCodeImgView.hidden = YES;
            _alipayDeleteBtn.hidden = YES;
            _alipaySelectImgView.hidden = YES;
            
            [_alipayBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.alipayUpBtn.mas_bottom).offset(23);
                make.centerX.equalTo(self.alipayUpBtn);
            }];
        }
    }else {
        if (self.wechatQRCodeImage) {
            _wechatUpBtn.hidden = YES;
            _wechatQRCodeImgView.hidden = NO;
            _wechatDeleteBtn.hidden = NO;
            _wechatQRCodeImgView.image = self.wechatQRCodeImage;
            
            [_wechatQRCodeImgViewHeightConstraint uninstall];
            [_wechatQRCodeImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                self.wechatQRCodeImgViewHeightConstraint =  make.height.mas_equalTo(@(self.wechatQRCodeImage.size.height * ((self.frameWidth - 130) / 2) / self.wechatQRCodeImage.size.width));
            }];
            
            [_wechatBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.wechatQRCodeImgView.mas_bottom).offset(23);
                make.centerX.equalTo(self.wechatQRCodeImgView);
            }];
        }else {
            _wechatUpBtn.hidden = NO;
            _wechatQRCodeImgView.hidden = YES;
            _wechatDeleteBtn.hidden = YES;
            _wechatSelectImgView.hidden = YES;
            
            [_wechatBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.wechatUpBtn.mas_bottom).offset(23);
                make.centerX.equalTo(self.wechatUpBtn);
            }];
        }
    }
    
    _withdrawBtn.hidden = NO;
    if (self.wechatQRCodeImage == nil && self.alipayQRCodeImage == nil) {
        _withdrawBtn.hidden = YES;
        
        [_withdrawBtnTopConstraint uninstall];
        [_withdrawBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            self.withdrawBtnTopConstraint = make.top.equalTo(self.alipayBgView.mas_bottom).offset(40);
        }];
    }else if (self.alipayQRCodeImage != nil && self.wechatQRCodeImage == nil) {
        if ((self.alipayQRCodeImage.size.height * ((self.frameWidth - 130) / 2) / self.alipayQRCodeImage.size.width) > ((self.frameWidth - 130) / 2)) {
            [_withdrawBtnTopConstraint uninstall];
            [_withdrawBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                self.withdrawBtnTopConstraint = make.top.equalTo(self.alipayBgView.mas_bottom).offset(40);
            }];
        }else {
            [_withdrawBtnTopConstraint uninstall];
            [_withdrawBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                self.withdrawBtnTopConstraint = make.top.equalTo(self.wechatBgView.mas_bottom).offset(40);
            }];
        }
    }else if (self.alipayQRCodeImage == nil && self.wechatQRCodeImage != nil) {
        if ((self.wechatQRCodeImage.size.height * ((self.frameWidth - 130) / 2) / self.wechatQRCodeImage.size.width) > ((self.frameWidth - 130) / 2)) {
            [_withdrawBtnTopConstraint uninstall];
            [_withdrawBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                self.withdrawBtnTopConstraint = make.top.equalTo(self.wechatBgView.mas_bottom).offset(40);
            }];
        }else {
            [_withdrawBtnTopConstraint uninstall];
            [_withdrawBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                self.withdrawBtnTopConstraint = make.top.equalTo(self.alipayBgView.mas_bottom).offset(40);
            }];
        }
    }else {
        if ((self.alipayQRCodeImage.size.height * ((self.frameWidth - 130) / 2) / self.alipayQRCodeImage.size.width) > (self.wechatQRCodeImage.size.height * ((self.frameWidth - 130) / 2) / self.wechatQRCodeImage.size.width)) {
            [_withdrawBtnTopConstraint uninstall];
            [_withdrawBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                self.withdrawBtnTopConstraint = make.top.equalTo(self.alipayBgView.mas_bottom).offset(40);
            }];
        }else {
            [_withdrawBtnTopConstraint uninstall];
            [_withdrawBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                self.withdrawBtnTopConstraint = make.top.equalTo(self.wechatBgView.mas_bottom).offset(40);
            }];
        }
    }
}

- (void)updateSelectUI: (NSInteger)type {
    
    if (type == 0) {
        _alipaySelectImgView.hidden = NO;
        _alipayQRCodeImgView.layer.borderColor = JL_color_orange_FFB432.CGColor;
        _alipayQRCodeImgView.layer.borderWidth = 1;
        [_alipayQRCodeImgView addShadow:JL_color_orange_FFB432 cornerRadius:5.0f offsetX:0];
        _alipayQRCodeImgView.layer.cornerRadius = 5;
        _alipayQRCodeImgView.clipsToBounds = YES;

        if (self.wechatQRCodeImage) {
            _wechatSelectImgView.hidden = YES;
            _wechatQRCodeImgView.layer.borderColor = JL_color_clear.CGColor;
            _wechatQRCodeImgView.layer.borderWidth = 1;
            [_wechatQRCodeImgView addShadow:JL_color_clear cornerRadius:5.0f offsetX:0];
            _wechatQRCodeImgView.layer.cornerRadius = 5;
            _wechatQRCodeImgView.clipsToBounds = YES;
        }
    }else {
        _wechatSelectImgView.hidden = NO;
        _wechatQRCodeImgView.layer.borderColor = JL_color_orange_FFB432.CGColor;
        _wechatQRCodeImgView.layer.borderWidth = 1;
        [_wechatQRCodeImgView addShadow:JL_color_orange_FFB432 cornerRadius:5.0f offsetX:0];
        _wechatQRCodeImgView.layer.cornerRadius = 5;
        _wechatQRCodeImgView.clipsToBounds = YES;
        
        if (self.alipayQRCodeImage) {
            _alipaySelectImgView.hidden = YES;
            _alipayQRCodeImgView.layer.borderColor = JL_color_clear.CGColor;
            _alipayQRCodeImgView.layer.borderWidth = 1;
            [_alipayQRCodeImgView addShadow:JL_color_clear cornerRadius:5.0f offsetX:0];
            _alipayQRCodeImgView.layer.cornerRadius = 5;
            _alipayQRCodeImgView.clipsToBounds = YES;
        }
    }
}

#pragma mark - event response
- (void)alipayUpBtnClick: (UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(addImage:)]) {
        [_delegate addImage:0];
    }
}

- (void)wechatUpBtnClick: (UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(addImage:)]) {
        [_delegate addImage:1];
    }
}

- (void)alipayQRCodeImgViewDidTap: (UITapGestureRecognizer *)ges {
    self.currentSelectQRCodeType = 1;
    self.currentSelectQRCodeImage = self.alipayQRCodeImage;
    
    [self updateSelectUI:0];
}

- (void)wechatQRCodeImgViewDidTap: (UITapGestureRecognizer *)ges {
    self.currentSelectQRCodeType = 2;
    self.currentSelectQRCodeImage = self.wechatQRCodeImage;
    
    [self updateSelectUI:1];
}

- (void)alipayDeleteBtnClick: (UIButton *)sender {
    self.alipayQRCodeImage = nil;
    if (self.currentSelectQRCodeType == 1) {
        self.currentSelectQRCodeImage = nil;
        self.currentSelectQRCodeType = 0;
    }
    
    _alipayQRCodeImgView.layer.borderColor = JL_color_clear.CGColor;
    _alipayQRCodeImgView.layer.borderWidth = 1;
    [_alipayQRCodeImgView addShadow:JL_color_clear cornerRadius:5.0f offsetX:0];
    _alipayQRCodeImgView.layer.cornerRadius = 5;
    _alipayQRCodeImgView.clipsToBounds = YES;
    
    [self updateUI:0];
}

- (void)wechatDeleteBtnClick: (UIButton *)sender {
    self.wechatQRCodeImage = nil;
    if (self.currentSelectQRCodeType == 2) {
        self.currentSelectQRCodeImage = nil;
        self.currentSelectQRCodeType = 0;
    }
    
    _wechatQRCodeImgView.layer.borderColor = JL_color_clear.CGColor;
    _wechatQRCodeImgView.layer.borderWidth = 1;
    [_wechatQRCodeImgView addShadow:JL_color_clear cornerRadius:5.0f offsetX:0];
    _wechatQRCodeImgView.layer.cornerRadius = 5;
    _wechatQRCodeImgView.clipsToBounds = YES;
    
    [self updateUI:1];
}

- (void)withdrawBtnClick: (UIButton *)sender {
    if (!self.currentSelectQRCodeImage) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请选择提现的收款码!" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(withdraw:)]) {
        [_delegate withdraw:self.currentSelectQRCodeImage];
    }
}

#pragma mark - setters and getters
- (void)setAlipayQRCodeImageUrl:(NSString *)alipayQRCodeImageUrl {
    _alipayQRCodeImageUrl = alipayQRCodeImageUrl;
    
    WS(weakSelf)
    [_alipayQRCodeImgView sd_setImageWithURL:[NSURL URLWithString:_alipayQRCodeImageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            weakSelf.alipayQRCodeImage = image;
                        
            [weakSelf updateUI:0];
        }
    }];
}

- (void)setWechatQRCodeImageUrl:(NSString *)wechatQRCodeImageUrl {
    _wechatQRCodeImageUrl = wechatQRCodeImageUrl;
    
    WS(weakSelf)
    [_wechatIconImgView sd_setImageWithURL:[NSURL URLWithString:_wechatQRCodeImageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            weakSelf.wechatQRCodeImage = image;
                        
            [weakSelf updateUI:1];
        }
    }];
}

- (void)setAddAlipayQRCodeImage:(UIImage *)addAlipayQRCodeImage {
    _addAlipayQRCodeImage = addAlipayQRCodeImage;
    
    self.alipayQRCodeImage = _addAlipayQRCodeImage;
    
    [self updateUI:0];
}

- (void)setAddWechatQRCodeImage:(UIImage *)addWechatQRCodeImage {
    _addWechatQRCodeImage = addWechatQRCodeImage;
    
    self.wechatQRCodeImage = _addWechatQRCodeImage;
    
    [self updateUI:1];
}

@end
