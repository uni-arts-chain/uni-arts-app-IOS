//
//  JLAuctionListCell.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLAuctionListCellPayBlock)(NSString *auctionsId);

@interface JLAuctionListCell : UITableViewCell

@property (nonatomic, copy) JLAuctionListCellPayBlock payBlock;

- (void)setAuctionsData: (Model_auctions_Data *)auctionsData type: (JLAuctionHistoryType)type;

@end

NS_ASSUME_NONNULL_END
