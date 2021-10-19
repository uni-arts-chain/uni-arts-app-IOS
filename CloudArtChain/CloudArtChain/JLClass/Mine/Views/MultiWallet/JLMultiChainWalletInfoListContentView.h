//
//  JLMultiChainWalletInfoListContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLMultiChainWalletInfoListContentViewStyle) {
    JLMultiChainWalletInfoListContentViewStyleMainToken,
    JLMultiChainWalletInfoListContentViewStyleToken,
    JLMultiChainWalletInfoListContentViewStyleMainNFT,
    JLMultiChainWalletInfoListContentViewStyleTokenNFT
};

@protocol JLMultiChainWalletInfoListContentViewDelegate <NSObject>

- (void)refresh;

- (void)loadMore;

@end

@interface JLMultiChainWalletInfoListContentView : UIView

@property (nonatomic, weak) id<JLMultiChainWalletInfoListContentViewDelegate> delegate;

@property (nonatomic, assign) JLMultiChainWalletInfoListContentViewStyle style;

@property (nonatomic, strong) JLMultiWalletInfo *walletInfo;
@property (nonatomic, copy) NSString *amount;

- (void)setDataArray: (NSArray *)dataArray page: (NSInteger)page pageSize: (NSInteger) pageSize;

@end

NS_ASSUME_NONNULL_END
