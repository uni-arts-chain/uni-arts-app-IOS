//
//  JLDappTitleView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/26.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, JLDappTitleViewStyle) {
    /// 默认样式 滑动 显示全部
    JLDappTitleViewStyleScrollDefault,
    /// 滑动 不显示全部
    JLDappTitleViewStyleScrollNoMore,
    /// 不可滑动 显示全部
    JLDappTitleViewStyleNoScroll,
};
typedef void(^JLDappTitleViewDidSelectBlock)(NSInteger index);
typedef void(^JLDappTitleViewMoreBlock)(NSInteger index);

@interface JLDappTitleView : UIView

@property (nonatomic, copy) JLDappTitleViewDidSelectBlock didSelectBlock;
@property (nonatomic, copy) JLDappTitleViewMoreBlock moreBlock;

- (void)setTitleArray: (NSArray *)titleArray selectIndex: (NSInteger)selectIndex style: (JLDappTitleViewStyle)style;

@end

NS_ASSUME_NONNULL_END
