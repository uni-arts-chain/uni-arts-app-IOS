//
//  JLWorkListNotListCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWorkListBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLWorkListNotListCell : JLWorkListBaseTableViewCell
@property (nonatomic, copy) void(^addToListBlock)(Model_art_Detail_Data *artDetailData);
@property (nonatomic, copy) void(^applyAuctionBlock)(Model_art_Detail_Data *artDetailData, NSIndexPath *indexPath);
@property (nonatomic, copy) void(^applyAddCertBlock)(Model_art_Detail_Data *artDetailData);
- (void)setArtDetail:(Model_art_Detail_Data *)artDetailData indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
