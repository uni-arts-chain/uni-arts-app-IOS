//
//  JLBoxOpenPayViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLBoxOpenPayType) {
    JLBoxOpenPayTypeOne, /** 开启一次 */
    JLBoxOpenPayTypeTen, /** 开启10次 */
};

@interface JLBoxOpenPayViewController : JLBaseViewController
@property (nonatomic, assign) JLBoxOpenPayType boxOpenPayType;
@property (nonatomic, strong) Model_blind_boxes_Data *boxData;
@property (nonatomic, copy) void(^buySuccessBlock)(JLOrderPayType payType, NSString *payUrl);
@end

NS_ASSUME_NONNULL_END
