//
//  JLPageEmptyView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/16.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLPageEmptyView : UIView
/**
 图片名称
 */
@property (nonatomic , copy) NSString * imageName;
/**
 默认图片大小显示居中
 */
@property (nonatomic , assign) CGSize  imageSize;

/**
 提示文字
 */
@property (nonatomic , copy) NSString * hintText;

/**
 提示文字字体
 */
@property (nonatomic , strong) UIFont * hintTextFont;

/**
 提示文字颜色
 */
@property (nonatomic , strong) UIColor * hintTextColor;

/**
 提示文字富文本
 */
@property (nonatomic , strong) NSAttributedString * hintAttributedText;
@end

NS_ASSUME_NONNULL_END
