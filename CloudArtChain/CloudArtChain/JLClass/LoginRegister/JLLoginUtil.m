//
//  JLLoginUtil.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLLoginUtil.h"
#import <WebKit/WebKit.h>
#import <YYCache/YYCache.h>

//登录信息
NSString *const RFUserInfoName = @"UserInfoName";
NSString *const RFUserInfo     = @"UserInfo";

@implementation JLLoginUtil

+ (void)presentLoginViewController {
    [JLLoginUtil presentLoginViewControllerWithSuccess:nil failure:nil];
}

+ (void)presentCreateWallet {
    [[JLViewControllerTool appDelegate].walletTool presenterLoadOnLaunchWithNavigationController:[AppSingleton sharedAppSingleton].globalNavController userAvatar:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]];
}

//弹出登录界面
+ (void)presentLoginViewControllerWithSuccess:(JLLoginSuccessBlock)successBlock failure:(JLLoginFailureBlock)failureBlock {
    JLLoginRegisterViewController *loginViewController = [[JLLoginRegisterViewController alloc] init];
    loginViewController.successBlock = [successBlock copy];
    loginViewController.failureBlock = [failureBlock copy];
    JLNavigationViewController *nav = [[JLNavigationViewController alloc] initWithRootViewController:loginViewController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [[AppSingleton sharedAppSingleton].globalNavController presentViewController:nav animated:YES completion:nil];
}

+ (BOOL)haveToken {
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:userTokenKey];
    token = [JLUtils trimSpace:token];
    if (token&&token.length != 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)haveSelectedAccount {
    return [[JLViewControllerTool appDelegate].walletTool hasSelectedAccount];
}

#pragma mark 退出登录
+ (void)logout {
    //删除本地
    [JLLoginUtil deleteCookie];
    [JLLoginUtil removeCacheUserInfo];

    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:userTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:expireAtKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 删除cookies
+ (void)deleteCookie {
    NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookiesArray) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    if (@available(iOS 9.0, *)) {
        WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
        [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes] completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
             for (WKWebsiteDataRecord *record  in records) {
                  [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes forDataRecords:@[record] completionHandler:^{
                      
                  }];
             }
         }];
    } else {
        // Fallback on earlier versions
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

+ (void)cacheUserInfo:(id)userInfo {
    YYCache *cache = [[YYCache alloc] initWithName:RFUserInfoName];
    [cache setObject:userInfo forKey:RFUserInfo];
}

+ (id)getCacheUserInfo {
    YYCache *cache = [[YYCache alloc] initWithName:RFUserInfoName];
    return [cache objectForKey:RFUserInfo];
}

//删除登录信息
+ (void)removeCacheUserInfo {
    YYCache *cache = [[YYCache alloc] initWithName:RFUserInfoName];
    [cache removeObjectForKey:RFUserInfo];
}

+ (void)cacheUserAccount:(NSString *)account {
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:savedAccountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)cacheUserPassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:savedPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)cacheUserToken:(UserDataTokens *)firstToken {
    [[NSUserDefaults standardUserDefaults] setObject:firstToken.token forKey:userTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:firstToken.expire_at forKey:expireAtKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getAccount {
    return [[NSUserDefaults standardUserDefaults] objectForKey:savedAccountKey];
}

+ (NSString *)getPassword {
   return [[NSUserDefaults standardUserDefaults] objectForKey:savedPasswordKey];
}

+ (void)removeUserAccount {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:savedAccountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUserPassword {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:savedPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)loginWallet {
    if ([[JLViewControllerTool appDelegate].walletTool getCurrentAccount] != nil) {
        Model_members_user_address_login_Req *request = [[Model_members_user_address_login_Req alloc] init];
        request.address = [[JLViewControllerTool appDelegate].walletTool getCurrentAccount].address;
        request.message = [[JLViewControllerTool appDelegate].walletTool getCurrentAccount].address;
        request.signature = [[JLViewControllerTool appDelegate].walletTool accountSignWithOriginData:[[[JLViewControllerTool appDelegate].walletTool getCurrentAccount].address dataUsingEncoding:NSUTF8StringEncoding] error:nil];
        request.cid = [GeTuiSdk clientId];
        request.os = @"ios";
        Model_members_user_address_login_Rsp *response = [[Model_members_user_address_login_Rsp alloc] init];
        [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
            if (netIsWork) {
                // 保存用户信息
                [AppSingleton sharedAppSingleton].userBody = response.body;
                UserDataTokens *firstToken = [response.body getToken];
                [JLLoginUtil cacheUserToken:firstToken];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoginNotification" object:nil userInfo:response.body.avatar];
            } else {
                NSLog(@"login error: %@", errorStr);
                [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
            }
        }];
    }
}
@end
