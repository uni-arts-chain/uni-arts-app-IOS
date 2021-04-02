//
//  JLChainQueryTradeView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/2.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLChainQueryTradeView.h"

@implementation JLChainQueryTradeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    UIView *titleView = [self itemWithFrame:CGRectMake(0.0f, 0.0f, self.frameWidth, 45.0f) items:@[@"从", @"到", @"成交价", @"时间"] color:JL_color_gray_101010 backColor:JL_color_blue_7ed4ff font:kFontPingFangSCRegular(15.0f)];
    [self addSubview:titleView];
    
    UIView *firstView = [self itemWithFrame:CGRectMake(0.0f, titleView.frameBottom, self.frameWidth, 38.0f) items:@[@"张**", @"张**", @"900 UART", @"900 UART"] color:JL_color_gray_606060 backColor:JL_color_blue_CFEFFF font:kFontPingFangSCRegular(14.0f)];
    [self addSubview:firstView];
    
    UIView *secondView = [self itemWithFrame:CGRectMake(0.0f, firstView.frameBottom, self.frameWidth, 38.0f) items:@[@"张**", @"张**", @"900 UART", @"900 UART"] color:JL_color_gray_606060 backColor:JL_color_white_ffffff font:kFontPingFangSCRegular(14.0f)];
    [self addSubview:secondView];
    
    UIView *thirdView = [self itemWithFrame:CGRectMake(0.0f, secondView.frameBottom, self.frameWidth, 38.0f) items:@[@"张**", @"张**", @"900 UART", @"900 UART"] color:JL_color_gray_606060 backColor:JL_color_blue_CFEFFF font:kFontPingFangSCRegular(14.0f)];
    [self addSubview:thirdView];
}

- (UIView *)itemWithFrame:(CGRect)frame items:(NSArray *)items color:(UIColor *)textColor backColor:(UIColor *)backColor font:(UIFont *)textFont {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = backColor;
    
    CGFloat smallWidth = (view.frameWidth * 0.6f) / (items.count - 1);
    CGFloat largeWidth = view.frameWidth * 0.4f;
    
    CGFloat currentX = 0;
    for (int i = 0; i < items.count; i++) {
        UILabel *label = [JLUIFactory labelInitText:items[i] font:textFont textColor:textColor textAlignment:NSTextAlignmentCenter];
        label.frame = CGRectMake(currentX, 0, (i == items.count - 1 ? largeWidth : smallWidth), view.frameHeight);
        [view addSubview:label];
        currentX += label.frameWidth;
    }
    return view;
}
@end
