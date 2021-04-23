//
//  JLBoxCardView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/22.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBoxCardView.h"

@interface JLBoxCardView ()
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UILabel *cardNameLabel;
@end

@implementation JLBoxCardView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.cardImageView];
    [self addSubview:self.cardNameLabel];
    
    [self.cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(50.0f);
    }];
    [self.cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.right.mas_equalTo(-10.0f);
        make.top.equalTo(self);
        make.bottom.equalTo(self.cardNameLabel.mas_top);
    }];
}

- (UIImageView *)cardImageView {
    if (!_cardImageView) {
        _cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, self.frameWidth - 10.0f * 2, 250.0f)];
        _cardImageView.backgroundColor = [UIColor randomColor];
        [_cardImageView addShadow:[UIColor colorWithHexString:@"#404040"] cornerRadius:5.0f offsetX:0];
    }
    return _cardImageView;
}

- (UILabel *)cardNameLabel {
    if (!_cardNameLabel) {
        _cardNameLabel = [JLUIFactory labelInitText:@"哈利波特" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _cardNameLabel;
}

@end
