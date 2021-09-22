//
//  JLMultiChainWalletInfoListViewController.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseViewController.h"
#import "JLMultiChainWalletInfoListContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLMultiChainWalletInfoListViewController : JLBaseViewController

@property (nonatomic, assign) CGFloat topInset;

@property (nonatomic, assign) JLMultiChainWalletInfoListContentViewStyle style;

@property (nonatomic, strong) JLMultiWalletInfo *walletInfo;

@end

NS_ASSUME_NONNULL_END
