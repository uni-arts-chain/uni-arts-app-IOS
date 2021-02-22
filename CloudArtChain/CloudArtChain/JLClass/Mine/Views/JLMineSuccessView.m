//
//  JLMineSuccessView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLMineSuccessView.h"

@interface JLMineSuccessView()
@property (nonatomic, strong) UIImageView *successImage;
@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) UIButton *successButton;
@end

@implementation JLMineSuccessView
- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createView];
    }
    return self;
}

- (void)createView {
    [self addSubview:self.successImage];
    [self addSubview:self.successLabel];
    [self addSubview:self.successButton];
    [self.successImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KwidthScale(68.0f));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(144.0f);
        make.height.mas_equalTo(129.0f);
    }];
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.successImage.mas_bottom);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(44.0f);
    }];
    [self.successButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.successLabel.mas_bottom);
        make.width.mas_equalTo(264.0f);
        make.height.mas_equalTo(46.0f);
        make.centerX.equalTo(self);
    }];
}

- (UIImageView*)successImage {
    if (!_successImage) {
        _successImage = [[UIImageView alloc] init];
        _successImage.image = [UIImage imageNamed:@"icon_mine_realname_successed"];
    }
    return _successImage;
}

- (UILabel *)successLabel{
    if (!_successLabel) {
        _successLabel = [[UILabel alloc] init];
        _successLabel.textColor = JL_color_gray_101010;
        _successLabel.font = kFontPingFangSCRegular(16.0f);
        _successLabel.numberOfLines = 0;
        _successLabel.textAlignment = NSTextAlignmentCenter;
        _successLabel.text = @" ";
    }
    return _successLabel;
}

- (UIButton*)successButton {
    if (!_successButton) {
        _successButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_successButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        _successButton.titleLabel.font = kFontPingFangSCRegular(17.0f);
        [_successButton setTitle:@"返回" forState:UIControlStateNormal];
        _successButton.layer.cornerRadius = 23.0f;
        _successButton.layer.masksToBounds = YES;
        _successButton.backgroundColor = JL_color_blue_50C3FF;
        [_successButton addTarget:self action:@selector(successButonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _successButton;
}

- (void)successButonAction:(UIButton*)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(successViewBackAction)]) {
        [self.delegate successViewBackAction];
    }
}

- (void)setSuccedText:(NSString *)succedText {
    _succedText = succedText;
    self.successLabel.text = succedText;
}
@end
