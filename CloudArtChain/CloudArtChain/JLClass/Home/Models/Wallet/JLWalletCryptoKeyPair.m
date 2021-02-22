//
//  JLWalletCryptoKeyPair.m
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/6.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWalletCryptoKeyPair.h"

@implementation JLWalletCryptoKeyPair
- initWithPrivate:(NSString *)privateKey publicKey:(NSString *)publicKey {
    if (self = [super init]) {
        self.privateKey = privateKey;
        self.publicKey = publicKey;
    }
    return self;
}

+ (instancetype)KeyPairWithPrivate:(NSString *)privateKey publicKey:(NSString *)publicKey {
    return [[JLWalletCryptoKeyPair alloc] initWithPrivate:privateKey publicKey:publicKey];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"private: %@, public: %@", self.privateKey, self.publicKey];
}

@end
