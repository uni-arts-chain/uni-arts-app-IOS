//
//  JLMultiWalletInfo.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLMultiWalletInfo : NSObject

@property (nonatomic, assign) JLMultiChainSymbol chainSymbol;

@property (nonatomic, assign) JLMultiChainName chainName;

@property (nonatomic, copy) NSString *chainImageNamed;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *walletName;

@property (nonatomic, copy) NSString *userAvatar;

@property (nonatomic, copy) NSString *storeKey;

@end

NS_ASSUME_NONNULL_END
