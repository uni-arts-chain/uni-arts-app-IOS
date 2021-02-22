//
//  SECPublicKey.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 24.07.2020.
//

#import "SECPublicKey.h"

@interface SECPublicKey()

@property(nonatomic, copy)NSData *rawData;

@end

@implementation SECPublicKey

+ (NSUInteger)length {
    return 33;
}

- (nullable instancetype)initWithRawData:(nonnull NSData*)data error:(NSError*_Nullable*_Nullable)error {
    if (data.length != [[self class] length]) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Raw key size must be %@ but %@ received",
                                 @([[self class] length]), @(data.length)];
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRCryptoKeyErrorInvalidRawData
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    if (self = [super init]) {
        self.rawData = data;
    }

    return self;
}

@end
