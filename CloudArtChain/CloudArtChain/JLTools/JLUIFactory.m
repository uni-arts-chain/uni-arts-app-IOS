//
//  JLUIFactory.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/28.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLUIFactory.h"
#import <UIKit/UIKit.h>

@implementation JLUIFactory
/// 标题视图
/// @param title 标题文字
+ (UIView *)titleViewWithTitle:(NSString *)title {
    UIView *titleView = [[UIView alloc] init];
    
    UILabel *titleLabel = [JLUIFactory labelInitText:title font:kFontPingFangSCSCSemibold(17.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    [titleView addSubview:titleLabel];
    
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = JL_color_black;
    [titleView addSubview:leftLineView];
    
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = JL_color_black;
    [titleView addSubview:rightLineView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(titleView);
    }];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleLabel.mas_left).offset(-8.0f);
        make.width.mas_equalTo(19.0f);
        make.height.mas_equalTo(2.0f);
        make.centerY.equalTo(titleView.mas_centerY);
    }];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(8.0f);
        make.width.mas_equalTo(19.0f);
        make.height.mas_equalTo(2.0f);
        make.centerY.equalTo(titleView.mas_centerY);
    }];
    
    return titleView;
}

+ (UILabel *)labelInitText:(NSString *)initText font:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [[UILabel alloc] init];
    label.font = font ? font : kFontPingFangSCRegular(15);
    label.numberOfLines = 0;
    label.text = (initText == nil ? nil : initText);
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    return label;
}

+ (UILabel *)gradientLabelWithFrame:(CGRect)frame colors:(NSArray *)colors text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment cornerRadius:(CGFloat)cornerRadius {
    
    NSArray *defaultColors = @[(__bridge id)[JL_color_blue_4FBCF9 colorWithAlphaComponent:0.8f].CGColor, (__bridge id)[JL_color_blue_018FFF colorWithAlphaComponent:0.8f].CGColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.locations = @[@(0.0),@(1.0)];
    [gradientLayer setColors:colors ? colors : defaultColors];
    gradientLayer.cornerRadius = cornerRadius;
    [label.layer addSublayer:gradientLayer];
    
    UILabel *frontLabel = [[UILabel alloc] initWithFrame:label.bounds];
    frontLabel.font = font;
    frontLabel.textColor = textColor;
    frontLabel.text = text;
    frontLabel.textAlignment = textAlignment;
    [label addSubview:frontLabel];
    return label;
}

+ (UIImageView *)imageViewInitImageName:(NSString *)imageName {
    UIImageView *imageView = [[UIImageView alloc] init];
    if (![NSString stringIsEmpty:imageName]) {
        imageView.image = [UIImage imageNamed:imageName];
    }
    return imageView;
}

+ (UIButton *)buttonInitSeleteNormalTitle:(NSString *)normalTitle SeleteTitle:(NSString *)seletTitle NormalTitleColor:(UIColor *)normalTitleColor SeleteTitleColor:(UIColor *)seletTitleColor BGColor:(UIColor *)bgColor AddTarget:(id)target Action:(SEL)action ControlEvents:(UIControlEvents)controlEvents Font:(UIFont *)font {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = bgColor;
    [button setTitle:normalTitle forState:UIControlStateNormal];
    [button setTitle:seletTitle forState:UIControlStateSelected];
    [button setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [button setTitleColor:seletTitleColor forState:UIControlStateSelected];
    button.titleLabel.font = font;
    [button addTarget:target action:action forControlEvents:controlEvents];
    return button;
}

+ (UIButton *)buttonInitTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)bgColor font:(UIFont *)font addTarget:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = bgColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)gradientButtonWithFrame:(CGRect)frame colors:(NSArray *)colors normalTitle:(NSString *)normalTitle normalColor:(UIColor *)normalColor highlightedTitle:(NSString *)highlightedTitle highlightedColor:(UIColor *)highlightedColor addTarget:(id)target action:(SEL)action controlEvents:(UIControlEvents)controlEvents font:(UIFont *)font cornerRadius:(CGFloat)cornerRadius {
    NSArray *defaultColors = @[(__bridge id)JL_color_gray_101010.CGColor, (__bridge id)JL_color_black.CGColor];
    UIButton *gradientBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gradientBtn.frame = frame;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.locations = @[@(0.0),@(1.0)];
    [gradientLayer setColors:colors ? colors : defaultColors];
    gradientLayer.cornerRadius = cornerRadius;
    [gradientBtn.layer addSublayer:gradientLayer];
    
    [gradientBtn setTitle:normalTitle forState:UIControlStateNormal];
    [gradientBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [gradientBtn setTitle:highlightedTitle forState:UIControlStateHighlighted];
    [gradientBtn setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    gradientBtn.titleLabel.font = font;
    [gradientBtn addTarget:target action:action forControlEvents:controlEvents];
    
    return gradientBtn;
}
@end
