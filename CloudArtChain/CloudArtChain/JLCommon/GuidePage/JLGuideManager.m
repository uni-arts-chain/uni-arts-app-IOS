//
//  JLGuideManager.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLGuideManager.h"

static NSString *const kAppVersion = @"JLGuideAppVersion";
static NSString *const kCFBundleShortVersionString = @"CFBundleShortVersionString";

@implementation JLGuideManager
//判断是否是首次登录或者版本更新
+ (BOOL)isFirstLaunch {
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
    //版本升级或首次登录
    if (version == nil) {
        //获取当前版本号
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = infoDic[kCFBundleShortVersionString];
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:kAppVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else {
        return NO;
    }
}
@end
