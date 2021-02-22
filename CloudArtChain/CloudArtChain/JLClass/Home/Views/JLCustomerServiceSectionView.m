//
//  JLCustomerServiceSectionView.m
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/6.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLCustomerServiceSectionView.h"

@interface JLCustomerServiceSectionView ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lastView;
@end

@implementation JLCustomerServiceSectionView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title items:(NSArray *)itemsArray {
    if (self = [super initWithFrame:frame]) {
        self.title = title;
        self.itemsArray = itemsArray;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.height.mas_equalTo(15.0f);
    }];
    
    CGFloat itemHeight = 18.0f;
    CGFloat itemSep = 12.0f;
    for (int i = 0; i < self.itemsArray.count; i++) {
        UIView *itemView = [self itemViewWith:self.itemsArray[i] index:i];
        [self addSubview:itemView];
        if (self.lastView == nil) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(itemSep);
                make.left.right.equalTo(self);
                make.height.mas_equalTo(itemHeight);
            }];
        } else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lastView.mas_bottom).offset(itemSep);
                make.left.right.equalTo(self);
                make.height.mas_equalTo(itemHeight);
            }];
        }
        self.lastView = itemView;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:self.title font:kFontPingFangSCMedium(15.0f) textColor:JL_color_black textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UIView *)itemViewWith:(NSString *)item index:(NSInteger)index {
    UIView *itemView = [[UIView alloc] init];
    
    UILabel *itemLabel = [JLUIFactory labelInitText:item font:kFontPingFangSCRegular(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    [itemView addSubview:itemLabel];
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    copyButton.backgroundColor = JL_color_blue_50C3FF;
    copyButton.titleLabel.font = kFontPingFangSCRegular(14.0f);
    [copyButton addTarget:self action:@selector(copyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    copyButton.tag = 2000 + index;
    ViewBorderRadius(copyButton, 2.0f, 0.0f, JL_color_clear);
    [itemView addSubview:copyButton];
    
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(itemView);
    }];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(itemLabel.mas_right).offset(25.0f);
        make.top.bottom.equalTo(itemView);
        make.width.mas_equalTo(37.0f);
    }];
    return itemView;
}

- (void)copyButtonClick:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = self.itemsArray[sender.tag - 2000];
    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"复制成功" hideTime:KToastDismissDelayTimeInterval];
}
@end
