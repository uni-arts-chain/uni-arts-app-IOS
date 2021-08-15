//
//  JLMultiResponseScrollView.m
//  CloudArtChain
//
//  Created by 浮云骑士 on 2021/8/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiResponseScrollView.h"

@interface JLMultiResponseScrollView ()<UIGestureRecognizerDelegate>

@end

@implementation JLMultiResponseScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
