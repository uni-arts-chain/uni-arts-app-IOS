//
//  JLMultiChainWalletImportContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLMultiChainWalletImportContentViewDelegate <NSObject>

- (void)chooseImportType;

- (void)paste;

- (void)nextWithWalletName: (NSString *)walletName
               mnonicArray: (NSArray * _Nullable)mnonicArray
                privateKey: (NSString * _Nullable)privateKey
                  keystore: (NSString * _Nullable)keystore
          keystorePassword: (NSString * _Nullable)keystorePassword;

@end

@interface JLMultiChainWalletImportContentView : UIView

@property (nonatomic, weak) id<JLMultiChainWalletImportContentViewDelegate> delegate;

@property (nonatomic, assign) JLMultiChainImportType importType;
@property (nonatomic, copy) NSString *keystore;

@end

NS_ASSUME_NONNULL_END
