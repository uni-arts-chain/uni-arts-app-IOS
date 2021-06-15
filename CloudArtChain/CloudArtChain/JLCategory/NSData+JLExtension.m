//
//  NSData+JLExtension.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/10.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "NSData+JLExtension.h"

@implementation NSData (JLExtension)

+ (NSData *)getDataFromImage:(UIImage *)image {
    NSData *data;
    data = UIImagePNGRepresentation(image);
    if(!data) {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    return data;
}

@end
