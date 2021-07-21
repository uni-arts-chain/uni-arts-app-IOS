//
//  JLAuctionDepositPayView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/20.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JLAuctionDepositPayViewPayType) {
    JLAuctionDepositPayViewPayTypeCashAccount,
    JLAuctionDepositPayViewPayTypeWechat,
    JLAuctionDepositPayViewPayTypeAlipay
};

typedef void(^JLAuctionDepositPayViewCompleteBlock)(JLAuctionDepositPayViewPayType payType);

@interface JLAuctionDepositPayView : UIView

+ (void)showWithTitle: (NSString *)title tipTitle: (NSString *)tipTitle payMoney: (NSString *)payMoney cashAccountBalance: (NSString *)cashAccountBalance complete: (JLAuctionDepositPayViewCompleteBlock)complete;

@end
