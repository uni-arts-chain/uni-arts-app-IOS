//
//  JLWalletCryptoModel.h
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/6.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLWalletCryptoKeyPair.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLWalletCryptoModel : NSObject
+ (JLWalletCryptoKeyPair *)getKeyPair;
@end

NS_ASSUME_NONNULL_END
