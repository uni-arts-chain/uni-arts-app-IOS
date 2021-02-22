//
//  JLGuidePageView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGuideManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLGuidePageView : UIView
/**
 *  选中page的指示器颜色，默认白色
 */
@property (nonatomic, strong) UIColor *currentColor;

/**
 *  其他状态下的指示器的颜色，默认
 */
@property (nonatomic, strong) UIColor *nomalColor;

/**
 *  不带按钮的引导页，滑动到最后一页，再向右滑直接隐藏引导页
 *
 *  @param imageNames 背景图片数组
 *
 *  @return   LaunchIntroductionView对象
 */
+ (instancetype)sharedWithImages:(NSArray *) imageNames;

/**
 *  带按钮的引导页
 *
 *  @param imageNames      背景图片数组
 *  @param buttonImageName 按钮的图片
 *  @param frame           按钮的frame
 *
 *  @return LaunchIntroductionView对象
 */
+ (instancetype)sharedWithImages:(NSArray *)imageNames
                     buttonImage:(NSString *)buttonImageName
                     buttonFrame:(CGRect )frame;

+ (void)showGuidePage;

+ (BOOL)isGuideViewShow;
@end

NS_ASSUME_NONNULL_END
