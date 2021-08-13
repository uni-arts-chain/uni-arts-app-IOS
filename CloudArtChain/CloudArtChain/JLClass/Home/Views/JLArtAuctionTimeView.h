//
//  JLArtAuctionTimeView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLArtAuctionTimeView : UIView

@property (nonatomic, assign) BOOL isShowStatus;

@property (nonatomic, strong) Model_auctions_Data *auctionsData;

@end

NS_ASSUME_NONNULL_END
