//
//  JLMultiChainWalletBackupMnemonicContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JLMultiChainWalletBackupMnemonicContentViewDelegate <NSObject>

- (void)next;

@end

@interface JLMultiChainWalletBackupMnemonicContentView : UIView

@property (nonatomic, weak) id<JLMultiChainWalletBackupMnemonicContentViewDelegate> delegate;

@property (nonatomic, copy) NSArray *mnemonicArray;

@end

NS_ASSUME_NONNULL_END
