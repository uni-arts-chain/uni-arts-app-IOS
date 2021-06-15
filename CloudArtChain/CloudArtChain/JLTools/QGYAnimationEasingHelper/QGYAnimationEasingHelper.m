//
//  QGYAnimationEasingHelper.m
//
//  Created by fyzq on 2020/12/8.
//

#import "QGYAnimationEasingHelper.h"

static NSInteger QGYAnimationEasingHelperDefaultKeyframeCount = 60; // 默认60帧

float interpolate(float from, float to, float time) {
    return (to - from) * time + from;
}

id interpolateFromValue(id fromValue, id toValue, float time) {
    if ([fromValue isKindOfClass:[NSValue class]]) {
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }else if (strcmp(type, @encode(CGSize)) == 0) {
            CGSize from = [fromValue CGSizeValue];
            CGSize to = [toValue CGSizeValue];
            CGSize result = CGSizeMake(interpolate(from.width, to.width, time), interpolate(from.height, to.height, time));
            return [NSValue valueWithCGSize:result];
        }
        // ...
    }
    return (time < 0.5) ? fromValue : toValue;
}

@implementation QGYAnimationEasingHelper

+ (NSMutableArray *)interpolateValues: (QGYEasingFunction)function
                            fromValue:(NSValue *)fromValue
                              toValue:(NSValue *)toValue {
    
    return [QGYAnimationEasingHelper interpolateValues:function
                                             fromValue:fromValue
                                               toValue:toValue
                                         keyframeCount:QGYAnimationEasingHelperDefaultKeyframeCount];
}

+ (NSMutableArray *)interpolateValues: (QGYEasingFunction)function
                            fromValue:(NSValue *)fromValue
                              toValue:(NSValue *)toValue
                        keyframeCount: (NSInteger)keyframeCount {
    
    NSMutableArray *frames = [NSMutableArray array];

    NSInteger numFrames = 1.0 * keyframeCount;
    for (int i = 0; i < numFrames; i++) {
        float time = 1 / (float)numFrames * i;
        time = function(time);
        [frames addObject:interpolateFromValue(fromValue, toValue, time)];
    }
    
    return frames;
}

@end
