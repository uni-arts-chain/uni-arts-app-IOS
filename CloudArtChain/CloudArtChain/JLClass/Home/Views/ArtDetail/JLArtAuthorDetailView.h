//
//  JLArtAuthorDetailView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/1.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLArtAuthorDetailView : JLBaseView
@property (nonatomic, strong) Model_auction_meetings_arts_Data *artsData;
@property (nonatomic, copy) void(^introduceBlock)(void);
@end

NS_ASSUME_NONNULL_END
