//
//  JLPopularOriginalCollectionViewCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLPopularOriginalCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) Model_auction_meetings_arts_Data *artsData;
@property (nonatomic, strong) Model_art_Detail_Data *popularArtData;
@property (nonatomic, strong) Model_art_Detail_Data *themeArtData;
@property (nonatomic, strong) Model_art_Detail_Data *collectionArtData;
@property (nonatomic, strong) Model_art_Detail_Data *authorArtData;

@property (nonatomic, strong) Model_auctions_Data *auctionsData;
@end

NS_ASSUME_NONNULL_END
