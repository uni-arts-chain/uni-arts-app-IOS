//
//  JLEnum.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/20.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#ifndef JLEnum_h
#define JLEnum_h

#pragma mark - WKScriptMessageHandlerName
typedef NSString *WKScriptMessageHandlerName NS_STRING_ENUM;
static WKScriptMessageHandlerName const WKScriptMessageHandlerNameNftDetail = @"NftDetail";
static WKScriptMessageHandlerName const WKScriptMessageHandlerNameMysteryBoxDetail = @"MysteryBoxDetail";

#pragma mark - 拍卖订单类型
typedef NS_ENUM(NSUInteger, JLAuctionOrderType) {
    /// 买入订单
    JLAuctionOrderTypeBuy,
    /// 卖出订单
    JLAuctionOrderTypeSell
};

#endif /* JLEnum_h */
