//
//  JLCategoryViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

typedef NS_ENUM(NSUInteger, JLCategoryViewControllerType) {
    /// 新品
    JLCategoryViewControllerTypeNew,
    /// 二手
    JLCategoryViewControllerTypeOld
};

NS_ASSUME_NONNULL_BEGIN

@interface JLCategoryViewController : JLBaseViewController

@property (nonatomic, assign) JLCategoryViewControllerType type;

@end

NS_ASSUME_NONNULL_END
