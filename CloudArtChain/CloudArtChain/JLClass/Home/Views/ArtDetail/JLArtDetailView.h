//
//  JLArtDetailView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/1.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLArtDetailView : JLBaseView
@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;
//@property (nonatomic, strong) UIImage *certificateImage;
//@property (nonatomic, copy) void(^chainCertificateBlock)(UIImage *certificateImage);
@end

NS_ASSUME_NONNULL_END

