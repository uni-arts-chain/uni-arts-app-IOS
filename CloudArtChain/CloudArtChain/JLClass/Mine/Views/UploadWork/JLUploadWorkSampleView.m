//
//  JLUploadWorkSampleView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLUploadWorkSampleView.h"
#import "WMPhotoBrowser.h"

@interface JLUploadWorkSampleView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *imgBgView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) UILabel *flagLabel;

@property (nonatomic, strong) UIButton *firstImageButton;
@property (nonatomic, strong) UIButton *secondImageButton;
@property (nonatomic, strong) UIButton *thirdImageButton;

@property (nonatomic, strong) NSArray *tempImageArray;
@end

@implementation JLUploadWorkSampleView
- (instancetype)init {
    if (self = [super init]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.imgBgView];
    
    [self.imgBgView addSubview:self.firstImageView];
    [self.imgBgView addSubview:self.secondImageView];
    [self.imgBgView addSubview:self.thirdImageView];
    [self.imgBgView addSubview:self.flagLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13.0f);
        make.top.equalTo(self);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(48.0f);
    }];
    [self.imgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    
    [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0f);
        make.height.mas_equalTo(89.0f);
        make.top.equalTo(self.imgBgView).offset(20);
    }];
    [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstImageView.mas_right).offset(15.0f);
        make.top.equalTo(self.firstImageView);
        make.height.equalTo(self.firstImageView);
        make.bottom.equalTo(self.firstImageView);
        make.width.equalTo(self.firstImageView);
    }];
    [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondImageView.mas_right).offset(15.0f);
        make.top.equalTo(self.firstImageView);
        make.height.equalTo(self.firstImageView);
        make.bottom.equalTo(self.firstImageView);
        make.width.equalTo(self.firstImageView);
        make.right.mas_equalTo(-15.0f);
    }];
    [self.flagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self.imgBgView);
    }];
    
    [self.firstImageView addSubview:self.firstImageButton];
    [self.secondImageView addSubview:self.secondImageButton];
    [self.thirdImageView addSubview:self.thirdImageButton];
    
    [self.firstImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.firstImageView);
    }];
    [self.secondImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.secondImageView);
    }];
    [self.thirdImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.thirdImageView);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"基本信息" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_black_101220 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UIView *)imgBgView {
    if (!_imgBgView) {
        _imgBgView = [[UIView alloc] init];
        _imgBgView.backgroundColor = JL_color_white_ffffff;
    }
    return _imgBgView;
}

- (UIImageView *)firstImageView {
    if (!_firstImageView) {
        _firstImageView = [[UIImageView alloc] init];
        _firstImageView.image = [UIImage imageNamed:@"icon_mine_upload_eg1"];
        _firstImageView.userInteractionEnabled = YES;
        ViewBorderRadius(_firstImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _firstImageView;
}

- (UIImageView *)secondImageView {
    if (!_secondImageView) {
        _secondImageView = [[UIImageView alloc] init];
        _secondImageView.image = [UIImage imageNamed:@"icon_mine_upload_eg2"];
        _secondImageView.userInteractionEnabled = YES;
        ViewBorderRadius(_secondImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _secondImageView;
}

- (UIImageView *)thirdImageView {
    if (!_thirdImageView) {
        _thirdImageView = [[UIImageView alloc] init];
        _thirdImageView.image = [UIImage imageNamed:@"icon_mine_upload_eg3"];
        _thirdImageView.userInteractionEnabled = YES;
        ViewBorderRadius(_thirdImageView, 5.0f, 0.0f, JL_color_clear);
    }
    return _thirdImageView;
}

- (UILabel *)flagLabel {
    if (!_flagLabel) {
        _flagLabel = [[UILabel alloc] init];
        _flagLabel.text = @"(示例)";
        _flagLabel.textColor = JL_color_gray_87888F;
        _flagLabel.font = kFontPingFangSCMedium(12);
        _flagLabel.textAlignment = NSTextAlignmentRight;
    }
    return _flagLabel;
}

- (UIButton *)firstImageButton {
    if (!_firstImageButton) {
        _firstImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_firstImageButton addTarget:self action:@selector(firstImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstImageButton;
}

- (void)firstImageButtonClick {
    [self showImageWithIndex:0];
}

- (UIButton *)secondImageButton {
    if (!_secondImageButton) {
        _secondImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_secondImageButton addTarget:self action:@selector(secondImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondImageButton;
}

- (void)secondImageButtonClick {
    [self showImageWithIndex:1];
}

- (UIButton *)thirdImageButton {
    if (!_thirdImageButton) {
        _thirdImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_thirdImageButton addTarget:self action:@selector(thirdImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thirdImageButton;
}

- (void)thirdImageButtonClick {
    [self showImageWithIndex:2];
}

- (void)showImageWithIndex:(NSInteger)index {
    //图片查看
    WMPhotoBrowser *browser = [WMPhotoBrowser new];
    //数据源
    browser.dataSource = [self.tempImageArray mutableCopy];
    browser.downLoadNeeded = YES;
    browser.currentPhotoIndex = index;
    browser.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[JLTool currentViewController] presentViewController:browser animated:YES completion:nil];
}

- (NSArray *)tempImageArray {
    if (!_tempImageArray) {
        _tempImageArray = @[self.firstImageView.image, self.secondImageView.image, self.thirdImageView.image];
    }
    return _tempImageArray;
}

@end
