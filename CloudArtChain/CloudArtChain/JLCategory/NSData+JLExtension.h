//
//  NSData+JLExtension.h
//  CloudArtChain
//
//  Created by jielian on 2021/6/10.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (JLExtension)

+ (NSData *)getDataFromImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
