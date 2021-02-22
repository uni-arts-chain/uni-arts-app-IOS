//
//  JLRefreshFooter.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "MJRefreshAutoFooter.h"
#import <MJRefresh.h>
@interface JLRefreshFooter : MJRefreshBackFooter
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

/// 自定义提示的位置
@property (nonatomic, assign) CGFloat customOffset;

- (void)endWithNoMoreDataNotice;
@end
