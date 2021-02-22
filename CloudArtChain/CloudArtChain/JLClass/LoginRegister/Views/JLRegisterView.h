//
//  JLRegisterView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLRegisterView : JLBaseView
@property (nonatomic, copy) void(^backBlock)(void);
@property (nonatomic, copy) void(^loginBlock)(void);
@end

NS_ASSUME_NONNULL_END
