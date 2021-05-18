//
//  JLGuideManager.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface JLGuideManager : NSObject
//判断是否是首次登录或者版本更新
+ (BOOL)isFirstLaunch;
+ (void)setFirstLaunch;
+ (void)removeFirstLaunch;
@end

NS_ASSUME_NONNULL_END
