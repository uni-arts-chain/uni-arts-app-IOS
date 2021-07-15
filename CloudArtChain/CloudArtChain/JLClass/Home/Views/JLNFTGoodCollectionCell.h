//
//  JLNFTGoodCollectionCell.h
//  CloudArtChain
//
//  Created by jielian on 2021/6/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLNFTGoodCollectionCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger marketLevel;

@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;

@end

NS_ASSUME_NONNULL_END
