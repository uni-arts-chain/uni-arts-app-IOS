//
//  JLNormalEmptyView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/3/1.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLNormalEmptyView.h"

@interface JLNormalEmptyView()
@property (nonatomic, strong) UIImageView *typeImage;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation JLNormalEmptyView
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
        make.size.mas_equalTo(CGSizeMake(154.0f, 148.0f));
        make.centerX.equalTo(self);
        make.top.mas_equalTo(49.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.typeImage.mas_bottom).offset(15.0f);
    }];
}

- (UIImageView *)typeImage {
    if (!_typeImage) {
        _typeImage = [UIImageView new];
        _typeImage.image = [UIImage imageNamed:@"icon_address_blank"];
    }
    return _typeImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"空空如也~";
        _nameLabel.textColor = JL_color_gray_909090;
        _nameLabel.font = kFontPingFangSCRegular(16.0f);
        _nameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _nameLabel;
}
@end
