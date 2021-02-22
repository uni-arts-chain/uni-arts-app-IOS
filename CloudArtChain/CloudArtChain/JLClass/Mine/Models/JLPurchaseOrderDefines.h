//
//  JLPurchaseOrderDefines.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#ifndef JLPurchaseOrderDefines_h
#define JLPurchaseOrderDefines_h

typedef NS_ENUM(NSUInteger, JLPurchaseOrderState) {
    JLPurchaseOrderStateAll, /** 全部订单 */
    JLPurchaseOrderStatePaying, /** 待支付 */
    JLPurchaseOrderStateProgressing, /** 进行中 */
    JLPurchaseOrderStateDone, /** 已完成 */
    JLPurchaseOrderStateClose, /** 交易关闭 */
};

typedef NS_ENUM(NSUInteger, JLSellOrderState) {
    JLSellOrderStateAll, /** 全部订单 */
    JLSellOrderStateDeliverint, /** 待发货 */
    JLSellOrderStateProgressing, /** 进行中 */
    JLSellOrderStateDone, /** 已完成 */
};

#endif /* JLPurchaseOrderDefines_h */
