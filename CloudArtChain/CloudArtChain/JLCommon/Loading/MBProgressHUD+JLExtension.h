//
//  MBProgressHUD+JLExtension.h
//  Playground
//
//  Created by fyzq on 2021/2/8.
//  Copyright © 2021 奇司妙享. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (JLExtension)

/// 文本样式
+ (void)jl_showText: (NSString *)text;

+ (void)jl_showWithText:(NSString *)text toView:(UIView *)view;

/// 指示器文本样式
+ (void)jl_showProgressWithText: (NSString *)text;

+ (void)jl_showProgressWithText: (NSString *)text toView:(UIView *)view;

/// 成功样式
+ (void)jl_showSuccessWithText:(NSString *)text;

+ (void)jl_showSuccessWithText:(NSString *)text toView:(UIView *)view;

/// 失败样式
+ (void)jl_showFailureWithText:(NSString *)text;

+ (void)jl_showFailureWithText:(NSString *)text toView:(UIView *)view;

/// 消失
+ (void)jl_hide;

+ (void)jl_hideForView:(UIView *)view;

@end
