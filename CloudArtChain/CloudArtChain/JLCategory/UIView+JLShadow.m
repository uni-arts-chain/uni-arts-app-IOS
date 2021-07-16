//
//  UIView+JLShadow.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "UIView+JLShadow.h"

@implementation UIView (JLShadow)
- (void)addDefaultShadow
{
    [self addShadow:[UIColor blackColor] cornerRadius:5 offsetX:0];
}

- (void)addShadow:(UIColor*)shaowColor
{
    [self addShadow:shaowColor cornerRadius:5 offsetX:0];
}

- (void)addShadow:(UIColor*)shaowColor cornerRadius:(CGFloat)radius  offsetX:(CGFloat)x {
    if (radius>0) {
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = NO;
    }
    if (shaowColor) {
        self.layer.shadowColor = shaowColor.CGColor;
    } else {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
    }
    self.layer.shadowOpacity = 0.3f;
    self.layer.shadowOffset = CGSizeMake(x, 2);
    self.layer.shadowRadius = 5.f;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
}


/// 渐变色
/// @param fromColor 开始颜色
/// @param toColor 终止颜色
- (void)addGradientFromColor: (UIColor *)fromColor toColor: (UIColor *)toColor {
    [self addGradientFromColor:fromColor toColor:toColor startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}

/// 渐变色
/// @param fromColor 开始颜色
/// @param toColor 终止颜色
/// @param startPoint 开始点
/// @param endPoint 结束点
- (void)addGradientFromColor: (UIColor *)fromColor toColor: (UIColor *)toColor startPoint: (CGPoint)startPoint endPoint: (CGPoint)endPoint {
    //设置渐变颜色
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    // 渐变颜色
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)fromColor.CGColor, (id)toColor.CGColor,  nil]];
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    [self.layer addSublayer:gradientLayer];
}
@end
