//
//  JLThemeRecommendView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLThemeRecommendView : JLBaseView
@property (nonatomic, copy) void(^themeRecommendBlock)(void);
@end

NS_ASSUME_NONNULL_END
