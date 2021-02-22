//
//  JLMineOrderView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLMineOrderView.h"
#import "UIButton+AxcButtonContentLayout.h"

@interface JLMineOrderView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UIButton *pointRightsBtn;
@end

@implementation JLMineOrderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.imageView];
    [self.imageView addSubview:self.pointLabel];
    [self.imageView addSubview:self.pointRightsBtn];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.bottom.equalTo(self);
    }];
    [self.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(19.0f);
        make.bottom.mas_equalTo(-29.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.pointRightsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-29.0f - 15.0f);
        make.centerY.equalTo(self.pointLabel.mas_centerY);
    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [JLUIFactory imageViewInitImageName:@"icon_mine_point"];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UILabel *)pointLabel {
    if (!_pointLabel) {
        _pointLabel = [JLUIFactory labelInitText:@"我的积分：0" font:kFontPingFangSCRegular(15.0f) textColor:JL_color_white_ffffff textAlignment:NSTextAlignmentLeft];
    }
    return _pointLabel;
}

- (UIButton *)pointRightsBtn {
    if (!_pointRightsBtn) {
        _pointRightsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pointRightsBtn setTitle:@"积分权益" forState:UIControlStateNormal];
        [_pointRightsBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _pointRightsBtn.titleLabel.font = kFontPingFangSCRegular(15.0f);
        [_pointRightsBtn setImage:[UIImage imageNamed:@"icon_mine_point_desc"] forState:UIControlStateNormal];
        _pointRightsBtn.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleCenterImageRight;
        _pointRightsBtn.axcUI_padding = 15.0f;
    }
    return _pointRightsBtn;
}

- (void)pointRightsBtnClick {
    
}

- (void)setCurrentAccountBalance:(NSString *)amount {
    self.pointLabel.text = [NSString stringWithFormat:@"我的积分：%@", amount];
}

@end
