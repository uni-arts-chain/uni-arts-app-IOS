//
//  JLNormalEmptyView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/3/1.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLNormalEmptyView.h"

@interface JLNormalEmptyView()
@property (nonatomic, strong) UIImageView *topBgImgView;
@property (nonatomic, strong) UIImageView *typeImage;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation JLNormalEmptyView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    [self addSubview:self.topBgImgView];
    [self addSubview:self.typeImage];
    [self addSubview:self.nameLabel];
    
    [self.topBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.height.mas_equalTo(144);
    }];
    [self.typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(158.0f, 76.0f));
        make.bottom.equalTo(self).offset(-164);
        make.centerX.equalTo(self).offset(15);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(40.0f);
    }];
}

- (UIImageView *)topBgImgView {
    if (!_topBgImgView) {
        _topBgImgView = [[UIImageView alloc] init];
        _topBgImgView.hidden = YES;
        UIImage *image = [UIImage imageNamed:@"order_list_bg"];
        _topBgImgView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height / 2, image.size.width / 2, image.size.height / 2, image.size.width / 2) resizingMode:UIImageResizingModeStretch];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = JL_color_gray_EDEDEE;
        [_topBgImgView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topBgImgView).offset(106);
            make.left.equalTo(_topBgImgView).offset(12);
            make.right.equalTo(_topBgImgView).offset(-12);
            make.height.mas_equalTo(@1);
        }];
    }
    return _topBgImgView;
}

- (UIImageView *)typeImage {
    if (!_typeImage) {
        _typeImage = [UIImageView new];
        _typeImage.image = [UIImage imageNamed:@"empty_data_icon"];
    }
    return _typeImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"空空如也~";
        _nameLabel.textColor = JL_color_mainColor;
        _nameLabel.font = kFontPingFangSCRegular(14.0f);
        _nameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _nameLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.nameLabel.text = _title;
}

- (void)setIsMainColorBg:(BOOL)isMainColorBg {
    _isMainColorBg = isMainColorBg;
    
    
    if (_isMainColorBg) {
        self.nameLabel.textColor = JL_color_red_F99491;
        self.typeImage.image = [UIImage imageNamed:@"empty_data_icon_1"];
    }else {
        self.nameLabel.textColor = JL_color_mainColor;
        self.typeImage.image = [UIImage imageNamed:@"empty_data_icon"];
    }
}

- (void)setIsOrderEmpty:(BOOL)isOrderEmpty {
    _isOrderEmpty = isOrderEmpty;
    
    self.topBgImgView.hidden = !_isOrderEmpty;
    
    if (_isOrderEmpty) {
        self.nameLabel.textColor = JL_color_black_40414D;
        self.typeImage.image = [UIImage imageNamed:@"empty_data_icon_1"];
    }else {
        self.nameLabel.textColor = JL_color_mainColor;
        self.typeImage.image = [UIImage imageNamed:@"empty_data_icon"];
    }
}
@end
