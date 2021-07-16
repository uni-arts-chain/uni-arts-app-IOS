//
//  JLScrollTitleView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JLScrollTitleViewDelegate <NSObject>

- (void)didSelectIndex: (NSInteger)index;

@end

@interface JLScrollTitleView : UIView

@property (nonatomic, weak) id<JLScrollTitleViewDelegate> delegate;

/// 标题
@property (nonatomic, copy) NSArray *titleArray;

/// 一屏显示最大数
@property (nonatomic, assign) NSInteger screenMax;

/// 默认index
@property (nonatomic, assign) NSInteger defaultIndex;

/// 滑动偏移量
- (void)scrollOffset: (CGFloat)offset;

@end

NS_ASSUME_NONNULL_END
