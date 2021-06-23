//
//  JLMineContentMiddleView.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMineContentMiddleView.h"

@interface JLMineContentMiddleView ()

@property (nonatomic, copy) NSArray *titleArray;

@property (nonatomic, copy) NSArray *imageArray;

@end

@implementation JLMineContentMiddleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_white_ffffff;
        self.layer.shadowColor = JL_color_gray_ECECEC.CGColor;
        self.layer.shadowOffset = CGSizeMake(0,3);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 1;
        self.layer.cornerRadius = 10;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    CGFloat itemW = (kScreenWidth - 24) / 4;
    for (int i = 0; i < self.titleArray.count; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.tag = 100 + i;
        itemView.userInteractionEnabled = YES;
        [itemView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewDidTap:)]];
        [self addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(i * itemW);
            make.width.mas_equalTo(@(itemW));
        }];
        
        UIView *itemBgView = [[UIView alloc] init];
        [itemView addSubview:itemBgView];
        [itemBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(itemView);
            make.left.right.equalTo(itemView);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:self.imageArray[i]];
        [itemBgView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemBgView);
            make.centerX.equalTo(itemBgView);
            make.width.height.mas_equalTo(@40);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = self.titleArray[i];
        titleLabel.textColor = JL_color_black_101220;
        titleLabel.font = kFontPingFangSCRegular(14);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [itemBgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(itemBgView);
            make.top.equalTo(imgView.mas_bottom).offset(2);
            make.bottom.equalTo(itemBgView);
        }];
    }
}

#pragma mark - event response
- (void)itemViewDidTap: (UITapGestureRecognizer *)ges {
    if (_selectItemBlock) {
        _selectItemBlock(ges.view.tag - 100);
    }
}

#pragma mark - setters and getters
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"买入订单",@"卖出订单",@"消息",@"客服"];
    }
    return _titleArray;
}

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = @[@"icon_mine_app_order_buy",
                        @"icon_mine_app_order_sell",
                        @"icon_mine_app_message"
                        ,@"icon_mine_app_customer_service"];
    }
    return _imageArray;
}

@end
