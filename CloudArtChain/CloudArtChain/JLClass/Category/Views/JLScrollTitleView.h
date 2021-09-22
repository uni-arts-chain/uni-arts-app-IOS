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

/// 是否显示底部线 默认不显示
@property (nonatomic, assign) BOOL isShowBottomLine;

/// 标题
@property (nonatomic, copy) NSArray *titleArray;

/// 一屏显示最大数
@property (nonatomic, assign) NSInteger screenMax;

/// 默认index
@property (nonatomic, assign) NSInteger defaultIndex;

/// 标题默认颜色
@property (nonatomic, strong) UIColor *defaultTitleColor;
/// 标题选中颜色
@property (nonatomic, strong) UIColor *selectedTitleColor;
/// 标题默认字体
@property (nonatomic, strong) UIFont *defaultTitleFont;
/// 标题选中字体
@property (nonatomic, strong) UIFont *selectedTitlFont;
/// 底部滑动条大小
@property (nonatomic, assign) CGSize bottomLineSize;

/// 滑动偏移量
- (void)scrollOffset: (CGFloat)offset;

@end

NS_ASSUME_NONNULL_END
