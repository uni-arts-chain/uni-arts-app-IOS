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

@property (nonatomic, strong) UIView *alipayQRCodeBgView;

@property (nonatomic, strong) UIImageView *alipayQRCodeImgView;

@property (nonatomic, strong) UIView *wechatQRCodBgView;

@property (nonatomic, strong) UIImageView *wechatQRCodeImgView;

@property (nonatomic, strong) UIImageView *alipaySelectImgView;

@property (nonatomic, strong) UIImageView *wechatSelectImgView;

@property (nonatomic, strong) UIButton *alipayDeleteBtn;

@property (nonatomic, strong) UIButton *wechatDeleteBtn;

@property (nonatomic, strong) UIButton *alipayUpBtn;

@property (nonatomic, strong) UIButton *wechatUpBtn;

@property (nonatomic, strong) UIButton *withdrawBtn;

@property (nonatomic, strong) UIButton *withdrawTipBtn;

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

@property (nonatomic, assign) BOOL isNeedUploadQRImage;

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
    
    _alipayQRCodeBgView = [[UIView alloc] init];
    _alipayQRCodeBgView.hidden = YES;
    [_bgView insertSubview:_alipayQRCodeBgView belowSubview:_alipayQRCodeImgView];
    [_alipayQRCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.alipayQRCodeImgView);
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
    
    _wechatQRCodBgView = [[UIView alloc] init];
    _wechatQRCodBgView.hidden = YES;
    [_bgView insertSubview:_wechatQRCodBgView belowSubview:_wechatQRCodeImgView];
    [_wechatQRCodBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.wechatQRCodeImgView);
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
    }];
    
    _withdrawTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _withdrawTipBtn.hidden = YES;
    _withdrawTipBtn.userInteractionEnabled = NO;
    [_withdrawTipBtn setTitle:@"申请提现后，资金将会在3个工作日内到账，请注意查收！" forState:UIControlStateNormal];
    [_withdrawTipBtn setTitleColor:JL_color_orange_F59C01 forState:UIControlStateNormal];
    _withdrawTipBtn.titleLabel.font = kFontPingFangSCRegular(12);
    [_withdrawTipBtn setImage:[UIImage imageNamed:@"cash_withdraw_tip_icon"] forState:UIControlStateNormal];
    [_withdrawTipBtn setImagePosition:LXMImagePositionLeft spacing:5];
    [_bgView addSubview:_withdrawTipBtn];
    [_withdrawTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawBtn.mas_bottom);
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.height.mas_equalTo(@52);
        make.bottom.equalTo(self.bgView).offset(-20);
    }];
}

