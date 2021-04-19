//
//  JLArtEvaluateView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/2.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLArtEvaluateView.h"

@interface JLArtEvaluateView ()
@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;
@property (nonatomic, strong) UILabel *evaluateLabel;
@end

@implementation JLArtEvaluateView
- (instancetype)initWithFrame:(CGRect)frame artDetailData:(Model_art_Detail_Data *)artDetailData; {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        self.artDetailData = artDetailData;
        [self createSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    frame.size.height = self.evaluateLabel.frameBottom;
    self.frame = frame;
}

- (void)createSubViews {
    UIView *titleView = [JLUIFactory titleViewWithTitle:@"作品信息"];
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(65.0f);
    }];
    [self addSubview:self.evaluateLabel];
    [self.evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(titleView.mas_bottom);
    }];
}

- (UILabel *)evaluateLabel {
    if (!_evaluateLabel) {
        _evaluateLabel = [[UILabel alloc] init];
        _evaluateLabel.font = kFontPingFangSCRegular(14.0f);
        _evaluateLabel.textColor = JL_color_gray_101010;
        _evaluateLabel.numberOfLines = 0;
        _evaluateLabel.text = self.artDetailData.details;
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 12.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_evaluateLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _evaluateLabel.text.length)];
        _evaluateLabel.attributedText = attr;
    }
    return _evaluateLabel;
}

- (CGFloat)getFrameBottom {
    [self layoutIfNeeded];
    return self.frameY + self.frameHeight;
}

@end
