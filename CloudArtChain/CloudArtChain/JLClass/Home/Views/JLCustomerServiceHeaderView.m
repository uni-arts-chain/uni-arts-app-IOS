//
//  JLCustomerServiceHeaderView.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLCustomerServiceHeaderView.h"

@interface JLCustomerServiceHeaderView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) MASConstraint *imgViewSizeConstraint;

@end

@implementation JLCustomerServiceHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = JL_color_white_ffffff;
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
    }];
    
    _imgView = [[UIImageView alloc] init];
    [_bgView addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(18);
        make.centerY.equalTo(self.bgView);
        self.imgViewSizeConstraint = make.size.mas_equalTo(CGSizeMake(21, 17));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = JL_color_black_101220;
    _titleLabel.font = kFontPingFangSCSCSemibold(15);
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(9);
        make.centerY.equalTo(self.imgView);
    }];
    
    [_bgView layoutIfNeeded];
    [_bgView setCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:CGSizeMake(8, 8)];
}

#pragma mark - setters and getters
- (void)setTitle:(NSString *)title {
    _title = title;
    
    _titleLabel.text = _title;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    _imgView.image = [UIImage imageNamed:_imageName];
}

- (void)setSection:(NSInteger)section {
    _section = section;
    
    CGSize size = CGSizeMake(21, 17);
    if (_section == 1) {
        size = CGSizeMake(16, 18);
    }else if (_section == 2) {
        size = CGSizeMake(20, 21);
    }
    
    [_imgViewSizeConstraint uninstall];
    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.imgViewSizeConstraint = make.size.mas_equalTo(size);
    }];
}

- (void)setRectCorner:(UIRectCorner)rectCorner {
    _rectCorner = rectCorner;
    
    [_bgView layoutIfNeeded];
    [_bgView setCorners:_rectCorner radius:CGSizeMake(8, 8)];
}

@end
