//
//  JLImageSizeCacheDefaults.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLImageSizeCacheDefaults.h"

@implementation JLImageSizeCacheDefaults
+ (JLImageSizeCacheDefaults *)standardUserDefaults {
    static dispatch_once_t onceToken;
    static JLImageSizeCacheDefaults *userDefault = nil;
    dispatch_once(&onceToken, ^{
        userDefault = [[JLImageSizeCacheDefaults alloc] initWithSuiteName:@"JLImageSizeCacheDefaults"];
    });
    return userDefault;
}
@end
