//
//  JLCustomTipControl.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCustomTipControl.h"

@implementation JLCustomTipControl

- (instancetype)initWithFrame:(CGRect)frame tipIcon:(NSString *)icon tipMessage:(NSString *)tipMessage hideTime:(NSTimeInterval)hideTime position:(TipControlPosition)position hidedBlock:(void (^)(void))hidedBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_clear;
        [self initSubViewsWithTipMessage:tipMessage tipIcon:icon hideTime:hideTime position:position hidedBlock:hidedBlock];
    }
    return self;
}

/**
 初始化子视图
 */
- (void)initSubViewsWithTipMessage:(NSString *)tipMessage tipIcon:(NSString *)icon hideTime:(NSTimeInterval)hideTime position:(TipControlPosition)position hidedBlock:(void (^)(void))hidedBlock{
    //计算视图的宽度
    CGFloat labelWidth = [self labelWidthWithString:tipMessage andFont:kFontPingFangSCMedium(18)];
    //4-阴影半径 16-左右边距 18-图片宽高 12-图片文字间隔 38-视图高度
    CGFloat shadowRadius = 4;
    CGFloat horizonSpace = 16;
    CGFloat imageViewWidthHeight = 18;
    CGFloat imageTextSep = 12;
    CGFloat viewHeight = 38;
    CGFloat viewWidth = shadowRadius * 2 + horizonSpace * 2 + imageViewWidthHeight + imageTextSep + labelWidth;
    if (viewWidth > self.frame.size.width) {
        viewWidth = self.frame.size.width;
    }
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    tipView.backgroundColor = JL_color_white_ffffff;
    tipView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.14].CGColor;
    tipView.layer.shadowOffset = CGSizeMake(0,3);
    tipView.layer.shadowOpacity = 1;
    tipView.layer.shadowRadius = shadowRadius;
    tipView.layer.cornerRadius = 5;
    [self addSubview:tipView];
    if (position == TipControlPositionBottom) {
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-(KTouch_Responder_Height + 138.f));
            make.centerX.equalTo(self);
            make.width.mas_equalTo(viewWidth);
            make.height.mas_equalTo(viewHeight);
        }];
    } else {
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(viewWidth);
            make.height.mas_equalTo(viewHeight);
        }];
    }
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0f, (viewHeight - imageViewWidthHeight) * 0.5f, imageViewWidthHeight, imageViewWidthHeight)];
    imageView.image = [UIImage imageNamed:icon];
    [tipView addSubview:imageView];
    
    //文字
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + imageTextSep, 0, tipView.frame.size.width - CGRectGetMaxX(imageView.frame) - imageTextSep - horizonSpace, tipView.frame.size.height)];
    tipLabel.font = kFontPingFangSCMedium(18);
    tipLabel.textColor = [UIColor colorWithHexString:@"393939"];
    tipLabel.text = tipMessage;
    [tipView addSubview:tipLabel];

    if (hideTime > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hideTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
            if (hidedBlock) {
                hidedBlock();
            }
        });
    }
}

//计算label的宽度  也可以生成一个label返回
- (CGFloat)labelWidthWithString:(NSString *)str andFont:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = font;
    CGRect rect = [label textRectForBounds:CGRectMake(0, 0, MAXFLOAT, 20) limitedToNumberOfLines:1];
    return rect.size.width;
}
@end
