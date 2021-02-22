//
//  JLAuctionCellView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/19.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLAuctionCellView : JLBaseView
@property (nonatomic, copy) void(^entryBlock)(void);
@end

NS_ASSUME_NONNULL_END
