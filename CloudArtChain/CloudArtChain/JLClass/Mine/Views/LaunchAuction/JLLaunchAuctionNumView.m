//
//  JLLaunchAuctionNumView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLLaunchAuctionNumView.h"
#import "JLStepper.h"

@interface JLLaunchAuctionNumView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) JLStepper *numStepper;

@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation JLLaunchAuctionNumView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.numStepper];
    [self addSubview:self.numLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(17);
        make.centerY.equalTo(self);
    }];
    [self.numStepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-17);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(@75);
        make.height.mas_equalTo(@17);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-17);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"拍卖份数";
        _titleLabel.textColor = JL_color_gray_101010;
        _titleLabel.font = kFontPingFangSCRegular(16);
    }
    return _titleLabel;
}

- (JLStepper *)numStepper {
    if (!_numStepper) {
        WS(weakSelf)
        _numStepper = [[JLStepper alloc] init];
        _numStepper.stepValue = 1;
        _numStepper.value = 1;
        _numStepper.minValue = 1;
        _numStepper.isValueEditable = YES;
        __weak typeof(_numStepper) weakNumStepper = _numStepper;
        _numStepper.valueChanged = ^(double value) {
            if (value == 0) {
                weakNumStepper.value = 1;
            }else {
                if (weakSelf.changeNumBlock) {
                    weakSelf.changeNumBlock(value);
                }
            }
        };
    }
    return _numStepper;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [JLUIFactory labelInitText:@"1" font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentRight];
        _numLabel.hidden = YES;
    }
    return _numLabel;
}

- (void)setIsShowStepper:(BOOL)isShowStepper {
    _isShowStepper = isShowStepper;
    
    self.numStepper.hidden = !_isShowStepper;
    self.numLabel.hidden = _isShowStepper;
}

- (void)setMaxNum:(NSInteger)maxNum {
    _maxNum = maxNum;
    
    self.numStepper.maxValue = _maxNum;
}

@end
