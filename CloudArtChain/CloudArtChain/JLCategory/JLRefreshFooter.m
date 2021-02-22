//
//  JLRefreshFooter.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLRefreshFooter.h"
@interface JLRefreshFooter () {
    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_refreshLabel;
}
@property (weak, nonatomic) UIView *loadingView;
@end

@implementation JLRefreshFooter
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    self.loadingView = nil;
}

-(UILabel *)refreshLabel {
    if (!_refreshLabel) {
        [self addSubview:_refreshLabel = [UILabel mj_label]];
    }
    return _refreshLabel;
}

- (UIView *)loadingView {
    if (!_loadingView) {
        UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28.0f, 28.0f)];
        UIBezierPath *yellowPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(loadingView.frameWidth / 2, loadingView.frameHeight / 2) radius:loadingView.frameWidth / 2 startAngle:1.5f * M_PI endAngle:M_PI clockwise:YES];
        CAShapeLayer *yellowShapLayer = [CAShapeLayer layer];
        yellowShapLayer.path = yellowPath.CGPath;
        yellowShapLayer.strokeColor = [JL_color_gray_101010 colorWithAlphaComponent:0.5f].CGColor;
        yellowShapLayer.fillColor = JL_color_clear.CGColor;
        yellowShapLayer.lineWidth = 4;
        [loadingView.layer addSublayer:yellowShapLayer];
        
        UIBezierPath *redPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(loadingView.frameWidth / 2, loadingView.frameHeight / 2) radius:loadingView.frameWidth / 2 startAngle:M_PI endAngle:1.5 * M_PI clockwise:YES];
        CAShapeLayer *redShapLayer = [CAShapeLayer layer];
        redShapLayer.path = redPath.CGPath;
        redShapLayer.lineCap = kCALineCapRound;
        redShapLayer.lineWidth = 4;
        redShapLayer.fillColor = JL_color_clear.CGColor;
        redShapLayer.strokeColor = JL_color_gray_101010.CGColor;
        [loadingView.layer addSublayer:redShapLayer];
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (void)startLoadingViewLoading {
    //旋转动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat: M_PI *2];
    animation.toValue = [NSNumber numberWithFloat:0.f];
    animation.duration = 1;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [self.loadingView.layer addAnimation:animation forKey:nil];
}

- (void)stopLoadingViewLoading {
    [self.loadingView.layer removeAnimationForKey:@"transform.rotation.z"];
}

#pragma mark - 重写父类的方法
- (void)prepare {
    [super prepare];
    // 设置控件的高度
    self.mj_h = 50;
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    // 设置字体
    self.refreshLabel.font = kFontPingFangSCRegular(14.0f);
    // 设置颜色
    self.refreshLabel.textColor = JL_color_gray_999999;
    self.refreshLabel.text = @"呀，到底了";
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    self.refreshLabel.frame = CGRectMake(0, 20 + self.customOffset, self.frameWidth, 20);
    self.loadingView.center = CGPointMake(self.mj_w/2, self.customOffset != 0 ? self.mj_h * 0.5 + self.customOffset + (self.mj_h - 28.0f) * 0.5f : self.mj_h * 0.5f);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing && self.customOffset == 0) {
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                self.loadingView.alpha = 1.0;
                [self stopLoadingViewLoading];
            }];
        } else {
            self.loadingView.hidden = YES;
            [self stopLoadingViewLoading];
        }
        self.refreshLabel.hidden = YES;
    } else if (state == MJRefreshStatePulling) {
        self.loadingView.hidden = NO;
        [self startLoadingViewLoading];
        self.refreshLabel.hidden = YES;
    } else if (state == MJRefreshStateRefreshing) {
        self.loadingView.hidden = NO;
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self startLoadingViewLoading];
        self.refreshLabel.hidden = YES;
    } else if (state == MJRefreshStateNoMoreData){
        self.loadingView.hidden = YES;
        [self stopLoadingViewLoading];
        self.mj_h = 40;
        self.refreshLabel.hidden = NO;
    }
}

- (void)endWithNoMoreDataNotice {
    [self setState:MJRefreshStateNoMoreData];
    self.scrollView.mj_insetB = 0;
    
}

@end
