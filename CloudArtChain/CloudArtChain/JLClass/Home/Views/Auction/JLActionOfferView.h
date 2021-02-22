//
//  JLActionOfferView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLActionOfferView : JLBaseView
@property (nonatomic, copy) void(^offerBlock)(NSString *price);
@end

NS_ASSUME_NONNULL_END
