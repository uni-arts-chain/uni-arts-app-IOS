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

+ (NSString*)getToken {
    NSString *token = @"";
    UserDataBody *userBody  = [AppSingleton sharedAppSingleton].userBody;
    if (userBody.token) {
        token = userBody.token;
    } else {
        token = [[NSUserDefaults standardUserDefaults] objectForKey:userTokenKey];
    }
    return token;
}

+ (NSString*)getTokenExpireAtKey {
    NSString *expireAt = @"";
    UserDataBody *userBody  = [AppSingleton sharedAppSingleton].userBody;
    if (userBody.expire_at) {
        expireAt = userBody.expire_at;
    } else {
        expireAt = [[NSUserDefaults standardUserDefaults] objectForKey:expireAtKey];
    }
    return expireAt;
}

+ (void)loginInfonWithBlock:(void(^)(void))block {
    [[AppSingleton sharedAppSingleton] requestLoginInfoWithBlock:block];
}

#pragma mark 持久化登录
- (void)requestLoginInfoWithBlock:(void(^)(void))block {
    WS(weakSelf)
    if ([JLLoginUtil haveToken]) {
        self.userBody = [JLLoginUtil getCacheUserInfo];
        Model_members_user_info_Req *request = [[Model_members_user_info_Req alloc] init];
        Model_members_user_info_Rsp *response = [[Model_members_user_info_Rsp alloc] init];
        [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
            if (netIsWork) {
                weakSelf.userBody = response.body;
                if (block) {
                    block();
                }
            } else {
                if (errorCode == 2015 || errorCode == 2016) {
                    //删除登录信息
                    [JLLoginUtil logout];
                }
            }
        }];
    }
}

+ (void)systemInfo {
    [[AppSingleton sharedAppSingleton] requestArtThemeWithSuccessBlock:nil];
    [[AppSingleton sharedAppSingleton] requestArtTypeWithSuccessBlock:nil];
    [[AppSingleton sharedAppSingleton] requestArtPriceWithSuccessBlock:nil];
}

#pragma mark 请求作品主题
- (void)requestArtThemeWithSuccessBlock:(void(^)(void))successBlock {
    WS(weakSelf)
    Model_arts_theme_Req *request = [[Model_arts_theme_Req alloc] init];
    Model_arts_theme_Rsp *response = [[Model_arts_theme_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.artThemeArray = response.body;
            if (successBlock) {
                successBlock();
            }
        }
    }];
}

#pragma mark 请求作品类型
- (void)requestArtTypeWithSuccessBlock:(void(^)(void))successBlock {
    WS(weakSelf)
    Model_arts_art_types_Req *request = [[Model_arts_art_types_Req alloc] init];
    Model_arts_art_types_Rsp *response = [[Model_arts_art_types_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.artTypeArray = response.body;
            if (successBlock) {
                successBlock();
            }
        }
    }];
}

#pragma mark 请求作品价格区间
- (void)requestArtPriceWithSuccessBlock:(void(^)(void))successBlock {
    WS(weakSelf)
    Model_arts_prices_Req *request = [[Model_arts_prices_Req alloc] init];
    Model_arts_prices_Rsp *response = [[Model_arts_prices_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.artPriceArray = response.body;
            if (successBlock) {
                successBlock();
            }
        }
    }];
}
@end
