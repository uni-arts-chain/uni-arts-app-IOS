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

#pragma mark - 艺术品列表
typedef NS_ENUM(NSUInteger, JLArtListType) {
    /// 首页推荐 寄售
    JLArtListTypePopularSelling,
    /// 首页推荐 拍卖
    JLArtListTypePopularAuctioning,
    /// 市场 寄售
    JLArtListTypeMarketSelling,
    /// 市场 拍卖
    JLArtListTypeMarketAuctioning,
    /// 搜索 寄售
    JLArtListTypeSearchSelling,
    /// 搜索 拍卖
    JLArtListTypeSearchAuctioning,
    /// 收藏 寄售
    JLArtListTypeCollectSelling,
    /// 收藏 拍卖
    JLArtListTypeCollectAuctioning,
    /// 其他人主页 寄售
    JLArtListTypeOtherUserSelling,
    /// 其他人主页 拍卖
    JLArtListTypeOtherUserAuctioning,
    /// 自己主页 持有
    JLArtListTypeMineHold,
    /// 自己主页 寄售
    JLArtListTypeMineSelling,
    /// 自己主页 寄售
    JLArtListTypeMineAuctioning
};


#pragma mark - 拍卖订单类型
typedef NS_ENUM(NSUInteger, JLAuctionOrderType) {
    /// 买入订单
    JLAuctionOrderTypeBuy,
    /// 卖出订单
    JLAuctionOrderTypeSell
};

#pragma mark - 拍卖历史类型
typedef NS_ENUM(NSUInteger, JLAuctionHistoryType) {
    /// 已参与
    JLAuctionHistoryTypeAttend,
    /// 已出价
    JLAuctionHistoryTypeBid,
    /// 已中标
    JLAuctionHistoryTypeWins,
    /// 已结束
    JLAuctionHistoryTypeFinish
};

#pragma mark - 创建艺术品订单 支付方式
typedef NSString *JLOrderPayTypeName NS_STRING_ENUM;
static JLOrderPayTypeName const JLOrderPayTypeNameAccount = @"account";
static JLOrderPayTypeName const JLOrderPayTypeNameWepay = @"wepay";
static JLOrderPayTypeName const JLOrderPayTypeNameAlipay = @"alipay";
static JLOrderPayTypeName const JLOrderPayTypeNameUart = @"uart";

#pragma mark - 以太坊账户类型
typedef NSString *JLEthereumType NS_STRING_ENUM;
static JLEthereumType const JLEthereumTypePrivateKey = @"privateKey";
static JLEthereumType const JLEthereumTypeHd = @"hd";
static JLEthereumType const JLEthereumTypeAddress = @"address";

#pragma mark - 多链钱包
#pragma mark 多链钱包类型名称
typedef NSString *JLMultiChainName NS_STRING_ENUM;
static JLMultiChainName const JLMultiChainNameUniArts = @"UniArts";
static JLMultiChainName const JLMultiChainNameEthereum = @"Ethereum";
static JLMultiChainName const JLMultiChainNameBitCoin = @"BitCoin";
#pragma mark 多链钱包类型符号
typedef NSString *JLMultiChainSymbol NS_STRING_ENUM;
static JLMultiChainSymbol const JLMultiChainSymbolUART = @"UART";
static JLMultiChainSymbol const JLMultiChainSymbolETH = @"ETH";
static JLMultiChainSymbol const JLMultiChainSymbolBTC = @"BTC";

#endif /* JLEnum_h */
