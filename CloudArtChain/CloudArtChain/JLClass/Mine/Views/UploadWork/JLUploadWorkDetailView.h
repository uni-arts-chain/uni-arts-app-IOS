//
//  JLUploadWorkDetailView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/18.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLUploadWorkDetailView : JLBaseView
@property (nonatomic, strong) UIViewController *controller;
- (UIImage *)getDetailImage;
- (NSString *)getDetailDescContent;
@end

NS_ASSUME_NONNULL_END
