//
//  JLAuctionOfferRecordCell.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLAuctionOfferRecordCell : UITableViewCell
- (void)setBidHistory:(Model_auctions_bid_Data *)bidData indexPath:(NSIndexPath *)indexPath;
- (void)setBidHistory:(BidHistory *)bidHistory indexPath:(NSIndexPath *)indexPath blockDate:(NSDate *)blockDate blockNumber:(UInt32)blockNumber;
@end

NS_ASSUME_NONNULL_END
