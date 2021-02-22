//
//  IRCryptoKeyFactory.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 07/10/2018.
//

#import "EDKeyFactory.h"
#import "ed25519_sha2.h"
#import "EDPrivateKey.h"
#import "EDPublicKey.h"

@implementation EDKeyFactory

+ (NSUInteger)seedLength {
    return 32;
}

+ (NSUInteger)hashLength {
    return 64;
}

- (nullable id<IRCryptoKeypairProtocol>)createRandomKeypair:(NSError*_Nullable*_Nullable)error {
    NSMutableData *seed = [NSMutableData dataWithLength:[[self class] seedLength]];

    int status = SecRandomCopyBytes(kSecRandomDefault, seed.length, seed.mutableBytes);

    if (status != errSecSuccess) {
        return nil;
    }

    return [self deriveFromSeed:seed error:error];
}

- (id<IRCryptoKeypairProtocol> _Nullable)deriveFromSeed:(nonnull NSData*)seed
                                                  error:(NSError*_Nullable*_Nullable)error {
    NSUInteger privateKeyLength = [EDPrivateKey length];

    NSUInteger hashLength = [[self class] hashLength];
    unsigned char hashBuffer[hashLength];

    NSUInteger publicKeyLength = [EDPublicKey length];
    unsigned char rawPublicKey[publicKeyLength];

    ed25519_sha2_create_keypair(rawPublicKey, hashBuffer, seed.bytes);

    NSData *publicKeyData = [[NSData alloc] initWithBytes:rawPublicKey
                                                   length:publicKeyLength];
    NSData *privateKeyData = [[NSData alloc] initWithBytes:hashBuffer
                                                    length:privateKeyLength];

    EDPublicKey *publicKey = [[EDPublicKey alloc] initWithRawData:publicKeyData error:error];

    if (!publicKey) {
        return nil;
    }

    EDPrivateKey *privateKey = [[EDPrivateKey alloc] initWithRawData:privateKeyData error:error];

    if (!privateKey) {
        return nil;
    }

    return [[IRCryptoKeypair alloc] initPublicKey:publicKey privateKey:privateKey];
}

- (nullable id<IRCryptoKeypairProtocol>)deriveFromPrivateKey:(nonnull id<IRPrivateKeyProtocol>)privateKey
                                                       error:(NSError*_Nullable*_Nullable)error {
    NSUInteger publicKeyLength = [EDPublicKey length];
    unsigned char rawPublicKey[publicKeyLength];

    ed25519_sha2_derive_keypair(rawPublicKey, (unsigned char*)privateKey.rawData.bytes);

    NSData *publicKeyData = [[NSData alloc] initWithBytes:rawPublicKey length:publicKeyLength];
    EDPublicKey *publicKey = [[EDPublicKey alloc] initWithRawData:publicKeyData error:error];

    if (!publicKey) {
        return nil;
    }

    return [[IRCryptoKeypair alloc] initPublicKey:publicKey
                                       privateKey:privateKey];
}

@end
