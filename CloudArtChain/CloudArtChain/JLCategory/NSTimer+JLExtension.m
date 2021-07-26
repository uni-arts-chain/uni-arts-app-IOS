//
//  NSTimer+JLExtension.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "NSTimer+JLExtension.h"

@implementation NSTimer (JLExtension)

+ (NSTimer *)jl_scheduledTimerWithTimeInterval: (NSTimeInterval)interval block: (void(^)(void))block repeats: (BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(jl_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)jl_blockInvoke: (NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
