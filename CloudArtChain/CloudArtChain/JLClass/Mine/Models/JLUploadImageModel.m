//
//  JLUploadImageModel.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLUploadImageModel.h"
#import "UIImage+JLTool.h"

@implementation JLUploadImageModel
- (instancetype)initWithImage:(UIImage *)image imageType:(NSString *)imageType imageData:(NSData *)imageData {
    if (self = [super init]) {
        self.image = image;
        self.imageType = imageType;
        self.imageData = imageData;
    }
    return self;
}

+ (instancetype)uploadImageModelWithImage:(UIImage *)image imageType:(NSString *)imageType imageData:(NSData *)imageData {
    return [[JLUploadImageModel alloc] initWithImage:image imageType:imageType imageData:imageData];
}

- (NSData *)imageData {
    if ([self.imageType isEqualToString:@"gif"]) {
        return _imageData;
    } else {
        return [UIImage compressOriginalImage:self.image];
    }
}
@end
