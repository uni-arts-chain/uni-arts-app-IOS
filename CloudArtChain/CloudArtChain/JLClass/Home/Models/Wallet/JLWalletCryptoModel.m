//
//  JLWalletCryptoModel.m
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/6.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWalletCryptoModel.h"

//#import <CoreBitcoin/CoreBitcoin.h>

#import "crypto_sign_ed25519.h"

//#import "BTCBase58.h"

@implementation JLWalletCryptoModel
+ (JLWalletCryptoKeyPair *)getKeyPair {

//    unsigned char seed[32],publickey[32],privatekey[64];
//
//    int i = crypto_sign_ed25519_keypair(publickey,privatekey);
//
//    NSData * publickey_data= [NSData dataWithBytes:publickey length:32];
//
//    NSData * privatekey_data= [NSData dataWithBytes:privatekey length:64];
//
//
//    NSString *privatekeyStr = BTCBase58StringWithData(privatekey_data);
//
//    NSString *publickeyStr = BTCBase58StringWithData(publickey_data);
    
    NSString *privatekeyStr = @"";
    NSString *publickeyStr = @"";
    
    return [JLWalletCryptoKeyPair KeyPairWithPrivate:privatekeyStr publicKey:publickeyStr];
}
@end
