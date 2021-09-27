//
//  JLDappMoreViewController.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/27.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *JLDappMoreViewControllerType NS_STRING_ENUM;
static JLDappMoreViewControllerType const JLDappMoreViewControllerTypeCollect = @"collect";
static JLDappMoreViewControllerType const JLDappMoreViewControllerTypeRecently = @"recently";
static JLDappMoreViewControllerType const JLDappMoreViewControllerTypeRecommend = @"recommend";
static JLDappMoreViewControllerType const JLDappMoreViewControllerTypeTransaction = @"transaction";

@interface JLDappMoreViewController : JLBaseViewController

@property (nonatomic, assign) JLDappMoreViewControllerType type;

@end

NS_ASSUME_NONNULL_END
