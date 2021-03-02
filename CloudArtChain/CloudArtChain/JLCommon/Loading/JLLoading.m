//
//  JLLoading.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLLoading.h"
#import "MBProgressHUD.h"
#import "JLHudActivityView.h"
#import "JLCustomTipControl.h"
#import "JLDownloadLoading.h"

@interface JLLoading()
//window
@property(nonatomic,strong) UIWindow *window;
//loading视图
@property(nonatomic,strong) JLHudActivityView *loadingView;
//tip视图
@property(nonatomic,strong) MBProgressHUD *HUD;
//自定义tip视图
@property(nonatomic,strong) JLCustomTipControl *customTipControl;
//视频图片下载loading
@property (nonatomic,strong) JLDownloadLoading *downloadLoading;
@end

@implementation JLLoading

+ (JLLoading *)sharedLoading {
    static dispatch_once_t onceToken;
    static JLLoading *loading = nil;
    dispatch_once(&onceToken, ^{
        loading = [[JLLoading alloc]init];
    });
    return loading;
}

//初始化
- (instancetype)init {
    if (self = [super init]) {
        self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return self;
}

#pragma mark - Loading
- (void)showLoadingWithMessage:(NSString *)message onView:(UIView *)view {
    if (_loadingView) {
        [self hideLoading];
    }
    _loadingView = [JLHudActivityView createHudActivityViewWithMessage:message OnView:view == nil ? self.window : view];
}

- (void)showDownloadLoadingOnView:(UIView *)view {
    if (_loadingView) {
        [self hideLoading];
    }
    _downloadLoading = [JLDownloadLoading showLoadingWithView:view == nil ? self.window : view];
}

- (void)showRefreshLoadingOnView:(UIView *)view {
//    if (_downloadLoading) {
//        [self hideLoading];
//    }
//    _downloadLoading = [JLDownloadLoading showLoadingWithView:view == nil ? self.window : view];
    if (_loadingView) {
        [self hideLoading];
    }
    _loadingView = [JLHudActivityView showHudActivityViewAddedTo:view == nil ? self.window : view animated:YES];
}

- (void)hideLoading {
    [_loadingView hide:YES];
    _loadingView = nil;
    
    if (_HUD.completionBlock) {
        _HUD.completionBlock = nil;
    }
    [_HUD hideAnimated:NO];
    [_HUD removeFromSuperview];
    _HUD = nil;
    
    [_customTipControl removeFromSuperview];
    _customTipControl = nil;
    
    [_downloadLoading hideLoadingWithRemove];
    _downloadLoading = nil;
}

#pragma mark - Tip

- (void)showMBSuccessTipMessage:(NSString *)msg hideTime:(NSTimeInterval)delaySecond {
    [self showMBSuccessTipMessage:msg hideTime:delaySecond hidedBlock:nil];
}

-(void)showMBSuccessTipMessage:(NSString *)msg hideTime:(NSTimeInterval)delaySecond hidedBlock:(void (^)(void))hidedblock {
    if ([NSString stringIsEmpty:msg]) {
        return;
    }
    if (_HUD) {
        [self hideLoading];
    }
    _HUD = [[MBProgressHUD alloc]initWithView:self.window];
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.detailsLabel.text = msg;
    _HUD.detailsLabel.font = kFontPingFangSCMedium(12);
    _HUD.mode = MBProgressHUDModeText;
    _HUD.contentColor = [UIColor whiteColor];
    _HUD.bezelView.color = [UIColor colorWithRed:38.0 / 256 green:38.0 / 256 blue:38.0 / 256 alpha:1.0];
    _HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _HUD.margin = 10;
    _HUD.minSize = CGSizeMake(150, 30);
    _HUD.completionBlock = hidedblock;
    
    _HUD.userInteractionEnabled = NO;
    [self.window addSubview:_HUD];
    [_HUD showAnimated:YES];
    [_HUD hideAnimated:YES afterDelay:delaySecond];
}

- (void)showMBFailedTipMessage:(NSString *)msg hideTime:(NSTimeInterval)delaySecond {
    [self showMBFailedTipMessage:msg hideTime:delaySecond hidedBlock:nil];
}

- (void)showMBFailedTipMessage:(NSString *)msg hideTime:(NSTimeInterval)delaySecond hidedBlock:(void (^)(void))hidedblock {
    if ([NSString stringIsEmpty:msg]) {
        return;
    }
    if (_HUD) {
        [self hideLoading];
    }
    _HUD = [[MBProgressHUD alloc]initWithView:self.window];
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.detailsLabel.text = msg;
    _HUD.detailsLabel.font = kFontPingFangSCMedium(12);
    _HUD.mode = MBProgressHUDModeText;
    _HUD.contentColor = [UIColor whiteColor];
    _HUD.bezelView.color = [UIColor colorWithRed:38.0 / 256 green:38.0 / 256 blue:38.0 / 256 alpha:1.0];
    _HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _HUD.margin = 10;
    _HUD.minSize = CGSizeMake(150, 30);
    _HUD.offset = CGPointMake(0.f, -[UIScreen mainScreen].bounds.size.height * 0.5 + _HUD.frame.size.height - 84);
    _HUD.completionBlock = hidedblock;
    
    _HUD.userInteractionEnabled = NO;
    [self.window addSubview:_HUD];
    [_HUD showAnimated:YES];
    [_HUD hideAnimated:YES afterDelay:delaySecond];
}

#pragma mark - Custom Tip

-(void)showJLSuccessTipMessage:(NSString *)msg onView:(UIView *)view hideTime:(NSTimeInterval)hideTime {
    [self showJLTipWithImageName:@"icon_tip_success" tipMessage:msg onView:view hideTime:hideTime position:TipControlPositionCenter hidedBlock:nil];
}

-(void)showJLSuccessTipMessage:(NSString *)msg onView:(UIView *)view hideTime:(NSTimeInterval)hideTime hidedBlock:(void (^)(void))hidedBlock {
    [self showJLTipWithImageName:@"icon_tip_success" tipMessage:msg onView:view hideTime:hideTime position:TipControlPositionCenter hidedBlock:hidedBlock];
}

- (void)showJLFailedTipMessage:(NSString *)msg onView:(UIView *)view hideTime:(NSTimeInterval)hideTime {
    [self showJLTipWithImageName:@"icon_tip_error" tipMessage:msg onView:view hideTime:hideTime position:TipControlPositionBottom hidedBlock:nil];
}

- (void)showJLFailedTipMessage:(NSString *)msg onView:(UIView *)view hideTime:(NSTimeInterval)hideTime hidedBlock:(void (^)(void))hidedBlock {
    [self showJLTipWithImageName:@"icon_tip_error" tipMessage:msg onView:view hideTime:hideTime position:TipControlPositionBottom hidedBlock:hidedBlock];
}

- (void)showJLTipWithImageName:(NSString *)imageName tipMessage:(NSString *)msg onView:(UIView *)view hideTime:(NSTimeInterval)hideTime position:(TipControlPosition)position hidedBlock:(void(^)(void))hidedBlock {
    if ([NSString stringIsEmpty:msg]) {
        return;
    }
    if (_customTipControl) {
        [self hideLoading];
    }
    CGRect tipControlFrame = view != nil ? view.bounds : self.window.bounds;
    UIView *showView = view != nil ? view : self.window;
    _customTipControl = [[JLCustomTipControl alloc]initWithFrame:tipControlFrame tipIcon:imageName tipMessage:msg hideTime:hideTime position:position hidedBlock:hidedBlock];
    [showView addSubview:_customTipControl];
}


#pragma mark icon + 文字提示

- (void)showIconSuccessToastWithMessage:(NSString *)msg duration:(NSTimeInterval)duration {
    [self showToastWithImageName:@"ic_sucess" message:msg duration:duration hidedBlock:nil];
}

- (void)showIconSuccessToastWithMessage:(NSString *)msg duration:(NSTimeInterval)duration hidedBlock:(void(^)(void))hidedBlock {
    [self showToastWithImageName:@"ic_sucess" message:msg duration:duration hidedBlock:hidedBlock];
}



- (void)showToastWithImageName:(NSString *)imageName message:(NSString *)msg duration:(NSTimeInterval)duration hidedBlock:(void(^)(void))hidedBlock {
    if ([NSString stringIsEmpty:msg]) {
        return;
    }
    if (_HUD) {
        [self hideLoading];
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.window];
    _HUD = HUD;
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.detailsLabel.text = msg;
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.detailsLabel.font = kFontPingFangSCRegular(16);
    _HUD.contentColor = [UIColor whiteColor];
    _HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _HUD.bezelView.color = [UIColor colorWithHexString:@"333333" alpha:0.9];
    _HUD.animationType = MBProgressHUDAnimationFade;
    _HUD.completionBlock = hidedBlock;
    _HUD.userInteractionEnabled = NO;
    _HUD.detailsLabel.numberOfLines = 0;
    _HUD.margin = 16;
    [self.window addSubview:_HUD];
    
    CGSize oriSize = [JLTool getAdaptionSizeWithText:msg labelHeight:22 font:kFontPingFangSCRegular(16)];
    CGFloat messageWidth = oriSize.width;
    if (messageWidth > kScreenWidth / 2 - 32) {
        messageWidth = kScreenWidth / 2 - 32;
    }
    if (messageWidth < 128 - 32) {
        messageWidth = 128 - 32;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    _HUD.customView = imageView;
    
    [_HUD.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(28 * messageWidth / (128 - 32)));
        make.centerX.equalTo(HUD);
        make.size.mas_equalTo(36.0f);
    }];
    [_HUD.detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(12 * messageWidth / (128 - 32));
        make.width.equalTo(@(messageWidth));
    }];
    
    [_HUD showAnimated:YES];
    [_HUD hideAnimated:YES afterDelay:duration];
}


