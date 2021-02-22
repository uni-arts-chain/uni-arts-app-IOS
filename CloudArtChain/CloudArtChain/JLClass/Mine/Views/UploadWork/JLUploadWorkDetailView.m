//
//  JLUploadWorkDetailView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/18.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLUploadWorkDetailView.h"
#import "JLUploadWorkDescriptionView.h"

@interface JLUploadWorkDetailView ()
@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UIView *showImageView;
@property (nonatomic, strong) JLUploadWorkDescriptionView *descView;
@end

@implementation JLUploadWorkDetailView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.addView];
    [self addSubview:self.showImageView];
    [self addSubview:self.descView];
    
    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(6.0f);
        make.width.mas_equalTo(103.0f);
        make.height.mas_equalTo(87.0f);
    }];
    [self.showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.equalTo(self);
        make.width.mas_equalTo(110.0f);
        make.height.mas_equalTo(93.0f);
    }];
    [self.descView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addView.mas_right).offset(17.0f);
        make.top.equalTo(self.addView);
        make.right.mas_equalTo(-15.0f);
        make.bottom.equalTo(self);
    }];
}

- (UIView *)addView {
    if (!_addView) {
        _addView = [self uploadImageView];
        _addView.hidden = NO;
    }
    return _addView;
}

- (UIView *)showImageView {
    if (!_showImageView) {
        _showImageView = [self itemView];
        _showImageView.hidden = YES;
    }
    return _showImageView;
}

- (JLUploadWorkDescriptionView *)descView {
    if (!_descView) {
        _descView = [[JLUploadWorkDescriptionView alloc] initWithMax:200 placeholder:@"请对细节进行剖析..." placeHolderColor:nil textFont:nil textColor:nil];
    }
    return _descView;
}

- (UIView *)uploadImageView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = JL_color_gray_EBEBEB;
    ViewBorderRadius(view, 5.0f, 0.0f, JL_color_clear);
    
    UIView *centerView = [[UIView alloc] init];
    [view addSubview:centerView];
    
    UIImageView *addImageView = [JLUIFactory imageViewInitImageName:@"icon_mine_upload_add"];
    [centerView addSubview:addImageView];
    
    UILabel *addLabel = [JLUIFactory labelInitText:@"上传图片" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_909090 textAlignment:NSTextAlignmentCenter];
    [centerView addSubview:addLabel];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addButton];
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.centerY.equalTo(view);
    }];
    [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView);
        make.size.mas_equalTo(28.0f);
        make.centerX.equalTo(centerView);
    }];
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(centerView);
        make.height.mas_equalTo(13.0f);
        make.top.equalTo(addImageView.mas_bottom).offset(12.0f);
    }];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    return view;
}

- (void)addButtonClick {
    self.addView.hidden = YES;
    self.showImageView.hidden = NO;
}

- (UIView *)itemView {
    UIView *view = [[UIView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor randomColor];
    ViewBorderRadius(imageView, 5.0f, 0.0f, JL_color_clear);
    [view addSubview:imageView];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"icon_mine_upload_delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleteBtn];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(view);
        make.top.mas_equalTo(6.0f);
        make.right.mas_equalTo(-7.0f);
    }];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(view);
        make.size.mas_equalTo(18.0f);
    }];
    
    return view;
}

- (void)deleteBtnClick:(UIButton *)sender {
    self.addView.hidden = NO;
    self.showImageView.hidden = YES;
}
@end
