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
    if ([JLLoginUtil haveToken]) {
        [[AppSingleton sharedAppSingleton] requestArtCategory];
        [[AppSingleton sharedAppSingleton] requestArtTheme];
        [[AppSingleton sharedAppSingleton] requestArtMaterial];
        [[AppSingleton sharedAppSingleton] requestArtPrice];
    }
}

#pragma mark 请求作品分类
- (void)requestArtCategory {
    WS(weakSelf)
    Model_arts_categories_Req *request = [[Model_arts_categories_Req alloc] init];
    Model_arts_categories_Rsp *response = [[Model_arts_categories_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.artCategoryArray = response.body;
        }
    }];
}

#pragma mark 请求作品主题
- (void)requestArtTheme {
    WS(weakSelf)
    Model_arts_themes_Req *request = [[Model_arts_themes_Req alloc] init];
    Model_arts_themes_Rsp *response = [[Model_arts_themes_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.artThemeArray = response.body;
        }
    }];
}

#pragma mark 请求作品材质
- (void)requestArtMaterial {
    WS(weakSelf)
    Model_arts_materials_Req *request = [[Model_arts_materials_Req alloc] init];
    Model_arts_materials_Rsp *response = [[Model_arts_materials_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.artMaterialArray = response.body;
        }
    }];
}

#pragma mark 请求作品价格区间
- (void)requestArtPrice {
    WS(weakSelf)
    Model_arts_prices_Req *request = [[Model_arts_prices_Req alloc] init];
    Model_arts_prices_Rsp *response = [[Model_arts_prices_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.artPriceArray = response.body;
        }
    }];
}

// 画作分类
- (NSString *)getArtCategoryByID:(NSString *)categoryID {
    if ([NSString stringIsEmpty:categoryID]) {
        return @"";
    }
    for (Model_arts_categories_Data *categoryData in self.artCategoryArray) {
        if ([categoryData.ID isEqualToString:categoryID]) {
            return categoryData.title;
        }
    }
    return @"";
}

// 画作材质
- (NSString *)getMaterialByID:(NSString *)materialID {
    if ([NSString stringIsEmpty:materialID]) {
        return @"";
    }
    for (Model_arts_materials_Data *materialData in self.artMaterialArray) {
        if ([materialData.ID isEqualToString:materialID]) {
            return materialData.title;
        }
    }
    return @"";
}

@end
