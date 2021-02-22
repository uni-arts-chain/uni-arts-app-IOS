//
//  JLRefreshHeader.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLRefreshHeader.h"
#import "NSBundle+MJRefresh.h"

@interface JLRefreshHeader()
{
    __unsafe_unretained UIImageView *_arrowView;
}
@property (weak, nonatomic) UIView *loadingView;
@end

@implementation JLRefreshHeader
- (UIImageView *)arrowView {
    if (!_arrowView) {
//        UIImageView *_arrowView = [[UIImageView alloc] initWithImage:[NSBundle mj_arrowImage]];
//        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}

- (UIView *)loadingView {
    if (!_loadingView) {
        UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28.0f, 28.0f)];
        UIBezierPath *yellowPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(loadingView.frameWidth / 2, loadingView.frameHeight / 2) radius:loadingView.frameWidth / 2 startAngle:1.5 * M_PI endAngle:M_PI clockwise:YES];
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


#pragma mark - 公共方法
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    self.loadingView = nil;
    [self setNeedsLayout];
}

#pragma mark - 重写父类的方法
- (void)prepare {
    [super prepare];
    self.mj_h = 50;
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.automaticallyChangeAlpha = YES;
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    // 设置文字
    [self setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"松手立即刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"正在刷新中" forState:MJRefreshStateRefreshing];
    // 设置字体
    self.stateLabel.font = [UIFont systemFontOfSize:15];
    // 设置颜色
    self.stateLabel.textColor = JL_color_gray_333333;
    self.stateLabel.hidden = YES;
}

- (void)placeSubviews {
    [super placeSubviews];
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        CGFloat stateWidth = [JLRefreshHeader mj_textWidth:self.stateLabel];
        CGFloat timeWidth = 0.0;
        if (!self.lastUpdatedTimeLabel.hidden) {
            timeWidth = [JLRefreshHeader mj_textWidth:self.lastUpdatedTimeLabel];
        }
        CGFloat textWidth = MAX(stateWidth, timeWidth);
        arrowCenterX -= textWidth / 2 + self.labelLeftInset;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.mj_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
    self.arrowView.tintColor = self.stateLabel.textColor;
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                
                self.loadingView.alpha = 1.0;
                [self stopLoadingViewLoading];
                self.arrowView.hidden = NO;
            }];
        } else {
            self.loadingView.hidden = NO;
            [self stopLoadingViewLoading];
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }
    } else if (state == MJRefreshStatePulling) {
        self.loadingView.hidden = NO;
        [self stopLoadingViewLoading];
        self.arrowView.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == MJRefreshStateRefreshing) {
        self.loadingView.hidden = NO;
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self startLoadingViewLoading];
        self.arrowView.hidden = YES;
    }
}

- (void)endRefreshingWithNotice:(NSString *)notice {
    WS(weakSelf)
    if (self.state != MJRefreshStateRefreshing) {
        return;
    }
    if ([NSString stringIsEmpty:notice]) {
        [self endRefreshing];
        return;
    }
    self.loadingView.hidden = YES;
    self.mj_h = 28 + 16;
    self.scrollView.mj_insetT -= 6;
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = notice;
    noticeLabel.font = kFontPingFangSCRegular(14);
    noticeLabel.textColor = JL_color_gray_999999;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(16, 0, 0, 0));
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf endRefreshingWithCompletionBlock:^{
            weakSelf.mj_h = 50;
            [noticeLabel removeFromSuperview];
        }];
    });
}

+ (CGFloat)mj_textWidth:(UILabel *)label {
    CGFloat stringWidth = 0;
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    if (label.attributedText) {
        if (label.attributedText.length == 0) { return 0; }
        stringWidth = [label.attributedText boundingRectWithSize:size
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                        context:nil].size.width;
    } else {
        if (label.text.length == 0) { return 0; }
        NSAssert(label.font != nil, @"请检查 mj_label's `font` 是否设置正确");
        stringWidth = [label.text boundingRectWithSize:size
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:label.font}
                                              context:nil].size.width;
    }
    return stringWidth;
}

@end
