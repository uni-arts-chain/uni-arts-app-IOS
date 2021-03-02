//
//  WMPhotoBrowserCell.m
//  WMPhotoBrowser
//
//  Created by zhengwenming on 2018/1/2.
//  Copyright © 2018年 zhengwenming. All rights reserved.
//

#import "WMPhotoBrowserCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+JLTool.h"


@interface WMPhotoBrowserCell ()<UIGestureRecognizerDelegate,UIScrollViewDelegate> {
    CGFloat _aspectRatio;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@end

@implementation WMPhotoBrowserCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.scrollView.bouncesZoom = YES;
        self.scrollView.maximumZoomScale = 2.5;//放大比例
        self.scrollView.minimumZoomScale = 1.0;//缩小比例
        self.scrollView.multipleTouchEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollView.delaysContentTouches = NO;
        self.scrollView.canCancelContentTouches = YES;
        self.scrollView.alwaysBounceVertical = NO;
        [self.contentView addSubview:self.scrollView];
        
        self.imageContainerView = [[UIView alloc] init];
        self.imageContainerView.clipsToBounds = YES;
        [self.scrollView addSubview:self.imageContainerView];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        self.imageView.clipsToBounds = YES;
        self.imageView.userInteractionEnabled = YES;
        [self.imageContainerView addSubview:self.imageView];
        
        //长按
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGRAction:)];
        longPressGR.minimumPressDuration = 0.5;
        [self.contentView addGestureRecognizer:longPressGR];
    }
    return self;
}

- (void)longPressGRAction:(UILongPressGestureRecognizer *)sender {
    WS(weakSelf)
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (weakSelf.longPressGestureBlock) {
            weakSelf.longPressGestureBlock(weakSelf.currentIndexPath);
        }
    }
}

- (void)resizeSubviews {
    WS(weakSelf)
    weakSelf.imageContainerView.origin = CGPointZero;
    weakSelf.imageContainerView.width = weakSelf.width;
    UIImage *image = weakSelf.imageView.image;
    if (image.size.height / image.size.width > weakSelf.height / weakSelf.width) {
        weakSelf.imageContainerView.height = floor(image.size.height / (image.size.width / weakSelf.width));
    } else {
        CGFloat height = image.size.height / image.size.width * weakSelf.width;
        if (height < 1 || isnan(height)) height = weakSelf.height;
        height = floor(height);
        weakSelf.imageContainerView.height = height;
        weakSelf.imageContainerView.centerY = weakSelf.height / 2;
    }
    if (weakSelf.imageContainerView.height > weakSelf.height && weakSelf.imageContainerView.height - weakSelf.height <= 1) {
        weakSelf.imageContainerView.height = weakSelf.height;
    }
    weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.width, MAX(_imageContainerView.height, weakSelf.height));
    [weakSelf.scrollView scrollRectToVisible:weakSelf.bounds animated:NO];
    weakSelf.scrollView.alwaysBounceVertical = weakSelf.imageContainerView.height <= weakSelf.height ? NO : YES;
    weakSelf.imageView.frame = weakSelf.imageContainerView.bounds;
}

-(void)layoutSubviews{
    WS(weakSelf)
    [super layoutSubviews];
    [weakSelf resizeSubviews];
}
#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    WS(weakSelf)
    if (weakSelf.scrollView.zoomScale > 1.0) {
        [weakSelf.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:weakSelf.imageView];
        CGFloat newZoomScale = weakSelf.scrollView.maximumZoomScale;
        CGFloat xsize = weakSelf.frame.size.width / newZoomScale;
        CGFloat ysize = weakSelf.frame.size.height / newZoomScale;
        [weakSelf.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)setModel:(id )model {
    WS(weakSelf)
    _model = model;
    [weakSelf.scrollView setZoomScale:1.0 animated:NO];
    if ([model isKindOfClass:[UIImage class]]){
        UIImage *aImage = (UIImage *)model;
        weakSelf.imageView.image = aImage;
    } else if ([model isKindOfClass:[NSString class]]) {
        NSString *aString = (NSString *)model;
        if ([aString rangeOfString:@"http"].location != NSNotFound) {
            self.downloadLoading = [JLLoading sharedLoading];
            [weakSelf.imageView sd_setImageWithURL:[NSURL URLWithString:aString]  placeholderImage:[UIImage imageBrowserDefaultImage] options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [weakSelf resizeSubviews];
                [weakSelf.downloadLoading hideLoading];
            }];
        }else{
            if ([aString componentsSeparatedByString:@"/"].count > 1) {
                [weakSelf.imageView sd_setImageWithURL:[NSURL URLWithString:aString] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    [weakSelf resizeSubviews];
                }];
            } else {
                weakSelf.imageView.image = [UIImage imageNamed:aString];
            }
        }
    } else if ([model isKindOfClass:[NSURL class]]){
        NSURL *aURL = (NSURL *)model;
        [weakSelf.imageView sd_setImageWithURL:aURL placeholderImage:[UIImage imageBrowserDefaultImage] options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf resizeSubviews];
        }];
    }
    [weakSelf resizeSubviews];
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    WS(weakSelf)
    return weakSelf.imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    WS(weakSelf)
    CGFloat offsetX = (scrollView.width > scrollView.contentSize.width) ? (scrollView.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.height > scrollView.contentSize.height) ? (scrollView.height - scrollView.contentSize.height) * 0.5 : 0.0;
    weakSelf.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    WS(weakSelf)
    if (weakSelf.scrollView.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

@end

