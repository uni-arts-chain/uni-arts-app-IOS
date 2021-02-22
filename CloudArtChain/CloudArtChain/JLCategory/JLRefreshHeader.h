//
//  JLRefreshHeader.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "MJRefreshStateHeader.h"

@interface JLRefreshHeader : MJRefreshStateHeader
@property (weak, nonatomic, readonly) UIImageView *arrowView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

- (void)endRefreshingWithNotice:(NSString *)notice;
+ (CGFloat)mj_textWidth:(UILabel *)label;
@end
