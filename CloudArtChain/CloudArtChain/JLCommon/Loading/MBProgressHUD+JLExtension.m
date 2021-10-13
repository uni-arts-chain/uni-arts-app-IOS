//
//  MBProgressHUD+JLExtension.m
//  Playground
//
//  Created by fyzq on 2021/2/8.
//  Copyright © 2021 奇司妙享. All rights reserved.
//

#import "MBProgressHUD+JLExtension.h"

@implementation MBProgressHUD (JLExtension)

/// 文本样式
+ (void)jl_showText: (NSString *)text {
    [MBProgressHUD jl_showWithText:text toView:nil];
}

+ (void)jl_showWithText:(NSString *)text toView:(UIView *)view {
    [MBProgressHUD jl_showWithText:text customView:nil mode:MBProgressHUDModeText autoHidden:YES delay:1.5 toView:view];
}

/// 指示器文本样式
+ (void)jl_showProgressWithText: (NSString *)text {
    [MBProgressHUD jl_showProgressWithText:text toView:nil];
}

+ (void)jl_showProgressWithText: (NSString *)text toView:(UIView *)view {
    [MBProgressHUD jl_showWithText:text customView:nil mode:MBProgressHUDModeIndeterminate autoHidden:NO delay:0 toView:view];
}

/// 成功样式
+ (void)jl_showSuccessWithText:(NSString *)text {
    [MBProgressHUD jl_showSuccessWithText:text toView:nil];
}

+ (void)jl_showSuccessWithText:(NSString *)text toView:(UIView *)view {
    [MBProgressHUD jl_showWithText:text customView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"hud_success"]] mode:MBProgressHUDModeCustomView autoHidden:YES delay:1.5 toView:view];
}

/// 失败样式
+ (void)jl_showFailureWithText:(NSString *)text {
    [MBProgressHUD jl_showFailureWithText:text toView:nil];
}

+ (void)jl_showFailureWithText:(NSString *)text toView:(UIView *)view {
    [MBProgressHUD jl_showWithText:text customView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"hud_error"]] mode:MBProgressHUDModeCustomView autoHidden:YES delay:1.5 toView:view];
}

/// 消失
+ (void)jl_hide {
    [MBProgressHUD jl_hideForView:nil];
}

+ (void)jl_hideForView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [MBProgressHUD hideHUDForView:view animated:YES];
}

/// -
+ (void)jl_showWithText:(NSString *)text customView:(UIView *)customView mode: (MBProgressHUDMode)mode autoHidden: (BOOL)autoHidden delay: (NSTimeInterval)delay toView:(UIView *)view {
    if (!text.length) {
        return;
    }
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = !autoHidden;
    hud.contentColor = [UIColor whiteColor];
    if (@available(iOS 13.0, *)) {
        hud.bezelView.blurEffectStyle = UIBlurEffectStyleSystemThickMaterialDark;
    } else {
        hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    }
    hud.mode = mode;
    hud.customView = customView;
    
    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [view bringSubviewToFront:hud];
    [hud showAnimated:YES];
    if (autoHidden) {
        [hud hideAnimated:YES afterDelay:delay];
    }
}

@end
