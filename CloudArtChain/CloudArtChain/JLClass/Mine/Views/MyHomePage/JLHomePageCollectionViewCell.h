//
//  JLHomePageCollectionViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/16.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLWorksListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLHomePageCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) void(^addToListBlock)(Model_art_Detail_Data *artDetailData);
@property (nonatomic, copy) void(^offFromListBlock)(Model_art_Detail_Data *artDetailData);
@property (nonatomic, copy) void(^transferBlock)(Model_art_Detail_Data *artDetailData);
@property (nonatomic, copy) void(^auctionBlock)(Model_art_Detail_Data *artDetailData);
@property (nonatomic, copy) void(^cancelAuctionBlock)(Model_auctions_Data *auctionsData);

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData type:(JLWorkListType)listType;

@property (nonatomic, strong) Model_auctions_Data *auctionsData;
@end

NS_ASSUME_NONNULL_END
