//
//  JLChooseChainWalletContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLChooseChainWalletContentViewDelegate <NSObject>

- (void)didSelect: (JLMultiChainWalletSymbol)symbol;

@end

@interface JLChooseChainWalletContentView : UIView

@property (nonatomic, weak) id<JLChooseChainWalletContentViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
