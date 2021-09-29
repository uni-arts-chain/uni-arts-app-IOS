//
//  JLDappSearchActivityIndicatorView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappSearchActivityIndicatorView.h"

@interface JLDappSearchActivityIndicatorView ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation JLDappSearchActivityIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
    [self addSubview:_indicatorView];
}

- (void)startAnimating {
    [_indicatorView startAnimating];
}

- (void)stopAnimating {
    [_indicatorView stopAnimating];
}

@end
