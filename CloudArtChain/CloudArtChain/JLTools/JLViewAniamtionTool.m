//
//  JLViewAniamtionTool.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/11.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLViewAniamtionTool.h"

@implementation JLViewAniamtionTool

/// 视图进场动画
/// @param easingFunction 效果
/// @param fromValue 开始值
/// @param toValue 结束值
+ (CAAnimation *)enterAnimationWithEasingFunction: (QGYEasingFunction)easingFunction fromValue: (NSValue *)fromValue toValue: (NSValue *)toValue {
    NSMutableArray *frames = [QGYAnimationEasingHelper interpolateValues:easingFunction fromValue:fromValue toValue:toValue];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.values = frames;
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

@end
