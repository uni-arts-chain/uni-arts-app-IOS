//
//  AppSingleton.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "AppSingleton.h"

@implementation AppSingleton
+ (AppSingleton *)sharedAppSingleton {
    static AppSingleton *_sharedAppSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAppSingleton = [[AppSingleton alloc] init];
    });
    return _sharedAppSingleton;
}
@end
