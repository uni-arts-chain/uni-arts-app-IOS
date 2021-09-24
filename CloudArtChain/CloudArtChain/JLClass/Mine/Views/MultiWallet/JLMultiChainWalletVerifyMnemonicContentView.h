//
//  JLMultiChainWalletVerifyMnemonicContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/24.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JLMultiChainWalletVerifyMnemonicContentViewDelegate <NSObject>

- (void)done;

@end

@interface JLMultiChainWalletVerifyMnemonicContentView : UIView

@property (nonatomic, weak) id<JLMultiChainWalletVerifyMnemonicContentViewDelegate> delegate;

@property (nonatomic, copy) NSArray *mnemonicArray;

@end

NS_ASSUME_NONNULL_END
