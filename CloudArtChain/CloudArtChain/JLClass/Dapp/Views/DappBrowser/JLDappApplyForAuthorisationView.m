//
//  JLDappApplyForAuthorisationView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappApplyForAuthorisationView.h"

static JLDappApplyForAuthorisationView *authorisationView;

@interface JLDappApplyForAuthorisationView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *chainImgView;
@property (nonatomic, strong) UILabel *chainNameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *noTipBtn;
@property (nonatomic, strong) UIButton *refuseBtn;
@property (nonatomic, strong) UIButton *agreeBtn;

@property (nonatomic, copy) NSString *dappName;
@property (nonatomic, copy) NSString *dappImgUrl;
@property (nonatomic, copy) NSString *dappWebUrl;
@property (nonatomic, copy) JLDappApplyForAuthorisationViewRefuseBlock refuseBlock;
@property (nonatomic, copy) JLDappApplyForAuthorisationViewAgreeBlock agreeBlock;

@property (nonatomic, copy) NSString *isNoTip;

@end

@implementation JLDappApplyForAuthorisationView

- (instancetype)initWithFrame:(CGRect)frame
                     dappName: (NSString *)dappName
                   dappImgUrl: (NSString *)dappImgUrl
                   dappWebUrl: (NSString *)dappWebUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        _dappName = dappName;
        _dappImgUrl = dappImgUrl;
        _dappWebUrl = dappWebUrl;
        _isNoTip = @"NO";
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _maskView = [[UIView alloc] initWithFrame:self.bounds];
    _maskView.alpha = 0;
    _maskView.backgroundColor = JL_color_black;
    [self addSubview:_maskView];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 350 + KTouch_Responder_Height)];
    _bgView.layer.cornerRadius = 5;
    _bgView.backgroundColor = JL_color_white_ffffff;
    [self addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"申请授权";
    _titleLabel.textColor = JL_color_gray_101010;
    _titleLabel.font = kFontPingFangSCRegular(17);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(13);
        make.centerX.equalTo(self.bgView);
    }];
    
    _chainImgView = [[UIImageView alloc] init];
    _chainImgView.backgroundColor = JL_color_blue_6077DF;
    _chainImgView.layer.cornerRadius = 17.5;
    _chainImgView.layer.borderWidth = 1;
    _chainImgView.layer.borderColor = JL_color_gray_DDDDDD.CGColor;
    _chainImgView.clipsToBounds = YES;
    [_bgView addSubview:_chainImgView];
    [_chainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(32);
        make.centerX.equalTo(self.bgView);
        make.width.height.mas_equalTo(@35);
    }];
    
    _chainNameLabel = [[UILabel alloc] init];
    _chainNameLabel.text = @"imKey";
    _chainNameLabel.textColor = JL_color_gray_101010;
    _chainNameLabel.font = kFontPingFangSCSCSemibold(15);
    _chainNameLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_chainNameLabel];
    [_chainNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.chainImgView);
        make.top.equalTo(self.chainImgView.mas_bottom).offset(13);
    }];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.text = @"imKey正在申请访问你的钱包地址，你确认将钱包地址公开给此网站吗？";
    _descLabel.textColor = JL_color_gray_101010;
    _descLabel.font = kFontPingFangSCRegular(14);
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.numberOfLines = 0;
    _descLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_bgView addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chainNameLabel.mas_bottom).offset(31);
        make.left.equalTo(self.bgView).offset(48);
        make.right.equalTo(self.bgView).offset(-48);
    }];
    
    _refuseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [_refuseBtn setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
    _refuseBtn.titleLabel.font = kFontPingFangSCRegular(15);
    _refuseBtn.layer.cornerRadius = 5;
    _refuseBtn.layer.borderWidth = 1;
    _refuseBtn.layer.borderColor = JL_color_gray_101010.CGColor;
    _refuseBtn.layer.masksToBounds = YES;
    [_refuseBtn addTarget:self action:@selector(refuseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_refuseBtn];
    [_refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(28);
        make.bottom.equalTo(self.bgView).offset(-(22 + KTouch_Responder_Height));
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - 28 * 2 - 10) / 2, 40));
    }];
    
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _agreeBtn.backgroundColor = JL_color_gray_101010;
    [_agreeBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_agreeBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    _agreeBtn.titleLabel.font = kFontPingFangSCRegular(15);
    _agreeBtn.layer.cornerRadius = 5;
    _agreeBtn.layer.masksToBounds = YES;
    [_agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_agreeBtn];
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-28);
        make.bottom.equalTo(self.bgView).offset(-(22 + KTouch_Responder_Height));
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - 28 * 2 - 10) / 2, 40));
    }];
    
    _noTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_noTipBtn setTitle:@"今日不再提示" forState:UIControlStateNormal];
    [_noTipBtn setTitleColor:JL_color_gray_999999 forState:UIControlStateNormal];
    _noTipBtn.titleLabel.font = kFontPingFangSCRegular(13);
    [_noTipBtn setImage:[UIImage imageNamed:@"icon_dapp_apply_for_authorisation_normal"] forState:UIControlStateNormal];
    [_noTipBtn setImage:[UIImage imageNamed:@"icon_dapp_apply_for_authorisation_selected"] forState:UIControlStateSelected];
    [_noTipBtn setImagePosition:LXMImagePositionLeft spacing:6];
    [_noTipBtn addTarget:self action:@selector(noTipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_noTipBtn];
    [_noTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.bottom.equalTo(self.refuseBtn.mas_top).offset(-18);
        make.size.mas_equalTo(CGSizeMake(140, 40));
    }];
        
    [UIView animateWithDuration:0.3 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.maskView.alpha = 0.5;
        self.bgView.frame = CGRectMake(0, kScreenHeight - (350 + KTouch_Responder_Height), kScreenWidth, 350 + KTouch_Responder_Height);
    } completion:nil];
}

