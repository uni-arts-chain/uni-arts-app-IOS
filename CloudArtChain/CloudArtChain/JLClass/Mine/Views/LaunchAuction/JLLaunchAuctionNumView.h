//
//  JLLaunchAuctionNumView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLLaunchAuctionNumViewChangeNumBlock)(NSInteger num);

@interface JLLaunchAuctionNumView : JLBaseView

@property (nonatomic, copy) JLLaunchAuctionNumViewChangeNumBlock changeNumBlock;

@property (nonatomic, assign) BOOL isShowStepper;

@property (nonatomic, assign) NSInteger maxNum;

@end

NS_ASSUME_NONNULL_END
