//
//  JLDappEmptyView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/27.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappEmptyView.h"

@interface JLDappEmptyView ()

@property (nonatomic, strong) UIView *emptyBgView;
@property (nonatomic, strong) UIImageView *emptyImgView;
@property (nonatomic, strong) UILabel *emptyLabel;

@end

@implementation JLDappEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _emptyBgView = [[UIView alloc] init];
    [self addSubview:_emptyBgView];
    [_emptyBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _emptyImgView = [[UIImageView alloc] init];
    _emptyImgView.image = [UIImage imageNamed:@"icon_dapp_empty"];
    [_emptyBgView addSubview:_emptyImgView];
    [_emptyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.emptyBgView);
        make.size.mas_equalTo(CGSizeMake(36, 26));
    }];
    
    _emptyLabel = [[UILabel alloc] init];
    _emptyLabel.text = @"暂无内容";
    _emptyLabel.textColor = JL_color_gray_BEBEBE;
    _emptyLabel.font = kFontPingFangSCRegular(13);
    [_emptyBgView addSubview:_emptyLabel];
    [_emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.emptyImgView.mas_right).offset(10);
        make.centerY.equalTo(self.emptyImgView);
        make.right.equalTo(self.emptyBgView);
    }];
}

@end
