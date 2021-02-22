//
//  SS58AddressFactory.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 01.07.2020.
//

#import "SS58AddressFactory.h"
#import "NSData+Blake2.h"
#import "NSData+Base58.h"

static NSString * const PREFIX = @"SS58PRE";
static const UInt8 CHECKSUM_LENGTH = 2;
static const UInt8 ADDRESS_LENGTH = 35;
static const UInt8 ACCOUNT_ID_LENGTH = 32;

@implementation SS58AddressFactory

- (nullable NSString*)addressFromPublicKey:(id<IRPublicKeyProtocol> _Nonnull)publicKey
                                      type:(SNAddressType)type
                                     error:(NSError*_Nullable*_Nullable)error {
    NSMutableData *addressData = [NSMutableData data];
    [addressData appendData:[NSData dataWithBytes:&type length:1]];

    NSData *accountId = publicKey.rawData;

    if ([accountId length] != ACCOUNT_ID_LENGTH) {
        accountId = [accountId blake2b:ACCOUNT_ID_LENGTH error:error];

        if (!accountId) {
            return nil;
        }
    }

    [addressData appendData:accountId];

    NSMutableData *checksumData = [NSMutableData data];
    [checksumData appendData:[PREFIX dataUsingEncoding:NSUTF8StringEncoding]];
    [checksumData appendData:addressData];

    NSData *hashed = [checksumData blake2bWithError:error];

    if (!hashed) {
        return nil;
    }

    [addressData appendData:[hashed subdataWithRange:NSMakeRange(0, CHECKSUM_LENGTH)]];

    return [addressData toBase58];
}

- (nullable NSData*)accountIdFromAddress:(nonnull NSString*)address
                                    type:(SNAddressType)type
                                   error:(NSError*_Nullable*_Nullable)error {
    NSData *ss58Data = [[NSData alloc] initWithBase58String:address];

    if ([ss58Data length] != ADDRESS_LENGTH) {
        if (error) {
            NSString *message = @"Only sr25519 account id supported";
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:SNAddressFactoryUnsupported
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        
        return nil;
    }

    NSRange checksumRange = NSMakeRange(ss58Data.length - CHECKSUM_LENGTH, CHECKSUM_LENGTH);
    NSData *expectedChecksum = [ss58Data subdataWithRange: checksumRange];
    NSData *addressData = [ss58Data subdataWithRange:NSMakeRange(0, checksumRange.location)];

    uint8_t addressType = ((uint8_t*)addressData.bytes)[0];

    if (addressType != type) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"%@ type expected but %@ received", @(type), @(addressType)];
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:SNAddressFactoryUnexpectedType
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    NSMutableData *checksumMessage = [NSMutableData data];
    [checksumMessage appendData:[PREFIX dataUsingEncoding:NSUTF8StringEncoding]];
    [checksumMessage appendData:addressData];

    NSData *checksum = [[checksumMessage blake2bWithError:error] subdataWithRange:NSMakeRange(0, CHECKSUM_LENGTH)];

    if (!checksum) {
        return nil;
    }

    if (![checksum isEqualToData:expectedChecksum]) {
        if (error) {
            NSString *message = @"Incorrect checksum";
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:SNAddressFactoryIncorrectChecksum
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    NSData *accountId = [addressData subdataWithRange:NSMakeRange(1, ACCOUNT_ID_LENGTH)];

    return accountId;
}

- (nullable NSNumber*)typeFromAddress:(nonnull NSString*)address
                                error:(NSError*_Nullable*_Nullable)error {
    NSData *ss58Data = [[NSData alloc] initWithBase58String:address];

    if ([ss58Data length] != ADDRESS_LENGTH) {
        if (error) {
            NSString *message = @"Only sr25519 account id supported";
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:SNAddressFactoryUnsupported
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    uint8_t type = ((uint8_t*)ss58Data.bytes)[0];

    return [NSNumber numberWithInt:type];
}

@end
