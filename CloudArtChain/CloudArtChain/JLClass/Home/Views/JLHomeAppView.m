//
//  JLHomeAppView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLHomeAppView.h"
#import "UIImage+JLTool.h"

@interface JLHomeAppView ()
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@end

@implementation JLHomeAppView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    CGFloat itemWidth = 70.0f;
    CGFloat itemHeight = self.frameHeight - 16.0f * 2;
    CGFloat horizonSep = (self.frameWidth - 25.0f * 2 - itemWidth * 3) / 2.0f;
    
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(25.0f + i * (itemWidth + horizonSep), 16.0f, itemWidth, itemHeight);
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
        button.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [button setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
        button.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleCenterImageTop;
        button.axcUI_padding = 6.0f;
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"证书查询", @"申请证书", @"积分钱包"];
    }
    return _titleArray;
}

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = @[@"icon_home_apply_cert", @"icon_home_cert_query", @"icon_home_points_wallet"];
    }
    return _imageArray;
}

- (void)buttonClick:(UIButton *)sender {
    if (self.selectAppBlock) {
        self.selectAppBlock(sender.tag - 1000);
    }
}
@end
