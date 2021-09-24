//
//  JLMultiChainWalletEditCell.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, JLMultiChainWalletEditCellStyle) {
    JLMultiChainWalletEditCellStyleDefault,
    JLMultiChainWalletEditCellStyleEdit
};
typedef void(^JLMultiChainWalletEditCellEditWalletNameBlock)(NSString *walletName);

@interface JLMultiChainWalletEditCell : UITableViewCell

@property (nonatomic, copy) JLMultiChainWalletEditCellEditWalletNameBlock editWalletNameBlock;

@property (nonatomic, assign) JLMultiChainWalletEditCellStyle style;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *walletName;

@end

NS_ASSUME_NONNULL_END
