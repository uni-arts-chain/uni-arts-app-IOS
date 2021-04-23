//
//  JLBoxTenCardView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/22.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLBoxTenCardView : JLBaseView
@property (nonatomic, copy) void(^closeBlock)(void);
@property (nonatomic, copy) void(^homepageBlock)(void);
@end

NS_ASSUME_NONNULL_END
