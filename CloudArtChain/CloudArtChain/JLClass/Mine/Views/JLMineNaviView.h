//
//  JLMineNaviView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLMineNaviView : JLBaseView
@property (nonatomic, copy) void(^avatarBlock)(void);
@property (nonatomic, copy) void(^settingBlock)(void);
@property (nonatomic, copy) void(^focusBlock)(void);
@property (nonatomic, copy) void(^fansBlock)(void);
- (void)refreshInfo;
@end

NS_ASSUME_NONNULL_END
