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

@property (nonatomic, strong) UILabel *nameTitleLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *themeTitleLabel;

@property (nonatomic, strong) UILabel *themeLabel;

@property (nonatomic, strong) UILabel *releaseTitleLabel;

@property (nonatomic, strong) UILabel *releaseNumLabel;

@property (nonatomic, strong) UILabel *addressNameLabel;

@property (nonatomic, strong) UILabel *addressDescLabel;

@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;

@end

@implementation JLArtDetailShowCertificateView

- (instancetype)initWithFrame:(CGRect)frame artDetailData: (Model_art_Detail_Data *)artDetailData
{
    self = [super initWithFrame:frame];
    if (self) {
        _artDetailData = artDetailData;
        [self addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [JL_color_black_333333 colorWithAlphaComponent:0.85];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _bgView = [[UIView alloc] init];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(@297);
    }];
    
    UIImage *image = [UIImage imageNamed:@"certificate_bg"];
    _certificateBgImgView = [[UIImageView alloc] init];
    _certificateBgImgView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height / 2, image.size.width / 2, image.size.height / 2, image.size.width / 2) resizingMode:UIImageResizingModeStretch];
    [_bgView addSubview:_certificateBgImgView];
    [_certificateBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.bgView);
    }];
    
    _nameTitleLabel = [[UILabel alloc] init];
    _nameTitleLabel.text = @"名称：";
    _nameTitleLabel.textColor = JL_color_mainColor;
    _nameTitleLabel.font = kFontPingFangSCRegular(13);
    [_certificateBgImgView addSubview:_nameTitleLabel];
    [_nameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.certificateBgImgView).offset(59);
        make.top.equalTo(self.certificateBgImgView).offset(174);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = _artDetailData.name;
    _nameLabel.textColor = JL_color_black;
    _nameLabel.font = kFontPingFangSCSCSemibold(16);
    _nameLabel.numberOfLines = 0;
    _nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_certificateBgImgView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTitleLabel).offset(-2);
        make.left.equalTo(self.nameTitleLabel.mas_right).offset(3);
        make.right.equalTo(self.certificateBgImgView).offset(-25);
    }];
    
    _themeTitleLabel = [[UILabel alloc] init];
    _themeTitleLabel.text = @"主题：";
    _themeTitleLabel.textColor = JL_color_mainColor;
    _themeTitleLabel.font = kFontPingFangSCRegular(13);
    [_certificateBgImgView addSubview:_themeTitleLabel];
    [_themeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameTitleLabel);
    }];
    
    _themeLabel = [[UILabel alloc] init];
    _themeLabel.textColor = JL_color_black_40414D;
    _themeLabel.font = kFontPingFangSCRegular(13);
    _themeLabel.numberOfLines = 0;
    _themeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_certificateBgImgView addSubview:_themeLabel];
    [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.themeTitleLabel);
        make.left.equalTo(self.themeTitleLabel.mas_right).offset(3);
        make.right.equalTo(self.nameLabel);
    }];
    
    _releaseTitleLabel = [[UILabel alloc] init];
    _releaseTitleLabel.text = @"发行总量：";
    _releaseTitleLabel.textColor = JL_color_mainColor;
    _releaseTitleLabel.font = kFontPingFangSCRegular(13);
    [_certificateBgImgView addSubview: _releaseTitleLabel];
    [_releaseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.themeLabel.mas_bottom).offset(16);
        make.left.equalTo(self.themeTitleLabel);
    }];
    
    _releaseNumLabel = [[UILabel alloc] init];
    _releaseNumLabel.text = [NSString stringWithFormat:@"%ld", _artDetailData.total_amount];
    _releaseNumLabel.textColor = JL_color_black_40414D;
    _releaseNumLabel.font = kFontPingFangSCRegular(13);
    _releaseNumLabel.numberOfLines = 0;
    _releaseNumLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_certificateBgImgView addSubview:_releaseNumLabel];
    [_releaseNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.releaseTitleLabel);
        make.left.equalTo(self.releaseTitleLabel.mas_right).offset(3);
        make.right.equalTo(self.themeLabel);
    }];
    
    _addressNameLabel = [[UILabel alloc] init];
    _addressNameLabel.text = @"NFT地址：";
    _addressNameLabel.textColor = JL_color_mainColor;
    _addressNameLabel.font = kFontPingFangSCRegular(13);
    [_certificateBgImgView addSubview:_addressNameLabel];
    [_addressNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.releaseNumLabel.mas_bottom).offset(6);
        make.left.equalTo(self.releaseTitleLabel);
    }];
    
    _addressDescLabel = [[UILabel alloc] init];
    _addressDescLabel.text = _artDetailData.item_hash;
    _addressDescLabel.textColor = JL_color_black_40414D;
    _addressDescLabel.font = kFontPingFangSCRegular(13);
    _addressDescLabel.numberOfLines = 0;
    _addressDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_certificateBgImgView addSubview:_addressDescLabel];
    [_addressDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressNameLabel.mas_bottom).offset(6);
        make.right.equalTo(self.certificateBgImgView).offset(-55);
        make.left.equalTo(self.addressNameLabel);
        make.bottom.equalTo(self.certificateBgImgView).offset(-132);
    }];
    

    for (Model_arts_theme_Data *theme_data in [AppSingleton sharedAppSingleton].artThemeArray) {
        if ([theme_data.ID isEqualToString:[NSString stringWithFormat:@"%ld", _artDetailData.category_id]]) {
            _themeLabel.text = theme_data.title;
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
