//
//  JLHoveringViewController.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/13.
//  Copyright © 2021 捷链科技. All rights reserved.
//

/// ❤️竖直方向+水平方向滑动
/// 支持自定义   头部视图  中部滑动指示视图   底部滑动视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLHoveringViewControllerDelegate <NSObject>
@required
/// 顶部视图
- (UIView *)topHeaderView;
/// 中部悬停视图
- (UIView *)middleHoverView;
/// 底部视图
- (NSArray<UIViewController *> *)viewControllers;
/// 手动滑动 偏移
- (void)scrollSegmentVCOffset:(CGPoint)offset;
@end

@interface JLHoveringViewController : UIViewController

@property (nonatomic, weak) id<JLHoveringViewControllerDelegate> delegate;

/// 整体的scrollView  用于添加刷新控件
@property (nonatomic, strong, readonly) UIScrollView *contentScrollView;

- (void)scrollViewControllerToIndex: (NSInteger)index;

@end

NS_ASSUME_NONNULL_END
