//
//  JLAuctionOfferView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLAuctionOfferViewOfferBlock)(NSString *offer);

@interface JLAuctionOfferView : UIView

/// 出价
/// @param currentPrice 当前最高出价
/// @param offerPrice 自己已经出价
/// @param addPrice 每次加价
/// @param done 完成回调
+ (void)showWithCurrentPrice: (NSString *)currentPrice offerPrice: (NSString *)offerPrice addPrice: (NSString *)addPrice done: (JLAuctionOfferViewOfferBlock)done;

@end

NS_ASSUME_NONNULL_END
