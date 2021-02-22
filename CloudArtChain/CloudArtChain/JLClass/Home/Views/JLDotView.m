//
//  JLDotView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/19.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLDotView.h"

static CGFloat const kAnimateDuration = 1;

@implementation JLDotView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    self.backgroundColor = [UIColor colorWithHexString:@"#E5EBEE"];
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
}

- (void)changeActivityState:(BOOL)active {
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDeactiveState];
    }
}


- (void)animateToActiveState {
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [UIColor colorWithHexString:@"#BAC0C3"];
        CGRect frame = self.frame;
        frame.size.width += 3.0f;
        self.frame = frame;
    } completion:nil];
}

- (void)animateToDeactiveState
{
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [UIColor colorWithHexString:@"#E5EBEE"];
        CGRect frame = self.frame;
        frame.size.width = frame.size.height;
        self.frame = frame;
    } completion:nil];
}
@end
