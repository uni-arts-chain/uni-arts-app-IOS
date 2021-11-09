//
//  JLArtDetailShowCertificateView.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/11.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLArtDetailShowCertificateView.h"

static JLArtDetailShowCertificateView *showCertificateView;

@interface JLArtDetailShowCertificateView ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *certificateBgImgView;

@property (nonatomic, strong) UIImageView *certificateTopLeftIconImgView;

@property (nonatomic, strong) UIImageView *certificateTopRightIconImgView;

@property (nonatomic, strong) UIImageView *certificateTitleIconImgView;

@property (nonatomic, strong) UIImageView *certificateBottomIconImgView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *themeLabel;

@property (nonatomic, strong) UILabel *releaseNumLabel;

@property (nonatomic, strong) UILabel *addressNameLabel;

@property (nonatomic, strong) UILabel *addressDescLabel;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;

@end

@implementation JLArtDetailShowCertificateView

- (instancetype)initWithFrame:(CGRect)frame artDetailData: (Model_art_Detail_Data *)artDetailData
{
    self = [super initWithFrame:frame];
    if (self) {
        _artDetailData = artDetailData;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [JL_color_black colorWithAlphaComponent:0.5];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _bgView = [[UIView alloc] init];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(@294);
    }];
    
    _certificateBgImgView = [[UIImageView alloc] init];
    _certificateBgImgView.image = [[UIImage imageNamed:@"certificate_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(100, 100, 100, 100) resizingMode:UIImageResizingModeStretch];
    [_bgView addSubview:_certificateBgImgView];
    [_certificateBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
    }];
    
    _certificateTopLeftIconImgView = [[UIImageView alloc] init];
    _certificateTopLeftIconImgView.image = [UIImage imageNamed:@"certificate_bg_top_left"];
    [_certificateBgImgView addSubview:_certificateTopLeftIconImgView];
    [_certificateTopLeftIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certificateBgImgView).offset(47);
        make.left.equalTo(self.certificateBgImgView).offset(53);
        make.width.height.mas_equalTo(@20);
    }];
    
    _certificateTopRightIconImgView = [[UIImageView alloc] init];
    _certificateTopRightIconImgView.image = [UIImage imageNamed:@"certificate_bg_top_right"];
    [_certificateBgImgView addSubview:_certificateTopRightIconImgView];
    [_certificateTopRightIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certificateBgImgView).offset(47);
        make.right.equalTo(self.certificateBgImgView).offset(-53);
        make.width.height.mas_equalTo(@20);
    }];
    
    _certificateTitleIconImgView = [[UIImageView alloc] init];
    _certificateTitleIconImgView.image = [UIImage imageNamed:@"certificate_bg_title"];
    [_certificateBgImgView addSubview:_certificateTitleIconImgView];
    [_certificateTitleIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certificateBgImgView).offset(69);
        make.centerX.equalTo(self.certificateBgImgView);
        make.size.mas_equalTo(CGSizeMake(115, 33));
    }];
    
    _certificateBottomIconImgView = [[UIImageView alloc] init];
    _certificateBottomIconImgView.image = [UIImage imageNamed:@"certificate_bg_bottom"];
    [_certificateBgImgView addSubview:_certificateBottomIconImgView];
    [_certificateBottomIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.certificateBgImgView).offset(-73);
        make.centerX.equalTo(self.certificateBgImgView);
        make.size.mas_equalTo(CGSizeMake(184, 4));
    }];
    
    _contentView = [[UIView alloc] init];
    [_certificateBgImgView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certificateBgImgView).offset(127);
        make.left.equalTo(self.certificateBgImgView).offset(64);
        make.right.equalTo(self.certificateBgImgView).offset(-64);
        make.bottom.equalTo(self.certificateBgImgView).offset(-100);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = [NSString stringWithFormat:@"名称：%@", _artDetailData.name];
    _titleLabel.textColor = JL_color_black_010034;
    _titleLabel.font = kFontPingFangSCRegular(11);
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    
    _themeLabel = [[UILabel alloc] init];
    _themeLabel.text = @"主题：";
    _themeLabel.textColor = JL_color_black_010034;
    _themeLabel.font = kFontPingFangSCRegular(11);
    _themeLabel.numberOfLines = 0;
    _themeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _themeLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_themeLabel];
    [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.titleLabel);
    }];
    
    _releaseNumLabel = [[UILabel alloc] init];
    _releaseNumLabel.text = [NSString stringWithFormat:@"发行份数：%ld份", _artDetailData.total_amount];
    _releaseNumLabel.textColor = JL_color_black_010034;
    _releaseNumLabel.font = kFontPingFangSCRegular(11);
    _releaseNumLabel.numberOfLines = 0;
    _releaseNumLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _releaseNumLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_releaseNumLabel];
    [_releaseNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.themeLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.themeLabel);
    }];
    
    _addressDescLabel = [[UILabel alloc] init];
    _addressDescLabel.text = _artDetailData.item_hash;
    _addressDescLabel.textColor = JL_color_black_010034;
    _addressDescLabel.font = kFontPingFangSCRegular(11);
    _addressDescLabel.numberOfLines = 0;
    _addressDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _addressDescLabel.textAlignment = NSTextAlignmentLeft;
    [_contentView addSubview:_addressDescLabel];
    [_addressDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.releaseNumLabel.mas_bottom).offset(20);
        make.right.equalTo(self.releaseNumLabel);
        make.left.equalTo(self.certificateBgImgView).offset(116);
        make.bottom.equalTo(self.contentView);
    }];
    
    _addressNameLabel = [[UILabel alloc] init];
    _addressNameLabel.text = @"藏品地址：";
    _addressNameLabel.textColor = JL_color_black_010034;
    _addressNameLabel.font = kFontPingFangSCRegular(11);
    _addressNameLabel.numberOfLines = 0;
    _addressNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _addressNameLabel.textAlignment = NSTextAlignmentRight;
    [_contentView addSubview:_addressNameLabel];
    [_addressNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressDescLabel);
        make.right.equalTo(self.addressDescLabel.mas_left);
    }];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"certificate_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certificateBgImgView.mas_bottom).offset(6);
        make.centerX.equalTo(self.bgView);
        make.width.height.mas_equalTo(@45);
        make.bottom.equalTo(self.bgView);
    }];
    
    for (Model_arts_theme_Data *theme_data in [AppSingleton sharedAppSingleton].artThemeArray) {
        if ([theme_data.ID isEqualToString:[NSString stringWithFormat:@"%ld", _artDetailData.category_id]]) {
            _themeLabel.text = [NSString stringWithFormat:@"主题：%@", theme_data.title];
            break;
        }
    }

    [_bgView layoutIfNeeded];
    
    // 进入动画
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width / 2, -_bgView.frameBottom)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
    [_bgView.layer addAnimation:[JLViewAniamtionTool enterAnimationWithEasingFunction:QGYBackEaseOut fromValue:fromValue toValue:toValue] forKey:nil];
}

#pragma mark - public methods
+ (void)showWithArtDetailData:(Model_art_Detail_Data *)artDetailData {
    showCertificateView = [[JLArtDetailShowCertificateView alloc] initWithFrame:[UIScreen mainScreen].bounds artDetailData:artDetailData];
    [[UIApplication sharedApplication].keyWindow addSubview:showCertificateView];
}

#pragma mark - event response
- (void)closeBtnClick: (UIButton *)sender {
    [self dismiss];
}

#pragma mark - private methods
- (void)dismiss {
    [UIView animateWithDuration:0.35 animations:^{
        self.maskView.alpha = 0;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.maskView removeFromSuperview];
        [showCertificateView removeFromSuperview];
        showCertificateView = nil;
    }];
}

- (void)dealloc
{
    NSLog(@"释放了: %@", self.class);
}

@end
