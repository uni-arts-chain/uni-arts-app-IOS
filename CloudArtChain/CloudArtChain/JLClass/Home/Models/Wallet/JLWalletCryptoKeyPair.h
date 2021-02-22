//
//  JLWalletCryptoKeyPair.h
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/6.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLWalletCryptoKeyPair : NSObject
@property (nonatomic, strong) NSString *privateKey;
@property (nonatomic, strong) NSString *publicKey;
+ (instancetype)KeyPairWithPrivate:(NSString *)privateKey publicKey:(NSString *)publicKey;
@end

NS_ASSUME_NONNULL_END
