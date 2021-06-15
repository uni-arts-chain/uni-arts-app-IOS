//
//  JLUploadWorkImageView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLUploadWorkImageView : JLBaseView
/// 是否只支持选择图片
@property (nonatomic, assign) BOOL isOnlySelectImage;
@property (nonatomic, weak) UIViewController *controller;
//@property (nonatomic, strong) UIViewController *controller;
- (NSArray *)getImageArray;
- (void)addLive2dSnapshotImage:(UIImage *)snapshotImage;
@end

NS_ASSUME_NONNULL_END
