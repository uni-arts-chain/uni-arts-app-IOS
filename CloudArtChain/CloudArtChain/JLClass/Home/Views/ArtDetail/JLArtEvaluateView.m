//
//  JLArtEvaluateView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/2.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLArtEvaluateView.h"

@interface JLArtEvaluateView ()
@property (nonatomic, strong) UILabel *evaluateLabel;
@end

@implementation JLArtEvaluateView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
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
    UIView *titleView = [JLUIFactory titleViewWithTitle:@"艺术评析"];
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
        _evaluateLabel.text = @"创作者张大中在作品《水墨》系列中以“梅花”作为自己某种观念或隐喻的象征，山林中的梅花不再有寒冷的感觉，红热的梅花体现出了烈焰灼烧的意味，这也代表了创作者心中某种热烈的情感需要爆发。生活只有遵循内心的想法才会精彩，真实从心的想法才会是第一顺位。";
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
