//
//  JLMultiChainWalletInfoListCell.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLMultiChainWalletInfoListCell : UITableViewCell

@property (nonatomic, assign) NSInteger style;

@property (nonatomic, strong) JLMultiWalletInfo *walletInfo;
@property (nonatomic, copy) NSString *amount;

@property (nonatomic, strong) Model_wallet_nft_Data *nftData;

@end

NS_ASSUME_NONNULL_END
