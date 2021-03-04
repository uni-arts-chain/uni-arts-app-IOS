//
//  JLCreatorPageViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLCreatorPageViewController : JLBaseViewController
@property (nonatomic, strong) Model_art_author_Data *authorData;
@property (nonatomic, copy) void(^cancelFollowBlock)(Model_art_author_Data *authorData);
@end

NS_ASSUME_NONNULL_END
