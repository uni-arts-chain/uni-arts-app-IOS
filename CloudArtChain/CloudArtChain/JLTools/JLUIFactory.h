//
//  JLUIFactory.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/28.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLUIFactory : NSObject

/// 标题视图
/// @param title 标题文字
+ (UIView *)titleViewWithTitle:(NSString *)title;

/**
 创建文本
 
 @param initText 初始化文字
 @param font 字体
 @param textColor 文字颜色
 @param textAlignment 布局样式
 @return label
 */
+ (UILabel *)labelInitText:(NSString *)initText font:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment;

/// 渐变文本标签
/// @param frame frame
/// @param colors 渐变颜色 不设置时使用默认颜色
/// @param text 文本
/// @param textColor 文本颜色
/// @param font 字体
/// @param textAlignment 文本对齐方式
/// @param cornerRadius 文本标签圆角
+ (UILabel *)gradientLabelWithFrame:(CGRect)frame colors:(NSArray *)colors text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment cornerRadius:(CGFloat)cornerRadius;

/**
 用图片创建imageview
 
 @param imageName 图片名字
 @return 图片视图·
 */
+ (UIImageView *)imageViewInitImageName:(NSString *)imageName;

/**
 创建标题选择的按钮
 
 @param normalTitle 正常名字
 @param seletTitle 选择的名字
 @param normalTitleColor 正常颜色
 @param seletTitleColor 选择的颜色
 @param bgColor 背景颜色
 @param target 目标
 @param action 触发事件
 @param controlEvents 触发方式
 @param font 字体大小
 @return 创建按钮
 */
+ (UIButton *)buttonInitSeleteNormalTitle:(NSString *)normalTitle SeleteTitle:(NSString *)seletTitle NormalTitleColor:(UIColor *)normalTitleColor SeleteTitleColor:(UIColor *)seletTitleColor BGColor:(UIColor *)bgColor AddTarget:(id)target Action:(SEL)action ControlEvents:(UIControlEvents)controlEvents Font:(UIFont *)font;

/**
 创建普通按钮
 
 @param title 按钮标题
 @param titleColor 标题颜色
 @param font 字体
 @param bgColor 背景颜色
 @param target 时间目标
 @param action 点击事件
 @return 创建按钮
 */
+ (UIButton *)buttonInitTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)bgColor font:(UIFont *)font addTarget:(id)target action:(SEL)action;


/// 渐变颜色按钮
/// @param frame frame
/// @param colors 渐变颜色 不设置时使用默认颜色
/// @param normalTitle normal状态文字
/// @param normalColor normal状态文字颜色
/// @param highlightedTitle highlighted状态文字
/// @param highlightedColor highlighted状态文字颜色
/// @param target action事件目标
/// @param action 触发事件
/// @param controlEvents 触发方式
/// @param font  字体
/// @param cornerRadius 圆角
+ (UIButton *)gradientButtonWithFrame:(CGRect)frame colors:(NSArray *)colors normalTitle:(NSString *)normalTitle normalColor:(UIColor *)normalColor highlightedTitle:(NSString *)highlightedTitle highlightedColor:(UIColor *)highlightedColor addTarget:(id)target action:(SEL)action controlEvents:(UIControlEvents)controlEvents font:(UIFont *)font cornerRadius:(CGFloat)cornerRadius;

@end
