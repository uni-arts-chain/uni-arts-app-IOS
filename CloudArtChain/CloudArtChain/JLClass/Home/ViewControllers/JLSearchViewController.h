//
//  JLSearchViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLSearchViewControllerType) {
    JLSearchViewControllerTypeSelling,
    JLSearchViewControllerTypeAuctioning
};

@interface JLSearchViewController : JLBaseViewController

@property (nonatomic, assign) JLSearchViewControllerType type;

@end

NS_ASSUME_NONNULL_END
