//
//  JLAuctionOfferRecordViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/19.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLAuctionOfferRecordViewController : JLBaseViewController
@property (nonatomic, strong) NSArray *bidList;
@property (nonatomic, strong) NSDate *blockDate;
@property (nonatomic, assign) UInt32 blockNumber;
@end

NS_ASSUME_NONNULL_END
