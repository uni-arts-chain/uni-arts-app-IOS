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
//作品分类
@property (nonatomic, strong) NSArray<Model_arts_categories_Data *> *artCategoryArray;
//作品主题
@property (nonatomic, strong) NSArray<Model_arts_themes_Data *> *artThemeArray;
//作品材质
@property (nonatomic, strong) NSArray<Model_arts_materials_Data *> *artMaterialArray;
//作品价格区间
@property (nonatomic, strong) NSArray<Model_arts_prices_Data *> *artPriceArray;

//获取token
+ (NSString*)getToken;

//获取token有效期
+ (NSString*)getTokenExpireAtKey;

//持久化登录调用
+ (void)loginInfonWithBlock:(void(^)(void))block;

// 请求系统信息
+ (void)systemInfo;

// 画作分类
- (NSString *)getArtCategoryByID:(NSString *)categoryID;
// 画作材质
- (NSString *)getMaterialByID:(NSString *)materialID;
@end

NS_ASSUME_NONNULL_END
