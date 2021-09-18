//
//  JLMultiChainWalletContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLMultiChainWalletContentViewDelegate <NSObject>
/// 查看钱包
/// @param index 列表索引
- (void)lookWalletWithIndex: (NSInteger)index;
/// 导入钱包
- (void)importWallet;
@end

@interface JLMultiChainWalletContentView : UIView

@property (nonatomic, weak) id<JLMultiChainWalletContentViewDelegate> delegate;

- (void)setMultiWalletSymbol: (JLMultiChainWalletSymbol)symbol walletInfoArray: (NSArray *)walletInfoArray;

@end

NS_ASSUME_NONNULL_END
