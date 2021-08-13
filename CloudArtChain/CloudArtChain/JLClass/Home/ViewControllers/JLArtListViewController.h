//
//  JLArtListViewController.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/13.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLArtListViewController : JLBaseViewController

@property (nonatomic, assign) JLArtListType type;
/// 是否需要上下拉刷新
@property (nonatomic, assign) BOOL isNeedRefresh;
/// 滑动视图距离上边距
@property (nonatomic, assign) CGFloat topInset;

@end

NS_ASSUME_NONNULL_END
