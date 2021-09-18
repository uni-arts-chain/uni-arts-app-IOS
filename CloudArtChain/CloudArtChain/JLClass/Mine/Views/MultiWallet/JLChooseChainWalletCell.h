//
//  JLChooseChainWalletCell.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLChooseChainWalletCell : UITableViewCell

- (void)setSymbol: (JLMultiChainWalletSymbol)symbol name: (JLMultiChainWalletName)name imageNamed: (NSString *)imageNamed;

@end

NS_ASSUME_NONNULL_END
