//
//  JLMechanismIntroductionView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLMechanismIntroductionView.h"

@interface JLMechanismIntroductionView ()
@property (nonatomic, strong) Model_organizations_Data *organizationData;
@property (nonatomic, strong) UILabel *introductionLabel;
@end

@implementation JLMechanismIntroductionView
- (instancetype)initWithFrame:(CGRect)frame organizationData:(Model_organizations_Data *)organizationData {
    if (self = [super initWithFrame:frame]) {
        self.organizationData = organizationData;
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
        _introductionLabel.text = self.organizationData.desc;
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 12.0f;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_introductionLabel.text];
        [attr addAttributes:@{NSParagraphStyleAttributeName: paragraph} range:NSMakeRange(0, _introductionLabel.text.length)];
        _introductionLabel.attributedText = attr;
    }
    return _introductionLabel;
}
@end
