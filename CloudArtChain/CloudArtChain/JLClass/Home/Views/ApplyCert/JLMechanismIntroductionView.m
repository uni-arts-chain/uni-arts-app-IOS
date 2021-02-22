//
//  JLMechanismIntroductionView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLMechanismIntroductionView.h"

@interface JLMechanismIntroductionView ()
@property (nonatomic, strong) UILabel *introductionLabel;
@end

@implementation JLMechanismIntroductionView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    frame.size.height = self.introductionLabel.frameBottom;
    self.frame = frame;
}

- (void)createSubViews {
    UIView *titleView = [JLUIFactory titleViewWithTitle:@"机构简介"];
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(65.0f);
    }];
    [self addSubview:self.introductionLabel];
    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(titleView.mas_bottom);
    }];
}

- (UILabel *)introductionLabel {
    if (!_introductionLabel) {
        _introductionLabel = [[UILabel alloc] init];
        _introductionLabel.font = kFontPingFangSCRegular(14.0f);
        _introductionLabel.textColor = JL_color_gray_212121;
        _introductionLabel.numberOfLines = 0;
        _introductionLabel.text = @"中国艺术品评估鉴定中心是国内最具权威的艺术品市场定价评审机构之一，其书画润格评估委员会集聚了一批权威书画家、收藏家、评论家，根据申请人所提供的书画作品的艺术水准、市场综合信息和收藏界评价，对申请的书画作品做出收藏润格认定标准。";
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 12.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_introductionLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _introductionLabel.text.length)];
        _introductionLabel.attributedText = attr;
    }
    return _introductionLabel;
}
@end
