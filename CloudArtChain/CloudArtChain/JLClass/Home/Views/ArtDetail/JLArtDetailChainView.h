//
//  JLArtDetailChainView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLArtDetailChainView : JLBaseView
@property (nonatomic, strong) Model_auction_meetings_arts_Data *artsData;
@property (nonatomic, copy) void(^chainQRCodeBlock)(NSString *qrcode);
@end

NS_ASSUME_NONNULL_END
