//
//  UIView+JLFrame.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JLFrame)
@property (nonatomic, assign) CGFloat frameX;
@property (nonatomic, assign) CGFloat frameY;
@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;
@property (nonatomic, assign) CGFloat frameCenterX;
@property (nonatomic, assign) CGFloat frameCenterY;
@property (nonatomic, assign) CGSize  frameSize;
@property (nonatomic, assign) CGFloat frameLeft;
@property (nonatomic, assign) CGFloat frameTop;
@property (nonatomic, assign) CGFloat frameRight;
@property (nonatomic, assign) CGFloat frameTail;
@property (nonatomic, assign) CGFloat frameBottom;
@end

NS_ASSUME_NONNULL_END
