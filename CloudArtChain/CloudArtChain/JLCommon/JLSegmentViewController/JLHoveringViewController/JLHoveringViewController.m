//
//  JLHoveringViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/13.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLHoveringViewController.h"
#import "JLSegmentViewController.h"

@interface JLHoveringViewController () <UIScrollViewDelegate, JLSegmentViewControllerDelegate>

@property (nonatomic, strong) JLSegmentViewController *segmentVC;

@property (nonatomic, strong) UIView *topHeaderView;

@property (nonatomic, strong) UIView *middleHoverView;



//@property (nonatomic, assign) BOOL isHover;
//
//@property (nonatomic, assign) CGFloat topHeaderViewHeight;
//
//@property (nonatomic, assign) CGFloat middleHoverViewHeight;
//
//@property (nonatomic, assign) CGFloat segmentViewHeight;

@property (nonatomic, assign) CGSize contentSize;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, copy) NSArray <UIViewController *> *viewControllerArray;

@end

@implementation JLHoveringViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.contentScrollView];
    // 头部视图
    self.topHeaderView = [self.delegate topHeaderView];
    if (self.topHeaderView) {
        [self.contentScrollView addSubview:self.topHeaderView];
        self.topHeaderView.frame = CGRectMake(0, 0, self.contentScrollView.frameWidth, self.topHeaderView.frameHeight);
        self.contentSize = CGSizeMake(self.contentScrollView.frameWidth, self.topHeaderView.frameHeight + self.contentSize.height);
    }
    // 中部滑动指示视图
    self.middleHoverView = [self.delegate middleHoverView];
    if (self.middleHoverView) {
        [self.contentScrollView addSubview:self.middleHoverView];
        self.middleHoverView.frame = CGRectMake(0, self.topHeaderView.frameHeight, self.contentScrollView.frameWidth, self.middleHoverView.frameHeight);
        self.contentSize = CGSizeMake(self.contentScrollView.frameWidth, self.middleHoverView.frameHeight + self.contentSize.height);
    }
    // 底部滑动视图
    self.viewControllerArray = [self.delegate viewControllers];
    if (self.viewControllerArray.count) {
        self.segmentVC = [[JLSegmentViewController alloc] initWithFrame:CGRectMake(0, self.topHeaderView.frameHeight + self.middleHoverView.frameHeight, self.contentScrollView.frameWidth, self.contentScrollView.frameHeight) viewControllers:self.viewControllerArray];
        self.segmentVC.delegate = self;
        [self.contentScrollView addSubview:_segmentVC.view];
        [self addChildViewController:_segmentVC];
        self.contentSize = CGSizeMake(self.contentScrollView.frameWidth, self.contentScrollView.frameHeight + self.contentSize.height);
    }

    self.contentScrollView.contentSize = self.contentSize;
}

#pragma mark - UIScrollViewDelegate
// 向上滑动>0 向下滑动<0
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    JLLog(@"conteoffsetY: %f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y >= self.topHeaderView.frameHeight) {
        // 悬停头部视图
        
    }else {
        
    }
    
    scrollView.delaysContentTouches = NO;
}

#pragma mark - JLSegmentViewControllerDelegate
/// 手动滑动 偏移
- (void)scrollOffset:(CGPoint)offset {
    
    
}

#pragma mark - setters and getters
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

@end
