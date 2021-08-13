//
//  UILabel+JLExtension.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/12.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (JLExtension)

/// 修改label内容距 `top` `left` `bottom` `right` 边距
@property (nonatomic, assign) UIEdgeInsets jl_contentInsets;

@end

NS_ASSUME_NONNULL_END
