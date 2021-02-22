//
//  JLAuctionView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/21.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLAuctionSectionView : JLBaseView
@property (nonatomic, copy) void(^entryBlock)(void);
@end

NS_ASSUME_NONNULL_END
