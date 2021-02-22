//
//  JLEmptyDataView.m
//  Miner
//
//  Created by 花田半亩 on 2020/6/21.
//  Copyright © 2020 花田半亩. All rights reserved.
//

#import "JLEmptyDataView.h"

@interface JLEmptyDataView()
@property(nonatomic,strong)UIButton * imageButton;
@property(nonatomic,strong)UILabel  * titleLabel;
@end

@implementation JLEmptyDataView
- (id)init {
    self = [super init];
    if (self) {
        [self  createView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self  createView];
    }
    return self;
}

- (void)createView {
    WS(weakSelf)
    UIView * contentView = [[UIView alloc] init];
    [contentView addSubview:self.imageButton];
    [contentView addSubview:self.titleLabel];
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.frameHeight <= 176.0f + 64.0f + 24.0f + 18.0f) {
            make.centerY.equalTo(self);
        } else {
            make.top.mas_equalTo(weakSelf).offset(KwidthScale(176.0f));
        }
        make.centerX.mas_equalTo(weakSelf);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.equalTo(contentView);
        make.width.mas_equalTo(71.5f);
        make.height.mas_equalTo(64.0f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageButton.mas_bottom).offset(24.0f);
        make.left.right.mas_equalTo(contentView);
        make.height.mas_equalTo(18.0f);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - 懒加载
- (UIButton *)imageButton {
    if (!_imageButton) {
         _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
         [_imageButton setImage:[UIImage imageNamed:@"icon_order_blank"] forState:UIControlStateNormal];
    }
    return _imageButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
         _titleLabel = [[UILabel alloc] init];
         _titleLabel.text = @"暂无内容";
         _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font =  kFontPingFangSCRegular(18.0f);
         _titleLabel.textColor = JL_color_gray_333333;
    }
    return _titleLabel;
}
@end
