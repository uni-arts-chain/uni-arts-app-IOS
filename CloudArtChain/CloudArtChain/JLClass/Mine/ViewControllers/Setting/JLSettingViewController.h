//
//  JLSettingViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/15.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLSettingViewController : JLBaseViewController
@property (nonatomic, copy) void(^backBlock)(void);
@end

NS_ASSUME_NONNULL_END
