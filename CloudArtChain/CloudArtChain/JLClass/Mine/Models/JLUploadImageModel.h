//
//  JLUploadImageModel.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLUploadImageModel : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageType;
@property (nonatomic, strong) NSData *imageData;
+ (instancetype)uploadImageModelWithImage:(UIImage *)image imageType:(NSString *)imageType imageData:(NSData *)imageData;
@end

NS_ASSUME_NONNULL_END
