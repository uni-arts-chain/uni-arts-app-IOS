//
//  JLHomeHotViewController.h
//  CloudArtChain
//
//  Created by 浮云骑士 on 2021/8/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseViewController.h"

@class JLPagetableCollectionView;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLHomeHotViewControllerType) {
    JLHomeHotViewControllerTypeSelling,
    JLHomeHotViewControllerTypeAuctioning
};

@interface JLHomeHotViewController : JLBaseViewController

@property (nonatomic, copy) void(^lookArtDetailBlock)(Model_art_Detail_Data *artDetailData);
@property (nonatomic, copy) void(^lookAuctionDetailBlock)(Model_auctions_Data *auctionsData);

@property (nonatomic, assign) JLHomeHotViewControllerType type;

@property (nonatomic, strong, readonly) JLPagetableCollectionView *collectionView;

- (void)headRefresh;

@end

NS_ASSUME_NONNULL_END
