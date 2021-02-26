//
//  JLAuctionDetailProductView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLAuctionDetailProductView : JLBaseView
- (void)setAuctionMeetingData:(Model_auction_meetings_Data *)auctionMeetingData auctionArtList:(NSArray *)auctionArtList;
@property (nonatomic, copy) void(^artDetailBlock)(Model_auction_meetings_arts_Data *artsData);
@end

NS_ASSUME_NONNULL_END
