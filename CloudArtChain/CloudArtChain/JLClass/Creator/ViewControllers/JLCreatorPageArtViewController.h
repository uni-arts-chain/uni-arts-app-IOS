//
//  JLCreatorPageArtViewController.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/17.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseViewController.h"

@class JLPagetableCollectionView;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLCreatorPageArtViewControllerType) {
    JLCreatorPageArtViewControllerTypeSelling,
    JLCreatorPageArtViewControllerTypeAuctioning
};

@interface JLCreatorPageArtViewController : JLBaseViewController

@property (nonatomic, copy) void(^lookArtDetailBlock)(Model_art_Detail_Data *artDetailData);
@property (nonatomic, copy) void(^lookAuctionDetailBlock)(Model_auctions_Data *auctionsData);
@property (nonatomic, copy) void(^endRefreshBlock)(NSInteger page);

@property (nonatomic, assign) JLCreatorPageArtViewControllerType type;

@property (nonatomic, copy) NSString *authorId;

@property (nonatomic, strong, readonly) JLPagetableCollectionView *collectionView;

- (void)headRefresh;

@end

NS_ASSUME_NONNULL_END