#pragma mark - event response
- (void)noTipBtnClick: (UIButton *)sender {
    sender.selected = !sender.selected;
    
    _isNoTip = @"NO";
    if (sender.isSelected) {
        _isNoTip = @"YES";
    }
}

- (void)refuseBtnClick: (UIButton *)sender {
    if (self.refuseBlock) {
        self.refuseBlock();
    }
    
    [self dismiss];
}

- (void)agreeBtnClick: (UIButton *)sender {
    if (self.agreeBlock) {
        self.agreeBlock();
    }
    
    [self saveNoTipStatus];
    
    [self dismiss];
}

#pragma mark - public methods
+ (void)showWithDappName: (NSString *)dappName
              dappImgUrl: (NSString *)dappImgUrl
              dappWebUrl: (NSString *)dappWebUrl
               superView: (UIView * _Nullable)superView
                  refuse: (JLDappApplyForAuthorisationViewRefuseBlock)refuse
                   agree: (JLDappApplyForAuthorisationViewAgreeBlock _Nullable)agree {
    CGRect frame = [UIScreen mainScreen].bounds;
    if (superView) {
        frame = superView.bounds;
    }
    authorisationView = [[JLDappApplyForAuthorisationView alloc] initWithFrame:frame dappName:dappName dappImgUrl:dappImgUrl dappWebUrl:dappWebUrl];
    authorisationView.agreeBlock = agree;
    authorisationView.refuseBlock = refuse;
    if (superView) {
        [superView addSubview:authorisationView];
        [superView bringSubviewToFront:authorisationView];
    }else {
        [[UIApplication sharedApplication].windows.lastObject addSubview:authorisationView];
        [[UIApplication sharedApplication].windows.lastObject bringSubviewToFront:authorisationView];
    }
}

#pragma mark - private methods
- (void)dismiss {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.maskView.alpha = 0;
        self.bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 350 + KTouch_Responder_Height);
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.bgView removeFromSuperview];
        [authorisationView removeFromSuperview];
        authorisationView = nil;
    }];
}

- (void)saveNoTipStatus {
    NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:USERDEFAULTS_JL_DAPP_APPLY_FOR_AUTHORISATION];
    NSMutableArray *resultArr = [NSMutableArray arrayWithArray:arr];
    NSDictionary *resultDict = @{ _dappWebUrl : _isNoTip };
    
    BOOL isFind = NO;
    for (int i = 0; i < resultArr.count; i++) {
        NSDictionary *dict = resultArr[i];
        NSString *name = dict[_dappWebUrl];
        if (![NSString stringIsEmpty:name]) {
            isFind = YES;
            [resultArr replaceObjectAtIndex:i withObject:resultDict];
            break;
        }
    }
    
    if (!isFind) {
        [resultArr addObject:resultDict];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[resultArr copy] forKey:USERDEFAULTS_JL_DAPP_APPLY_FOR_AUTHORISATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
