//
//  JLAlert.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLAlert.h"

@implementation JLAlert
#pragma mark 设置颜色
+ (void)jlconfigCancelAction:(LEEAction*)action title:(NSString*)title {
    action.backgroundColor = JL_color_white_ffffff;
    action.height = 35;
    action.title = title;
    action.titleColor = JL_color_gray_999999;
    action.backgroundHighlightColor = JL_color_white_ffffff;
    action.font = kFontPingFangSCRegular(15.0f);
}

+ (void)jlconfigConfirmAction:(LEEAction*)action title:(NSString*)title {
    action.backgroundColor = JL_color_white_ffffff;
    action.height = 35;
    action.title = title;
    action.titleColor = JL_color_gray_101010;
    action.backgroundHighlightColor = JL_color_white_ffffff;
    action.font = kFontPingFangSCRegular(15.0f);
}

+ (void)jlalertView:(NSString*)message cancel:(NSString*)cancel {
    [JLAlert alert].config
    .LeeMaxWidth(kScreenWidth - 53 * 2)
    .LeeItemInsets(UIEdgeInsetsMake(10, 10, 10, 10))
    .LeeAddContent(^(UILabel * _Nonnull label) {
        label.text = message;
        label.font = kFontPingFangSCRegular(15.0f);
        label.textColor = JL_color_gray_333333;
    })
    .LeeItemInsets(UIEdgeInsetsMake(20, 20, 20, 20))
    .LeeAddAction(^(LEEAction * _Nonnull action) {
        action.type = LEEActionTypeCancel;
        [JLAlert jlconfigConfirmAction:action title:cancel];
        action.borderColor = JL_color_gray_E6E6E6;
    })
    .LeeCornerRadius(5.0f)
    .LeeHeaderColor(JL_color_white_ffffff)
    .LeeShow();
}

+ (void)jlalertView:(NSString*)title message:(NSString*)message cancel:(NSString*)cancel {
    [JLAlert alert].config
    .LeeMaxWidth(kScreenWidth - 53 * 2)
    .LeeAddTitle(^(UILabel *label) {
        label.text = title;
        label.textColor = JL_color_black;
        label.font = kFontPingFangSCRegular(16.0f);
    })
    .LeeItemInsets(UIEdgeInsetsMake(10, 10, 10, 10))
    .LeeAddContent(^(UILabel * _Nonnull label) {
        label.text = message;
        label.font = kFontPingFangSCRegular(15.0f);
        label.textColor = JL_color_gray_333333;
        label.textAlignment = NSTextAlignmentCenter;
    })
    .LeeItemInsets(UIEdgeInsetsMake(10, 10, 10, 10))
    .LeeAddAction(^(LEEAction * _Nonnull action) {
        action.type = LEEActionTypeCancel;
        [JLAlert jlconfigConfirmAction:action title:cancel];
        action.borderColor = JL_color_gray_E6E6E6;
    })
    .LeeCornerRadius(5.0f)
    .LeeHeaderColor(JL_color_white_ffffff)
    .LeeShow();
}

+ (void)jlalertView:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel cancelBlock:(void(^)(void))cancelBlock confirm:(NSString *)confirm confirmBlock:(void(^)(void))confirmBlock {
    [JLAlert alert].config
    .LeeMaxWidth(kScreenWidth - 53 * 2)
    .LeeAddTitle(^(UILabel *label) {
        label.text = title;
        label.textColor = JL_color_gray_333333;
        label.font = kFontPingFangSCRegular(16.0f);
    })
    .LeeItemInsets(UIEdgeInsetsMake(10, 10, 10, 10))
    .LeeAddContent(^(UILabel * _Nonnull label) {
        label.text = message;
        label.font = kFontPingFangSCRegular(15.0f);
        label.textColor = JL_color_gray_333333;
        label.textAlignment = NSTextAlignmentCenter;
    })
    .LeeItemInsets(UIEdgeInsetsMake(10, 10, 10, 10))
    .LeeAddAction(^(LEEAction * _Nonnull action) {
        action.type = LEEActionTypeCancel;
        [JLAlert jlconfigCancelAction:action title:cancel];
        action.borderColor = JL_color_gray_E6E6E6;
        action.clickBlock = cancelBlock;
    })
    .LeeAddAction(^(LEEAction * _Nonnull action) {
        action.type = LEEActionTypeDefault;
        [JLAlert jlconfigConfirmAction:action title:confirm];
        action.borderColor = JL_color_gray_E6E6E6;
        action.clickBlock = confirmBlock;
    })
    .LeeCornerRadius(5.0f)
    .LeeHeaderColor(JL_color_white_ffffff)
    .LeeShow();
}

+ (void)jlalertDefaultView:(NSString*)message cancel:(NSString*)cancel {
    [JLAlert alert].config
    .LeeMaxWidth(kScreenWidth - 53 * 2)
    .LeeContent(message)
    .LeeAddAction(^(LEEAction * _Nonnull action) {
        action.type = LEEActionTypeCancel;
        action.title = cancel;
        action.borderColor = JL_color_gray_E6E6E6;
    })
    .LeeCornerRadius(5.0f)
    .LeeHeaderColor(JL_color_white_ffffff)
    .LeeShow();
}

+ (void)jlalertDefaultView:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel {
    [JLAlert alert].config
    .LeeMaxWidth(kScreenWidth - 53 * 2)
    .LeeTitle(title)
    .LeeContent(message)
    .LeeAddAction(^(LEEAction * _Nonnull action) {
        action.type = LEEActionTypeCancel;
        action.title = cancel;
        action.borderColor = JL_color_gray_E6E6E6;
    })
    .LeeCornerRadius(5.0f)
    .LeeHeaderColor(JL_color_white_ffffff)
    .LeeShow();
}

+ (void)jlalertDefaultView:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel cancelBlock:(void(^)(void))cancelBlock confirm:(NSString *)confirm confirmBlock:(void(^)(void))confirmBlock {
    [JLAlert alert].config
    .LeeMaxWidth(kScreenWidth - 53 * 2)
    .LeeTitle(title)
    .LeeContent(message)
    .LeeAddAction(^(LEEAction * _Nonnull action) {
        action.type = LEEActionTypeCancel;
        action.title = cancel;
        action.borderColor = JL_color_gray_E6E6E6;
        action.clickBlock = cancelBlock;
    })
    .LeeAddAction(^(LEEAction * _Nonnull action) {
        action.type = LEEActionTypeDefault;
        action.title = confirm;
        action.borderColor = JL_color_gray_E6E6E6;
        action.clickBlock = confirmBlock;
    })
    .LeeCornerRadius(5.0f)
    .LeeHeaderColor(JL_color_white_ffffff)
    .LeeShow();
}

+ (void)alertCustomView:(UIView *)customView maxWidth:(CGFloat)maxWidth {
    [JLAlert alert].config
    .LeeCornerRadius(0.0f)
    .LeeMaxWidth(maxWidth)
    .LeeCustomView(customView)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor(JL_color_clear)
    .LeeBackGroundColor(JL_color_clear)
    .LeeShow();
}

@end
