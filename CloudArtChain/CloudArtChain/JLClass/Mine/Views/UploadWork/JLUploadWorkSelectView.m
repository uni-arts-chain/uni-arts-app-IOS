//
//  JLUploadWorkSelectView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/18.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLUploadWorkSelectView.h"

@interface JLUploadWorkSelectView ()
@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) NSString *inputTitle;
@property (nonatomic,   copy) void(^selectBlock)(void);

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowRigntImageView;
@end

@implementation JLUploadWorkSelectView
- (instancetype)initWithPlaceHolder:(NSString *)placeHolder selectBlock:(void(^)(void))selectBlock {
    if (self = [super init]) {
        self.placeHolder = placeHolder;
        self.selectBlock = selectBlock;
        [self createSubViews];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title selectBlock:(void (^)(void))selectBlock {
    if (self = [super init]) {
        self.inputTitle = title;
        self.selectBlock = selectBlock;
        [self createSubviewsWithTitle];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.contentLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.lineView];
    [self addSubview:self.selectBtn];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.bottom.equalTo(self);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24.0f);
        make.width.mas_equalTo(15.0f);
        make.height.mas_equalTo(8.0f);
        make.centerY.equalTo(self);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1.0f);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)createSubviewsWithTitle {
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.arrowRigntImageView];
    [self addSubview:self.selectBtn];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel.text = @"请选择";
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.bottom.equalTo(self);
    }];
    [self.arrowRigntImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.0f);
        make.width.mas_equalTo(8.0f);
        make.height.mas_equalTo(14.0f);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowRigntImageView.mas_left).offset(-8.0f);
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(15.0f);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [JLUIFactory labelInitText:[NSString stringIsEmpty:self.placeHolder] ? @"" : self.placeHolder font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentLeft];
    }
    return _contentLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [JLUIFactory imageViewInitImageName:@"icon_mine_upload_select_arrowdown"];
    }
    return _arrowImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (void)selectBtnClick {
    if (self.selectBlock) {
        self.selectBlock();
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:[NSString stringIsEmpty:self.inputTitle] ? @"" : self.inputTitle font:kFontPingFangSCRegular(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UIImageView *)arrowRigntImageView {
    if (!_arrowRigntImageView) {
        _arrowRigntImageView = [JLUIFactory imageViewInitImageName:@"icon_mine_upload_arrowright"];
    }
    return _arrowRigntImageView;
}

- (void)setSelectContent:(NSString *)content {
    if ([NSString stringIsEmpty:content]) {
        self.contentLabel.text = self.placeHolder;
        self.contentLabel.textColor = JL_color_gray_909090;
    } else {
        self.contentLabel.text = content;
        self.contentLabel.textColor = JL_color_gray_101010;
    }
}
@end
