//
//  JLHomePageEditHeaderView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/16.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLHomePageEditHeaderView : JLBaseView
@property (nonatomic, strong) UserDataBody *userData;
@property (nonatomic, copy) void(^nameEditBlock)(void);
@property (nonatomic, copy) void(^descEditBlock)(void);
@end

NS_ASSUME_NONNULL_END
