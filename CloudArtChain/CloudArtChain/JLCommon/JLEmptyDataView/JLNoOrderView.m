//
//  JLNoOrderView.m
//  Miner
//
//  Created by 花田半亩 on 2020/6/21.
//  Copyright © 2020 花田半亩. All rights reserved.
//

#import "JLNoOrderView.h"
@interface JLNoOrderView()
@property(nonatomic, strong) UIImageView *typeImage;
@property(nonatomic, strong) UILabel *nameLabel;
@end

@implementation JLNoOrderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createView];
    }
    return self;
}

- (void)createView {
    [self addSubview:self.typeImage];
    [self addSubview:self.nameLabel];
    [self.typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(135.0f, 125.0f));
        make.centerX.equalTo(self);
        make.top.mas_equalTo(85.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.typeImage.mas_bottom).offset(28.0f);
    }];
}

- (UIImageView *)typeImage {
    if (!_typeImage) {
        _typeImage = [UIImageView new];
        _typeImage.image = [UIImage imageNamed:@"icon_order_blank"];
    }
    return _typeImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"暂无历史订单～";
        _nameLabel.textColor = JL_color_gray_909090;
        _nameLabel.font = kFontPingFangSCRegular(16.0f);
        _nameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _nameLabel;
}

@end
