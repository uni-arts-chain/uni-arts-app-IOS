//
//  UIView+JLFrame.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "UIView+JLFrame.h"

@implementation UIView (JLFrame)
- (void)setFrameX:(CGFloat)frameX {
    CGRect frame = self.frame;
    frame.origin.x = frameX;
    self.frame = frame;
}

- (CGFloat)frameX {
    return self.frame.origin.x;
}

- (void)setFrameY:(CGFloat)frameY {
    CGRect frame = self.frame;
    frame.origin.y = frameY;
    self.frame = frame;
}

- (CGFloat)frameY {
    return self.frame.origin.y;
}

- (void)setFrameWidth:(CGFloat)frameWidth {
    CGRect frame = self.frame;
    frame.size.width = frameWidth;
    self.frame = frame;
}

- (CGFloat)frameWidth {
    return self.frame.size.width;
}

- (void)setFrameHeight:(CGFloat)frameHeight {
    CGRect frame = self.frame;
    frame.size.height = frameHeight;
    self.frame = frame;
}

- (CGFloat)frameHeight {
    return self.frame.size.height;
}

- (void)setFrameCenterX:(CGFloat)frameCenterX {
    CGPoint center = self.center;
    center.x = frameCenterX;
    self.center = center;
}

- (CGFloat)frameCenterX {
    return self.center.x;
}

- (void)setFrameCenterY:(CGFloat)frameCenterY {
    CGPoint center = self.center;
    center.y = frameCenterY;
    self.center = center;
}

- (CGFloat)frameCenterY {
    return self.center.y;
}

- (void)setFrameSize:(CGSize)frameSize {
    CGRect frame = self.frame;
    frame.size = frameSize;
    self.frame = frame;
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (CGFloat)frameLeft {
    return self.frame.origin.x;
}

- (void)setFrameLeft:(CGFloat)frameLeft {
    CGRect frame = self.frame;
    frame.origin.x = frameLeft;
    self.frame = frame;
}

- (CGFloat)frameTop {
    return self.frame.origin.y;
}

- (void)setFrameTop:(CGFloat)frameTop {
    CGRect frame = self.frame;
    frame.origin.y = frameTop;
    self.frame = frame;
}

- (CGFloat)frameRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)frameRight {
    CGRect frame = self.frame;
    frame.origin.x = frameRight - frame.size.width;
    self.frame = frame;
}

- (CGFloat)frameTail {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameTail:(CGFloat)frameTail {
    CGRect frame = self.frame;
    frame.origin.y = frameTail - frame.size.height;
    self.frame = frame;
}

- (CGFloat)frameBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)frameBottom {
    CGRect frame = self.frame;
    frame.origin.y = frameBottom - frame.size.height;
    self.frame = frame;
}
@end
