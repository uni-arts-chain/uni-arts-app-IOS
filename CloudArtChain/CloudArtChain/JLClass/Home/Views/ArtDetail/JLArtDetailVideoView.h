//
//  JLArtDetailVideoView.h
//  CloudArtChain
//
//  Created by jielian on 2021/6/9.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLArtDetailVideoViewPlayOrStopBlock)(NSInteger status);

@interface JLArtDetailVideoView : UIView

@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;

@property (nonatomic, copy) JLArtDetailVideoViewPlayOrStopBlock playOrStopBlock;

@end

NS_ASSUME_NONNULL_END
