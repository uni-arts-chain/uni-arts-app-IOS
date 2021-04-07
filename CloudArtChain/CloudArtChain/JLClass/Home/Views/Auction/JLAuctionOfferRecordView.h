//
//  JLAuctionOfferRecordView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLAuctionOfferRecordView : JLBaseView
@property (nonatomic, copy) void(^recordListBlock)(NSArray *bidList, NSDate *blockDate, UInt32 blockNumber);

- (void)setBidList:(NSArray *)bidList currentDate:(NSDate *)currentDate currentBlockNumber:(UInt32)blockNumber;
@end

NS_ASSUME_NONNULL_END
