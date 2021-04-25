//
//  AppSingleton.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDataBody.h"
#import "JLArtsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppSingleton : NSObject
+ (AppSingleton *)sharedAppSingleton;

@property (nonatomic,strong) JLNavigationViewController * globalNavController;
@property (nonatomic,strong) NSString * firstToken;
@property (nonatomic,strong) JLLoginUtil * loginUtil;
//用户信息
@property (nonatomic, strong) UserDataBody * userBody;
//作品主题
@property (nonatomic, strong) NSArray<Model_arts_theme_Data *> *artThemeArray;
//作品类型
@property (nonatomic, strong) NSArray<Model_arts_art_types_Data *> *artTypeArray;
//作品价格
@property (nonatomic, strong) NSArray<Model_arts_prices_Data *> *artPriceArray;

//获取token
+ (NSString*)getToken;

//获取token有效期
+ (NSString*)getTokenExpireAtKey;

//持久化登录调用
+ (void)loginInfonWithBlock:(void(^)(void))block;

// 请求系统信息
+ (void)systemInfo;
@end

NS_ASSUME_NONNULL_END
