//
//  UITabBar+JLTool.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (JLTool)
+ (instancetype)tabBarWithShadowImageColor:(UIColor *)shadowImageColor;
+ (instancetype)tabbarWithDefaultShadowImageColor;
@end

NS_ASSUME_NONNULL_END
