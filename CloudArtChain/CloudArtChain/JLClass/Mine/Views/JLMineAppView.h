//
//  JLMineAppView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLMineAppView : JLBaseView
@property (nonatomic, copy) void(^appClickBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
