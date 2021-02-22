//
//  JLHudActivityView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLHudActivityView.h"

@interface JLHudActivityView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) CAReplicatorLayer *reaplicator;
@property (nonatomic, strong) CALayer *showlayer;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSString *message;
@end

@implementation JLHudActivityView
+ (JLHudActivityView *)createHudActivityViewWithMessage:(NSString*)message OnView:(UIView *)view {
    JLHudActivityView *hud = [self  showHudActivityViewAddedTo:view animated:YES];
    hud.message = (message==nil) ? @"正在加载" : message;
//           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [hud hide:YES];
//         });
    return hud;
}

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.bounds];
}

+ (JLHudActivityView *)showHudActivityViewAddedTo:(UIView *)view animated:(BOOL)animated {
    JLHudActivityView *hud = [[self alloc] initWithView:view];
    [view addSubview:hud];
    return hud;
}

-(void)dealloc {
    NSLog(@"销毁了",nil);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_clear;
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        self.contentView.layer.cornerRadius = 10.0f;
        self.contentView.center = self.center;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"393939"];
        self.contentView.alpha = 0.8;
        [self addSubview:self.contentView];
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.text = @"正在加载";
        self.messageLabel.font = kFontPingFangSCRegular(15.0f);
        self.messageLabel.textColor = JL_color_white_ffffff;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        [self.contentView.layer addSublayer:self.reaplicator];
        [self startAnimation];
    }
    return self;
}

- (void)setMessage:(NSString *)message {
    _message = message;
    _messageLabel.text = message;
}

- (void)startAnimation {
    //对layer进行动画设置
    CABasicAnimation *animaiton = [CABasicAnimation animation];
    //设置动画所关联的路径属性
    animaiton.keyPath = @"transform.scale";
    //设置动画起始和终结的动画值
    animaiton.fromValue = @(1);
    animaiton.toValue = @(0.1);
    //设置动画时间
    animaiton.duration = 1.0f;
    //填充模型
    animaiton.fillMode = kCAFillModeForwards;
    //不移除动画
    animaiton.removedOnCompletion = NO;
    //设置动画次数
    animaiton.repeatCount = INT_MAX;
    //添加动画
    [self.showlayer addAnimation:animaiton forKey:@"anmation"];
}

- (CAReplicatorLayer *)reaplicator {
    if (_reaplicator == nil) {
        int numofInstance = 10;
        CGFloat duration = 1.0f;
        //创建repelicator对象
        CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
        replicator.bounds = CGRectMake(0, 0, 50, 50);
        replicator.position = CGPointMake(self.contentView. bounds.size.width * 0.5, self.contentView.bounds.size.height * 0.35);
        replicator.instanceCount = numofInstance;
        replicator.instanceDelay = duration / numofInstance;
        //设置每个实例的变换样式
        replicator.instanceTransform = CATransform3DMakeRotation(M_PI * 2.0 / 10.0, 0, 0, 1);
        //创建repelicator对象的子图层，repelicator会利用此子图层进行高效复制。并绘制到自身图层上
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 10, 10);
        //子图层的仿射变换是基于repelicator图层的锚点，因此这里将子图层的位置摆放到此
        CGPoint point = [replicator convertPoint:replicator.position fromLayer:self.layer];
        layer.position = CGPointMake(point.x, point.y - 20);
        layer.backgroundColor = JL_color_white_ffffff.CGColor;
        layer.cornerRadius = 5;
        layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
        _showlayer = layer;
        //将子图层添加到repelicator上
        [replicator addSublayer:layer];
        _reaplicator = replicator;
    }
   return _reaplicator;
}

- (void)hide:(BOOL)animated {
    NSAssert([NSThread isMainThread], @"MBProgressHUD needs to be accessed on the main thread.");
    self.alpha = 0.0f;
    [self removeFromSuperview];
}
@end
