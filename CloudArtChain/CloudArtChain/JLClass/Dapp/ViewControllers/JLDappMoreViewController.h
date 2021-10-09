//
//  JLDappMoreViewController.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/27.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLDappMoreViewControllerType) {
    JLDappMoreViewControllerTypeRecommend,
    JLDappMoreViewControllerTypeChainCategory,
    JLDappMoreViewControllerTypeCollectOrRecently
};

@interface JLDappMoreViewController : JLBaseViewController

@property (nonatomic, assign) JLDappMoreViewControllerType type;

@property (nonatomic, copy) NSString *chainId;
@property (nonatomic, strong) Model_chain_category_Data *chainCategoryData;
@property (nonatomic, assign) NSInteger collectOrRecentlyIndex;

@end

NS_ASSUME_NONNULL_END
