//
//  JLPayWebViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/5/7.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLWechatPayWebViewControllerPayGoodType) {
    /// 艺术品
    JLWechatPayWebViewControllerPayGoodTypeArt,
    /// 盲盒
    JLWechatPayWebViewControllerPayGoodTypeBox,
    /// 拍卖保证金
    JLWechatPayWebViewControllerPayGoodTypeAuctionDeposit,
    /// 拍卖艺术品
    JLWechatPayWebViewControllerPayGoodTypeAuctionArt
};

@interface JLWechatPayWebViewController : JLBaseViewController
@property (nonatomic, strong) NSString *payUrl;
@property (nonatomic, assign) JLWechatPayWebViewControllerPayGoodType payGoodType;
@end

NS_ASSUME_NONNULL_END
