//
//  JLLoginUtil.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLLoginRegisterViewController.h"
#import "UserDataBody.h"

typedef void(^VerifySuccess)(NSString *codeStr);
typedef void(^VerifyFailure)(NSString *codeStr);

/**
 *  持久化登录用户数据的键名
 */
#define     userDictKey          @"userDict"
#define     userTokenKey         @"userToken"
#define     expireAtKey          @"expireAt"
#define     savedAccountKey      @"savedAccount"
#define     savedPasswordKey     @"savedPassword"

@interface JLLoginUtil : NSObject

+ (void)presentLoginViewController;

+ (void)presentLoginViewControllerWithSuccess:(JLLoginSuccessBlock)successBlock failure:(JLLoginFailureBlock)failureBlock;

+ (BOOL)haveToken;

//退出登录
+ (void)logout;

//删除Cookie
+ (void)deleteCookie;

//缓存用户登录信息
+ (void)cacheUserInfo:(id)userInfo;

//获取缓存用户信息
+ (id)getCacheUserInfo;

//存储用户密码
+ (void)cacheUserAccount:(NSString*)account;
+ (void)cacheUserPassword:(NSString*)password;
+ (NSString*)getAccount;
+ (NSString*)getPassword;
+ (void)removeUserAccount;
+ (void)removeUserPassword;
+ (void)cacheUserToken:(UserDataTokens *)firstToken;
@end
