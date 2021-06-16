//
//  JLVersionManager.m
//  Miner_Fil
//
//  Created by 朱彬 on 2020/7/13.
//  Copyright © 2020 花田半亩. All rights reserved.
//

#import "JLVersionManager.h"
#import "JLVersionUpdateView.h"

static JLVersionManager *inst = nil;

@implementation JLVersionManager
+ (JLVersionManager *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[JLVersionManager alloc] init];
    });
    return inst;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (void)checkVersion{
    [[JLVersionManager shared] updateVersionService];
}

- (void)updateVersionService {
    //版本更新逻辑
    NSString *app_Version = [NSString getMyApplicationBundleFullVersion];
    NSString *pureNumbers = @"";
    NSArray *versionArray = [app_Version componentsSeparatedByString:@"."];
    for (int i = 0; i < versionArray.count; i++) {
        NSString *subVersionStr = versionArray[i];
        NSInteger subVersion = subVersionStr.intValue;
        pureNumbers = [pureNumbers stringByAppendingString:[NSString stringWithFormat:@"%04ld", subVersion]];
    }
    Model_mobile_versions_info_Req *request = [[Model_mobile_versions_info_Req alloc] init];
    request.phone_type = @"ios";
    request.version_code = @(pureNumbers.integerValue).stringValue;
    Model_mobile_versions_info_Rsp *response = [[Model_mobile_versions_info_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            if (pureNumbers.integerValue < response.body.version_code.integerValue) {
                NSArray *descArray = [JLVersionUpdateView slipContent:response.body.desc];
                JLVersionUpdateView *updateView = [JLVersionUpdateView showUpdateView:response.body.version_name contents:descArray force:response.body.force_updated];
                updateView.downloadUrl = [response.body.download_url copy];
                updateView.openUrl = [response.body.ios_download copy];
            }
        } else {

        }
//        NSArray *descArray = [JLVersionUpdateView slipContent:@"优化初始化流程,更好的支持手机操作系统优化初始化流程,更好的支持手机操作系统优化初始化流程,更好的支持手机操作系统优化初始化流程,更好的支持手机操作系统优化初始化流程,更好的支持手机操作系统优化初始化流程,更好的支持手机操作系统优化初始化流程,更好的支持手机操作系统优化初始化流程,更好的支持手机操作系统优化初始化流程,更好的支持手机操作系统"];
//        JLVersionUpdateView *updateView = [JLVersionUpdateView showUpdateView:@"1.0.1" contents:descArray force:NO];
    }];
}
@end
