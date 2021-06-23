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

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 ** orientation:    方向（0）竖线 （1）横线
 **/
+ (UIView *)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor orientation:(int)orientation {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    [shapeLayer setLineJoin:kCALineJoinRound];

    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    if (orientation == 1) {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];

        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
        //  设置线宽，线间距
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];;
        //  设置虚线宽度
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    }else
    {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame), CGRectGetHeight(lineView.frame) / 2)];

        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineSpacing], [NSNumber numberWithInt:lineLength], nil]];

        //  设置虚线宽度
        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
    return lineView;
}
@end
