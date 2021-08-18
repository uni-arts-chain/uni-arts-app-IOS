//
//  JLAuctionListViewController.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLAuctionListViewController : JLBaseViewController

@property (nonatomic, assign) JLAuctionHistoryType type;

@property (nonatomic, assign) CGFloat topInset;

- (void)refreshDatas;

@end

NS_ASSUME_NONNULL_END
