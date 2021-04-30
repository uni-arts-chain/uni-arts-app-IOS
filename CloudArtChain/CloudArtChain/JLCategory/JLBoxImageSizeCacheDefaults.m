//
//  JLBoxImageSizeCacheDefaults.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/30.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBoxImageSizeCacheDefaults.h"

@implementation JLBoxImageSizeCacheDefaults
+ (JLBoxImageSizeCacheDefaults *)standardUserDefaults {
    static dispatch_once_t onceToken;
    static JLBoxImageSizeCacheDefaults *userDefault = nil;
    dispatch_once(&onceToken, ^{
        userDefault = [[JLBoxImageSizeCacheDefaults alloc] initWithSuiteName:@"JLBoxImageSizeCacheDefaults"];
    });
    return userDefault;
}
@end
