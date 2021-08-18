//
//  JLSegmentViewController.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLSegmentViewController.h"
#import "JLScrollView.h"

@interface JLSegmentViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, strong) JLScrollView *containerView;

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, assign) BOOL isDrag;

@end

@implementation JLSegmentViewController

#pragma mark - initialize
- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray<UIViewController *> *)viewControllers {
    return [self initWithFrame:frame viewControllers:viewControllers defaultIndex:0];
}

- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray<UIViewController *> *)viewControllers defaultIndex: (NSInteger)defaultIndex {
    self = [super init];
    if (!self || viewControllers.count == 0) {
        return nil;
    }
    self.navigationController.navigationBar.hidden = YES;

    self.view.frame = frame;

    [self setupContainerView];
    
    self.viewControllers = viewControllers;
    
    self.index = defaultIndex;
    
    [self updateFrameChildViewController:viewControllers[self.index] atIndex:self.index];
        
    [_containerView setContentOffset:CGPointMake(defaultIndex * self.view.frame.size.width, 0) animated:NO];
    
    return self;
}

- (void)setupContainerView {
    
    _containerView = [[JLScrollView alloc] initWithFrame:self.view.bounds];
    if (@available(iOS 11.0, *)) {
        _containerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _containerView.backgroundColor = [UIColor clearColor];
    _containerView.showsVerticalScrollIndicator = NO;
    _containerView.showsHorizontalScrollIndicator = NO;
    _containerView.delegate = self;
    _containerView.pagingEnabled = YES;
    _containerView.bounces = NO;
    [self.view addSubview:_containerView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isDrag = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_isDrag) {
        
        NSInteger index = scrollView.contentOffset.x / self.view.frame.size.width;
        if (index != self.index) {
            [self updateFrameChildViewController:self.viewControllers[index] atIndex:index];
            
            self.index = index;
        }

        if (_delegate && [_delegate respondsToSelector:@selector(scrollOffset:)]) {
            [_delegate scrollOffset:scrollView.contentOffset];
        }
    }
}

#pragma mark - public
- (void)moveToViewControllerAtIndex:(NSUInteger)index {
    _isDrag = NO;
    
    [_containerView setContentOffset:CGPointMake(index * self.view.frame.size.width, 0) animated:YES];
        
    [self updateFrameChildViewController:self.viewControllers[index] atIndex:index];
    
    self.index = index;
}

#pragma mark - private methods
- (void)updateFrameChildViewController:(UIViewController *)childViewController atIndex:(NSUInteger)index {
    
    if ([self.childViewControllers containsObject:childViewController] || !childViewController) {
        return;
    }
    
    childViewController.view.frame = CGRectOffset(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), index * self.view.frame.size.width, 0);
    
    [_containerView addSubview:childViewController.view];
    [self addChildViewController:childViewController];
}

#pragma mark - setters and getters
- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    
    _containerView.contentSize = CGSizeMake(viewControllers.count * self.view.frame.size.width, self.view.frame.size.width);
}

@end
