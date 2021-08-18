//
//  JLAlipayWebViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/5/17.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLAlipayWebViewControllerPayGoodType) {
    /// 艺术品
    JLAlipayWebViewControllerPayGoodTypeArt,
    /// 盲盒
    JLAlipayWebViewControllerPayGoodTypeBox,
    /// 拍卖保证金
    JLAlipayWebViewControllerPayGoodTypeAuctionDeposit,
    /// 拍卖艺术品
    JLAlipayWebViewControllerPayGoodTypeAuctionArt
};

@interface JLAlipayWebViewController : JLBaseViewController
@property (nonatomic, strong) NSString *payUrl;
@property (nonatomic, assign) JLAlipayWebViewControllerPayGoodType payGoodType;
@property (nonatomic, copy) void(^paySuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