- (void)showProgressWithView:(UIView *)view message:(NSString *)msg progress:(CGFloat)progress{
    if (_HUD && _HUD.mode != MBProgressHUDModeAnnularDeterminate) {
        [self hideLoading];
    }
    
    if (!_HUD) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.window];
        _HUD = HUD;
        _HUD.removeFromSuperViewOnHide = YES;
        _HUD.detailsLabel.text = msg;
        _HUD.mode = MBProgressHUDModeAnnularDeterminate;
        _HUD.detailsLabel.font = kFontPingFangSCRegular(16);
        _HUD.contentColor = [UIColor whiteColor];
        _HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _HUD.bezelView.color = [UIColor colorWithHexString:@"333333" alpha:0.9];
        _HUD.animationType = MBProgressHUDAnimationFade;
        _HUD.userInteractionEnabled = NO;
        _HUD.detailsLabel.numberOfLines = 0;
        _HUD.margin = 16;
        _HUD.label.font = kFontPingFangSCRegular(10);
        if (view) {
            [view addSubview:_HUD];
        } else {
            [self.window addSubview:_HUD];
        }

        MBRoundProgressView *indicator = [_HUD valueForKey:@"_indicator"];
        indicator.backgroundTintColor = JL_color_clear;
        
        if ([NSString stringIsEmpty:msg]) {
            [indicator mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(28.0f);
                make.center.equalTo(_HUD.bezelView);
            }];
            
            [_HUD.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(28.0f);
                make.edges.equalTo(_HUD.bezelView).insets(UIEdgeInsetsMake(32, 32, 32, 32));
            }];
        } else {
            [indicator mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(32));
                make.size.mas_equalTo(28.0f);
                make.bottom.equalTo(_HUD.detailsLabel.mas_top).offset(-16);
                make.centerY.equalTo(_HUD);
            }];
            
            [_HUD.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(32.0f);
                make.size.mas_equalTo(28.0f);
                make.bottom.equalTo(_HUD.detailsLabel.mas_top).offset(-16.0f);
                make.centerY.equalTo(_HUD);
            }];
        }
        [_HUD showAnimated:YES];
    }
    
    _HUD.progress = progress;
    
    _HUD.label.text = [NSString stringWithFormat:@"%d%%",(int)(progress * 100)];
    
    if (progress > 0.99) {
        [_HUD hideAnimated:YES];
    }
}
@end
