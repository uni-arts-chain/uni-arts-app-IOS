//
//  UITabBar+JLTool.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "UITabBar+JLTool.h"
#import "UIImage+JLTool.h"

@implementation UITabBar (JLTool)
- (instancetype)initWithShadowImageColor:(UIColor *)shadowImageColor {
    if (self = [super init]) {
        self.barTintColor = JL_color_white_ffffff;
        [self setShadowImage:[UIImage getImageWithColor:shadowImageColor width:kScreenWidth height:0.5f]];
        [self setBackgroundImage:[[UIImage alloc] init]];
    }
    return self;
}

+ (instancetype)tabBarWithShadowImageColor:(UIColor *)shadowImageColor {
    return [[UITabBar alloc] initWithShadowImageColor:shadowImageColor];
}

+ (instancetype)tabbarWithDefaultShadowImageColor {
    return [self tabBarWithShadowImageColor:JL_color_gray_F3F3F3];
}

@end
