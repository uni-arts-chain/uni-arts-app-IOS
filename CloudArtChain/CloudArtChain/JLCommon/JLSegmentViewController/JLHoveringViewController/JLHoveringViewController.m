//
//  JLHoveringViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/13.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLHoveringViewController.h"
#import "JLMultiResponseScrollView.h"
#import "JLSegmentViewController.h"
//#import "JLArtListViewController.h"

@interface JLHoveringViewController () <UIScrollViewDelegate, JLSegmentViewControllerDelegate>

@property (nonatomic, strong) JLSegmentViewController *segmentVC;

@property (nonatomic, strong) UIView *topHeaderView;

@property (nonatomic, strong) UIView *middleHoverView;

@property (nonatomic, assign) CGSize contentSize;

@property (nonatomic, strong) JLMultiResponseScrollView *contentScrollView;

@property (nonatomic, copy) NSArray <UIViewController *> *viewControllerArray;

@property (nonatomic, assign) BOOL superCanScroll;

@property (nonatomic, strong) UIViewController *currentViewController;

@end

@implementation JLHoveringViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.superCanScroll = YES;
    
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.contentScrollView];
    // 头部视图
    self.topHeaderView = [self.delegate topHeaderView];
    if (self.topHeaderView) {
        [self.contentScrollView addSubview:self.topHeaderView];
        self.topHeaderView.frame = CGRectMake(0, 0, self.contentScrollView.frameWidth, self.topHeaderView.frameHeight);
    }
    // 中部滑动指示视图
    self.middleHoverView = [self.delegate middleHoverView];
    if (self.middleHoverView) {
        [self.contentScrollView addSubview:self.middleHoverView];
        self.middleHoverView.frame = CGRectMake(0, self.topHeaderView.frameHeight, self.contentScrollView.frameWidth, self.middleHoverView.frameHeight);
    }
    // 底部滑动视图
    self.viewControllerArray = [self.delegate viewControllers];
    if (self.viewControllerArray.count) {
        self.segmentVC = [[JLSegmentViewController alloc] initWithFrame:CGRectMake(0, self.middleHoverView.frameBottom, self.contentScrollView.frameWidth, self.contentScrollView.frameHeight - self.middleHoverView.frameHeight) viewControllers:self.viewControllerArray];
        self.segmentVC.delegate = self;
        [self addChildViewController:self.segmentVC];
        [self.contentScrollView addSubview:self.segmentVC.view];
        
        self.currentViewController = self.viewControllerArray[0];
    }
    
    JLLog(@"screenHeight:%f \ncontentHeight: %f \ncontentScrollViewHeight: %f \ntopHeaderViewHeight: %f \nmiddleHoverViewHeight: %f \nsegmentVC.viewHeight: %f \nsubVCHeight: %f",kScreenHeight,self.contentSize.height, self.contentScrollView.frameHeight, self.topHeaderView.frameHeight, self.middleHoverView.frameHeight, self.segmentVC.view.frameHeight, self.viewControllerArray[0].view.frameHeight);

    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frameWidth, self.segmentVC.view.frameBottom);
    
    WS(weakSelf)
    for (UIViewController *vc in self.viewControllerArray) {
//        if ([vc isMemberOfClass:JLArtListViewController.class]) {
//            ((JLArtListViewController *)vc).canScrollBlock = ^(BOOL canScroll) {
//                weakSelf.superCanScroll = canScroll;
//            };
//        }
    }
}

#pragma mark - UIScrollViewDelegate
// 向上滑动>0 向下滑动<0
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    JLLog(@"conteoffsetY: %f", scrollView.contentOffset.y);
    if (!self.superCanScroll) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, self.topHeaderView.frameBottom)];
//        if ([self.currentViewController isMemberOfClass:JLArtListViewController.class]) {
//            ((JLArtListViewController *)self.currentViewController).childCanScroll = YES;
//        }
    } else {
        if (scrollView.contentOffset.y >= self.topHeaderView.frameBottom) {
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, self.topHeaderView.frameBottom)];
            self.superCanScroll = NO;
//            if ([self.currentViewController isMemberOfClass:JLArtListViewController.class]) {
//                ((JLArtListViewController *)self.currentViewController).childCanScroll = YES;
//            }
        }
    }
    
}

#pragma mark - JLSegmentViewControllerDelegate
/// 手动滑动 偏移
- (void)scrollOffset:(CGPoint)offset {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollSegmentVCOffset:)]) {
        [self.delegate scrollSegmentVCOffset: offset];
    }
    
    NSInteger index = offset.x / kScreenWidth;
    self.currentViewController = self.viewControllerArray[index];
}

- (void)scrollViewControllerToIndex: (NSInteger)index {
    [self.segmentVC moveToViewControllerAtIndex:index];
    
    self.currentViewController = self.viewControllerArray[index];
}

#pragma mark - setters and getters
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[JLMultiResponseScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KStatusBar_Navigation_Height)];
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

@end
