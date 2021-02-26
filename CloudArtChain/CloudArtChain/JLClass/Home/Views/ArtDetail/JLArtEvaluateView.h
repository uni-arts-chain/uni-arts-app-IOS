//
//  JLArtEvaluateView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/2.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLArtEvaluateView : JLBaseView
- (instancetype)initWithFrame:(CGRect)frame artsData:(Model_auction_meetings_arts_Data *)artsData;
- (CGFloat)getFrameBottom;
@end

NS_ASSUME_NONNULL_END
