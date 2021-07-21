//
//  JLCategoryViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLCategoryViewControllerType) {
    JLCategoryViewControllerTypeSelling,
    JLCategoryViewControllerTypeAuctioning
};

@interface JLCategoryViewController : JLBaseViewController

@property (nonatomic, assign) JLCategoryViewControllerType type;

@property (nonatomic, assign) CGFloat topInset;

@end

NS_ASSUME_NONNULL_END
