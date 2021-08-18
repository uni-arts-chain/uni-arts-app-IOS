//
//  JLSearchResultViewController.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLSearchResultViewControllerType) {
    JLSearchResultViewControllerTypeSelling,
    JLSearchResultViewControllerTypeAuctioning
};

@interface JLSearchResultViewController : JLBaseViewController

@property (nonatomic, assign) CGFloat topInset;

@property (nonatomic, assign) JLSearchResultViewControllerType type;

@property (nonatomic, copy) NSString *searchText;

@end

NS_ASSUME_NONNULL_END