- (void)updateUI {
    // 默认样式 没有收款码
    _alipayUpBtn.hidden = NO;
    _alipayQRCodeBgView.hidden = YES;
    _alipayQRCodeImgView.hidden = YES;
    _alipayDeleteBtn.hidden = YES;
    
    _wechatUpBtn.hidden = NO;
    _wechatQRCodBgView.hidden = YES;
    _wechatQRCodeImgView.hidden = YES;
    _wechatDeleteBtn.hidden = YES;
    
    _withdrawBtn.hidden = YES;
    _withdrawTipBtn.hidden = YES;
    
    // 默认布局
    [_alipayBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alipayUpBtn.mas_bottom).offset(23);
        make.centerX.equalTo(self.alipayUpBtn);
    }];
    [_wechatBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatUpBtn.mas_bottom).offset(23);
        make.centerX.equalTo(self.wechatUpBtn);
    }];
    [_withdrawBtnTopConstraint uninstall];
    [_withdrawBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        self.withdrawBtnTopConstraint = make.top.equalTo(self.alipayBgView.mas_bottom).offset(40);
    }];
    
    if (_alipayQRCodeImage != nil && _wechatQRCodeImage == nil) {
        [self showAlipayQRCodeUI];
        
        _withdrawBtn.hidden = NO;
        _withdrawTipBtn.hidden = NO;
        
        CGFloat upBtnHeight = (self.frameWidth - 130) / 2;
        CGFloat updateImageHeight = _alipayQRCodeImage.size.height * ((self.frameWidth - 130) / 2) / _alipayQRCodeImage.size.width;
        if (updateImageHeight > upBtnHeight) {
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
        // 支付方式
        self.currentSelectQRCodeType = 1;
        self.currentSelectQRCodeImage = _alipayQRCodeImage;
        [self updateSelectUI];
    }else if (_alipayQRCodeImage == nil && _wechatQRCodeImage != nil) {
        [self showWechatQRCodeUI];
        
        _withdrawBtn.hidden = NO;
        _withdrawTipBtn.hidden = NO;
        
        CGFloat upBtnHeight = (self.frameWidth - 130) / 2;
        CGFloat updateImageHeight = _wechatQRCodeImage.size.height * ((self.frameWidth - 130) / 2) / _wechatQRCodeImage.size.width;
        if (updateImageHeight > upBtnHeight) {
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
        // 支付方式
        self.currentSelectQRCodeType = 2;
        self.currentSelectQRCodeImage = _wechatQRCodeImage;
        [self updateSelectUI];
    }else if (_alipayQRCodeImage != nil && _wechatQRCodeImage != nil) {
        [self showAlipayQRCodeUI];
        [self showWechatQRCodeUI];
        
        _withdrawBtn.hidden = NO;
        _withdrawTipBtn.hidden = NO;
        
        CGFloat updateAlipayImageHeight = _alipayQRCodeImage.size.height * ((self.frameWidth - 130) / 2) / _alipayQRCodeImage.size.width;
        CGFloat updateWechatImageHeight = _wechatQRCodeImage.size.height * ((self.frameWidth - 130) / 2) / _wechatQRCodeImage.size.width;
        if (updateAlipayImageHeight > updateWechatImageHeight) {
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
        // 支付方式
        if (self.currentSelectQRCodeType == 0 ||
            self.currentSelectQRCodeType == 2) {
            self.currentSelectQRCodeType = 1;
            self.currentSelectQRCodeImage = _alipayQRCodeImage;
            [self updateSelectUI];
        }
    }
}

/// 显示支付宝二维码
- (void)showAlipayQRCodeUI {
    _alipayUpBtn.hidden = YES;
    _alipayQRCodeBgView.hidden = NO;
    _alipayQRCodeImgView.hidden = NO;
    _alipayDeleteBtn.hidden = NO;
    
    _alipayQRCodeImgView.image = _alipayQRCodeImage;
    
    CGFloat updateImageHeight = _alipayQRCodeImage.size.height * ((self.frameWidth - 130) / 2) / _alipayQRCodeImage.size.width;
    [_alipayQRCodeImgViewHeightConstraint uninstall];
    [_alipayQRCodeImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.alipayQRCodeImgViewHeightConstraint =  make.height.mas_equalTo(@(updateImageHeight));
    }];
    [_alipayBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alipayQRCodeImgView.mas_bottom).offset(23);
        make.centerX.equalTo(self.alipayQRCodeImgView);
    }];
}
/// 显示微信二维码
- (void)showWechatQRCodeUI {
    _wechatUpBtn.hidden = YES;
    _wechatQRCodBgView.hidden = NO;
    _wechatQRCodeImgView.hidden = NO;
    _wechatDeleteBtn.hidden = NO;
    
    _wechatQRCodeImgView.image = _wechatQRCodeImage;
    
    CGFloat updateImageHeight = _wechatQRCodeImage.size.height * ((self.frameWidth - 130) / 2) / _wechatQRCodeImage.size.width;
    [_wechatQRCodeImgViewHeightConstraint uninstall];
    [_wechatQRCodeImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.wechatQRCodeImgViewHeightConstraint =  make.height.mas_equalTo(@(updateImageHeight));
    }];
    [_wechatBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatQRCodeImgView.mas_bottom).offset(23);
        make.centerX.equalTo(self.wechatQRCodeImgView);
    }];
}
/// 选择选中状态
- (void)updateSelectUI {
    [_bgView layoutIfNeeded];
    if (self.currentSelectQRCodeType == 1) {
        _alipaySelectImgView.hidden = NO;
        _alipayQRCodeImgView.layer.borderColor = JL_color_orange_FFB432.CGColor;
        _alipayQRCodeImgView.layer.borderWidth = 1;
        [_alipayQRCodeBgView addShadow:JL_color_orange_FFB432 cornerRadius:5.0f offset:CGSizeMake(0, 0)];

        _wechatSelectImgView.hidden = YES;
        _wechatQRCodeImgView.layer.borderColor = JL_color_clear.CGColor;
        _wechatQRCodeImgView.layer.borderWidth = 1;
        [_wechatQRCodBgView addShadow:JL_color_clear cornerRadius:5.0f offset:CGSizeMake(0, 0)];
    }else {
        _wechatSelectImgView.hidden = NO;
        _wechatQRCodeImgView.layer.borderColor = JL_color_orange_FFB432.CGColor;
        _wechatQRCodeImgView.layer.borderWidth = 1;
        [_wechatQRCodBgView addShadow:JL_color_orange_FFB432 cornerRadius:5.0f offset:CGSizeMake(0, 0)];
        
        _alipaySelectImgView.hidden = YES;
        _alipayQRCodeImgView.layer.borderColor = JL_color_clear.CGColor;
        _alipayQRCodeImgView.layer.borderWidth = 1;
        [_alipayQRCodeBgView addShadow:JL_color_clear cornerRadius:5.0f offset:CGSizeMake(0, 0)];
    }
}

