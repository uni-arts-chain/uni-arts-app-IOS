//
//  JLAuctionArtDetailViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/18.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLAuctionArtDetailType) {
    JLAuctionArtDetailTypeDetail = 1, /** 普通用户 - 可以购买 */
    JLAuctionArtDetailTypeSelf, /** 用户自己的作品*/
};

@interface JLAuctionArtDetailViewController : JLBaseViewController
@property (nonatomic, assign) JLAuctionArtDetailType artDetailType;
@end

NS_ASSUME_NONNULL_END
