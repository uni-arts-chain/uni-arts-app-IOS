//
//  JLMineAppView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLMineAppView.h"
#import "UIImage+JLTool.h"
#import "UIButton+AxcButtonContentLayout.h"

@interface JLMineAppView ()
@property (nonatomic, strong) NSArray *appImageArray;
@property (nonatomic, strong) NSArray *appTitleArray;
@end

@implementation JLMineAppView

- (NSArray *)appImageArray {
    if (!_appImageArray) {
//        @[@"icon_mine_app_order_buy", @"icon_mine_app_order_sell", @"icon_mine_app_message", @"icon_mine_app_customer_service", @"icon_mine_app_homepage", @"icon_mine_app_collect", @"icon_mine_app_work_upload", @"icon_mine_app_address", @"icon_mine_app_auction", @"icon_mine_app_feedback", @"icon_mine_app_aboutus", @"", @""]
        _appImageArray = @[@"icon_mine_app_homepage",
                           @"icon_mine_app_work_upload",
                           @"icon_mine_app_order_buy",
                           @"icon_mine_app_order_sell",
                           @"icon_mine_app_customer_service",
                           @"icon_mine_app_collect",
                           @"icon_mine_app_exchange",
                           @"icon_mine_app_message"];
    }
    return _appImageArray;
}

- (NSArray *)appTitleArray {
    if (!_appTitleArray) {
        _appTitleArray = @[@"我的主页",
                           @"上传作品",
                           @"买入订单",
                           @"卖出订单",
                           @"拍卖纪录",
                           @"作品收藏",
                           @"兑换NFT",
                           @"消息"];
    }
    return _appTitleArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    NSInteger row = self.appImageArray.count / 4;
    CGFloat lineSep = 0.0f;
    CGFloat itemWidth = (kScreenWidth - 15.0f * 2) / 4.0f;
    CGFloat itemHeight = (self.frameHeight - (row - 1) *lineSep) / row;
    for (int i = 0; i < self.appImageArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((i % 4) * itemWidth + 15.0f, (i / 4) * (itemHeight + lineSep), itemWidth, itemHeight);
        if (![NSString stringIsEmpty:self.appImageArray[i]]) {
            [button setTitle:self.appTitleArray[i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:self.appImageArray[i]] forState:UIControlStateNormal];
            [button setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
            button.titleLabel.font = kFontPingFangSCRegular(13.0f);
            button.tag = 2000 + i;
            button.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleCenterImageTop;
            button.axcUI_padding = 12.0f;
            [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:button];
        
        UILabel *badgeLabel = [[UILabel alloc] init];
        badgeLabel.backgroundColor = JL_color_red_D70000;
        badgeLabel.hidden = YES;
        badgeLabel.tag = 3000 + i;
        badgeLabel.text = @"";
        badgeLabel.textColor = JL_color_white_ffffff;
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.font = kFontPingFangSCSCSemibold(7);
        badgeLabel.layer.cornerRadius = 5;
        badgeLabel.layer.masksToBounds = YES;
        [self addSubview:badgeLabel];
        [badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button).offset(15);
            make.right.equalTo(button.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(26, 10));
        }];
    }
}

- (void)itemClick:(UIButton *)sender {
    if (self.appClickBlock) {
        self.appClickBlock(sender.tag - 2000);
    }
}

- (void)setIsWinAuction:(BOOL)isWinAuction {
    _isWinAuction = isWinAuction;
    
    if (_isWinAuction) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag >= 3000 && obj.tag - 3000 == 4) {
                obj.hidden = NO;
                ((UILabel *)obj).text = @"已中标";
            }
        }];
    }
}
@end
