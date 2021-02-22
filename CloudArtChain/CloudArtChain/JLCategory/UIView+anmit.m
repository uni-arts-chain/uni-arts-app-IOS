//
//  UIView+anmit.m
//  Rfinex
//
//  Created by 曾进宗 on 2018/8/17.
//  Copyright © 2018年 HuaXinBlockChain(Shenyang)Tech. All rights reserved.
//

#import "UIView+anmit.h"

/** 入场出场动画时间 */
const CGFloat SELAnimationTimeInterval = 0.5f;

@implementation UIView (anmit)

/**
 添加Alert入场动画
 @param alert 添加动画的View
 */
- (void)showWithAlert:(UIView*)alert{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = SELAnimationTimeInterval;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}

/** 添加Alert出场动画 */
- (void)dismissAlert{
    
    [UIView animateWithDuration:SELAnimationTimeInterval animations:^{
        self.transform = (CGAffineTransformMakeScale(1.2, 1.2));
        self.backgroundColor = JL_color_clear;
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)otc_dismiss:(void(^)(void))complete
{
    [UIView animateWithDuration:SELAnimationTimeInterval animations:^{
        self.transform = (CGAffineTransformMakeScale(1.2, 1.2));
        self.backgroundColor = JL_color_clear;
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (complete) {
            complete();
        }
    }];
}

@end
