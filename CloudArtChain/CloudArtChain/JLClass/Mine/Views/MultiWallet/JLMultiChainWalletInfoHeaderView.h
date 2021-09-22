//
//  JLMultiChainWalletInfoHeaderView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLMultiChainWalletInfoHeaderViewDelegate <NSObject>

- (void)didTitleWithIndex: (NSInteger)index;

- (void)lookAddressQRCode: (NSString *)address;

- (void)settting;

@end

@interface JLMultiChainWalletInfoHeaderView : UIView

@property (nonatomic, weak) id<JLMultiChainWalletInfoHeaderViewDelegate> delegate;

@property (nonatomic, strong) JLMultiWalletInfo *walletInfo;

- (void)scrollOffset: (CGFloat)offset;

@end

NS_ASSUME_NONNULL_END
