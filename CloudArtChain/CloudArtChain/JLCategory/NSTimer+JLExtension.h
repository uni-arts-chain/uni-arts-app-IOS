//
//  NSTimer+JLExtension.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (JLExtension)

+ (NSTimer *)jl_scheduledTimerWithTimeInterval: (NSTimeInterval)interval block: (void(^)(void))block repeats: (BOOL)repeats;

@end

NS_ASSUME_NONNULL_END
