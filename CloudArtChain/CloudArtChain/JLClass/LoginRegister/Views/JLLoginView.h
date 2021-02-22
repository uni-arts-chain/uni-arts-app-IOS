//
//  JLLoginView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLLoginView : JLBaseView
@property (nonatomic, copy) void(^backBlock)(void);
@property (nonatomic, copy) void(^registerBlock)(void);
@property (nonatomic, copy) void(^forgetPwdBlock)(void);
@end

NS_ASSUME_NONNULL_END
