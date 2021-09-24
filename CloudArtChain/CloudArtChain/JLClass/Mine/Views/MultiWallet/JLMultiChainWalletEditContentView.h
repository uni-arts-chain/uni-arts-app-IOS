//
//  JLMultiChainWalletEditContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLMultiChainWalletEditContentViewDelegate <NSObject>

- (void)saveWalletName: (NSString *)walletName;

- (void)changePinCode;

- (void)exportPrivateKey;

- (void)exportKeystore;

- (void)privateProtocol;

- (void)backupsMnemonic;

@end

@interface JLMultiChainWalletEditContentView : UIView

@property (nonatomic, weak) id<JLMultiChainWalletEditContentViewDelegate> delegate;

@property (nonatomic, strong) JLMultiWalletInfo *walletInfo;

@end

NS_ASSUME_NONNULL_END
