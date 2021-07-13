//
//  JLSearchViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLSearchViewController : JLBaseViewController

/// 0:不分(所有) 1:新品 2:二手
@property (nonatomic, assign) NSInteger marketLevel;

@end

NS_ASSUME_NONNULL_END
