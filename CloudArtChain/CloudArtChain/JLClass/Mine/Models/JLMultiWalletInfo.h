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

@property (nonatomic, assign) JLMultiChainWalletSymbol symbol;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *userAvatar;

@end

NS_ASSUME_NONNULL_END
