//
//  JLArtListContentCell.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/13.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLArtListContentCell : UICollectionViewCell

@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;

@property (nonatomic, strong) Model_auctions_Data *auctionsData;

@end

NS_ASSUME_NONNULL_END
