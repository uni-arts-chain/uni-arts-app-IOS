//
//  JLMineOrderView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLMineOrderView : JLBaseView
@property (nonatomic, copy) void(^cashAccountBlock)(void);
@property (nonatomic, copy) void(^walletBlock)(void);
/// 设置区块链积分
- (void)setCurrentAccountBalance:(NSString *)amount;
/// 设置现金账户余额
- (void)setCashAccountBalance: (NSString *)amount;
@end

NS_ASSUME_NONNULL_END
