//
//  JLDownloadLoading.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLDownloadLoading.h"

@interface JLDownloadLoading()
/** 父视图 */
@property (nonatomic, strong) UIView *parentView;
@end

@implementation JLDownloadLoading

+ (JLDownloadLoading *)showLoadingWithView:(UIView *)view {
    JLDownloadLoading *loading = [[JLDownloadLoading alloc] initWithView:view frame:CGRectZero];
    return loading;
}

+ (JLDownloadLoading *)showLoadingWithView:(UIView *)view frame:(CGRect)frame {
    JLDownloadLoading *loading = [[JLDownloadLoading alloc] initWithView:view frame:frame];
    return loading;
}

- (instancetype)initWithView:(UIView *)view frame:(CGRect)frame {
    self = [super init];
    if (self) {
        _parentView = view;
        [self setupViewWithFrame:frame];
    }
    return self;
}

- (void)setupViewWithFrame:(CGRect)frame {
    [self.parentView addSubview:self];
    self.backgroundColor = JL_color_clear;
    self.frameSize = (frame.size.width == 0 ? CGSizeMake(28, 28) : frame.size);
    self.center = CGPointMake(self.parentView.frameWidth / 2, self.parentView.frameHeight / 2);
    self.layer.zPosition = 999;
    
    UIBezierPath *yellowPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frameWidth / 2, self.frameHeight / 2) radius:self.frameWidth / 2 startAngle:1.5 * M_PI endAngle:M_PI clockwise:YES];
    CAShapeLayer *yellowShapLayer = [CAShapeLayer layer];
    yellowShapLayer.path = yellowPath.CGPath;
    yellowShapLayer.strokeColor = [UIColor colorWithHexString:@"FFBF00"].CGColor;
    yellowShapLayer.fillColor = JL_color_clear.CGColor;
    yellowShapLayer.lineWidth = 4;
    [self.layer addSublayer:yellowShapLayer];
    
    UIBezierPath *redPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frameWidth / 2, self.frameHeight / 2) radius:self.frameWidth / 2 startAngle:M_PI endAngle:1.5 * M_PI clockwise:YES];
    CAShapeLayer *redShapLayer = [CAShapeLayer layer];
    redShapLayer.path = redPath.CGPath;
    redShapLayer.lineCap = kCALineCapRound;
    redShapLayer.lineWidth = 4;
    redShapLayer.fillColor = JL_color_clear.CGColor;
    redShapLayer.strokeColor = [UIColor colorWithHexString:@"FF5533"].CGColor;
    [self.layer addSublayer:redShapLayer];
    //旋转动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:M_PI *2];
    animation.toValue = [NSNumber numberWithFloat:0.f];
    animation.duration = 1;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)startLoading {
    //旋转动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat: M_PI *2];
    animation.toValue = [NSNumber numberWithFloat:0.f];
    animation.duration = 1;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)hideLoading {
    [self.layer removeAllAnimations];
}

- (void)hideLoadingWithRemove {
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}
@end