#pragma mark - event response
- (void)alipayUpBtnClick: (UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(addImage:)]) {
        [_delegate addImage:1];
    }
}

- (void)wechatUpBtnClick: (UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(addImage:)]) {
        [_delegate addImage:2];
    }
}

- (void)alipayQRCodeImgViewDidTap: (UITapGestureRecognizer *)ges {
    self.currentSelectQRCodeType = 1;
    self.currentSelectQRCodeImage = _alipayQRCodeImage;
    
    [self updateSelectUI];
}

- (void)wechatQRCodeImgViewDidTap: (UITapGestureRecognizer *)ges {
    self.currentSelectQRCodeType = 2;
    self.currentSelectQRCodeImage = _wechatQRCodeImage;
    
    [self updateSelectUI];
}

- (void)alipayDeleteBtnClick: (UIButton *)sender {
    self.alipayQRCodeImage = nil;
    _addAlipayQRCodeImage = nil;

    [self updateUI];
}

- (void)wechatDeleteBtnClick: (UIButton *)sender {
    self.wechatQRCodeImage = nil;
    _addWechatQRCodeImage = nil;

    [self updateUI];
}

- (void)withdrawBtnClick: (UIButton *)sender {
    if (!_currentSelectQRCodeImage) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请选择提现的收款码!" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    
    self.isNeedUploadQRImage = NO;
    
    if (_currentSelectQRCodeType == 1 && _addAlipayQRCodeImage) {
        self.isNeedUploadQRImage = YES;
    }
    
    if (_currentSelectQRCodeType == 2 && _addWechatQRCodeImage) {
        self.isNeedUploadQRImage = YES;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(withdraw:payType:isNeedUploadQRImage:)]) {
        [_delegate withdraw:_currentSelectQRCodeImage payType:_currentSelectQRCodeType isNeedUploadQRImage:_isNeedUploadQRImage];
    }
}

#pragma mark - setters and getters
- (void)setAlipayImgUrl:(NSString *)alipayImgUrl {
    _alipayImgUrl = alipayImgUrl;
    
    WS(weakSelf)
    [_alipayQRCodeImgView sd_setImageWithURL:[NSURL URLWithString:_alipayImgUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            weakSelf.alipayQRCodeImage = image;
            [weakSelf updateUI];
        }
    }];
}

- (void)setWechatImgUrl:(NSString *)wechatImgUrl {
    _wechatImgUrl = wechatImgUrl;
    
    WS(weakSelf)
    [_wechatQRCodeImgView sd_setImageWithURL:[NSURL URLWithString:_wechatImgUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            weakSelf.wechatQRCodeImage = image;
            [weakSelf updateUI];
        }
    }];
}

- (void)setAddAlipayQRCodeImage:(UIImage *)addAlipayQRCodeImage {
    _addAlipayQRCodeImage = addAlipayQRCodeImage;
    
    self.alipayQRCodeImage = _addAlipayQRCodeImage;
    
    [self updateUI];
}

- (void)setAddWechatQRCodeImage:(UIImage *)addWechatQRCodeImage {
    _addWechatQRCodeImage = addWechatQRCodeImage;
    
    self.wechatQRCodeImage = _addWechatQRCodeImage;
    
    [self updateUI];
}

@end
