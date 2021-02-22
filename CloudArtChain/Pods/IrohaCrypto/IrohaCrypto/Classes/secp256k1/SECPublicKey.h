//
//  SECPublicKey.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 24.07.2020.
//

#import <Foundation/Foundation.h>
#import "IRCryptoKey.h"

@interface SECPublicKey : NSObject<IRPublicKeyProtocol>

+ (NSUInteger)length;

@end
