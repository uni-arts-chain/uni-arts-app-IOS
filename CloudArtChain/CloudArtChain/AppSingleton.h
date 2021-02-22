//
//  AppSingleton.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDataBody.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppSingleton : NSObject
+ (AppSingleton *)sharedAppSingleton;

@property (nonatomic,strong) JLNavigationViewController * globalNavController;
@property (nonatomic,strong) NSString * firstToken;
@property (nonatomic,strong) JLLoginUtil * loginUtil;
//用户信息
@property (nonatomic, strong) UserDataBody * userBody;
@end

NS_ASSUME_NONNULL_END
