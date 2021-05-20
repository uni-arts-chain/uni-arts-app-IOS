//
//  JLGuidePageView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLGuidePageView.h"

static NSString *const kAppVersion = @"appVersion";
static NSString *const kCFBundleShortVersionString = @"CFBundleShortVersionString";

@interface JLGuidePageView ()<UIScrollViewDelegate> {
    UIScrollView  *launchScrollView;
}

@end

@implementation JLGuidePageView
NSArray *images;
BOOL isScrollOut;//在最后一页再次滑动是否隐藏引导页
CGRect enterBtnFrame;
NSString *enterBtnImage;
static JLGuidePageView *launchView = nil;
BOOL isCurrentShow;

#pragma mark - Init methods
//不带按钮的引导页
+ (instancetype)sharedWithImages:(NSArray *)imageNames {
    images = imageNames;
    isScrollOut = YES;
    launchView = [[JLGuidePageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    launchView.backgroundColor = [UIColor whiteColor];
    return launchView;
}

//带按钮的引导页
+ (instancetype)sharedWithImages:(NSArray *)imageNames buttonImage:(NSString *)buttonImageName buttonFrame:(CGRect)frame {
    images = imageNames;
    isScrollOut = NO;
    enterBtnFrame = frame;
    enterBtnImage = buttonImageName;
    launchView = [[JLGuidePageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    launchView.backgroundColor = [UIColor whiteColor];
    return launchView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"currentColor" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"nomalColor" options:NSKeyValueObservingOptionNew context:nil];
        UIWindow *window = [self getTopLevelWindow];
        [window addSubview:self];
        [window bringSubviewToFront:self];
        [self addImages];
    }
    return self;
}

//添加引导页图片
- (void)addImages {
    [self createScrollView];
}

- (void)createScrollView {
    launchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    launchScrollView.showsHorizontalScrollIndicator = NO;
    launchScrollView.bounces = NO;
    launchScrollView.pagingEnabled = YES;
    launchScrollView.delegate = self;
    launchScrollView.contentSize = CGSizeMake(kScreenWidth * images.count, kScreenHeight);
    [self addSubview:launchScrollView];
    
    for (int i = 0; i < images.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        imageView.image = [UIImage imageNamed:images[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor whiteColor];
        [launchScrollView addSubview:imageView];
        if (i == images.count - 1) {
            //判断要不要添加button
            if (!isScrollOut) {
//                UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(enterBtnFrame.origin.x, enterBtnFrame.origin.y, enterBtnFrame.size.width, enterBtnFrame.size.height)];
//                enterButton.backgroundColor = JL_color_gray_101010;
//                enterButton.titleLabel.font = kFontPingFangSCRegular(14.0f);
//                [enterButton setTitle:@"立即体验" forState:UIControlStateNormal];
//                [enterButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
////                enterButton.layer.cornerRadius = 5;
//                [enterButton setImage:[UIImage imageNamed:enterBtnImage] forState:UIControlStateNormal];
//                [enterButton addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
//                [imageView addSubview:enterButton];
//                imageView.userInteractionEnabled = YES;
//                ViewBorderRadius(enterButton, 0.0f, 1.0f, JL_color_gray_101010);
                UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight)];
                [enterButton addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:enterButton];
                imageView.userInteractionEnabled = YES;
            }
        }
    }
}

#pragma mark - Event response
//进入按钮
- (void)enterBtnClick {
    [self hideGuidView];
}

//隐藏引导页
- (void)hideGuidView {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        isCurrentShow = NO;
        [JLGuideManager setFirstLaunch];
#if (WALLET_ENV == AUTOCREATEWALLET)
        if (![JLLoginUtil haveSelectedAccount] || ![[JLViewControllerTool appDelegate].walletTool pincodeExists]) {
            NSString *userAvatar = [NSString stringIsEmpty:[AppSingleton sharedAppSingleton].userBody.avatar[@"url"]] ? nil : [AppSingleton sharedAppSingleton].userBody.avatar[@"url"];
            [[JLViewControllerTool appDelegate].walletTool defaultCreateWalletWithNavigationController:[AppSingleton sharedAppSingleton].globalNavController userAvatar:userAvatar];
        }
#endif
    }];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    int cuttentIndex = (int)(scrollView.contentOffset.x + kScreenWidth/2)/kScreenWidth;
    if (cuttentIndex == images.count - 1) {
        if ([self isScrolltoLeft:scrollView]) {
            if (!isScrollOut) {
                return ;
            }
            [self hideGuidView];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == launchScrollView) {
//        int cuttentIndex = (int)(scrollView.contentOffset.x + kScreenWidth/2)/kScreenWidth;
    }
}

#pragma mark - Private methods
//判断滚动方向
- (BOOL)isScrolltoLeft:(UIScrollView *)scrollView {
    //YES为向左滚动，NO为右滚动
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        return YES;
    }else{
        return NO;
    }
}

//KVO监测值的变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentColor"]) {
    }
    if ([keyPath isEqualToString:@"nomalColor"]) {
    }
}

- (UIWindow *)getTopLevelWindow {
    UIWindow *topView = [UIApplication sharedApplication].keyWindow;
    for (UIWindow *win in [[UIApplication sharedApplication].windows  reverseObjectEnumerator]) {
        if ([win isEqual: topView]) {
            continue;
        }
        if (win.windowLevel > topView.windowLevel && win.hidden != YES ) {
            topView =win;
        }
    }
    return topView;
}

+ (void)showGuidePage {
    if ([JLGuideManager isFirstLaunch]) {
        isCurrentShow = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGFloat enterButtonY = 0;
            if ([[UIApplication sharedApplication] statusBarFrame].size.height > 20) {
                enterButtonY = kScreenHeight - KTouch_Responder_Height - 65.0f;
            }else {
                enterButtonY = kScreenHeight - KTouch_Responder_Height - 65.0f;
            }
            [JLGuidePageView sharedWithImages:@[@"icon_guidance_1",@"icon_guidance_2",@"icon_guidance_3"]
                                  buttonImage:@"post_normal"
                                  buttonFrame:CGRectMake(40.0f, enterButtonY, kScreenWidth - 40.0f * 2, 40.0f)];
        });
    }
}

+ (BOOL)isGuideViewShow {
    return isCurrentShow;
}
@end
