//
//  JLArtDetailVideoView.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/9.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLArtDetailVideoView.h"

@interface JLArtDetailVideoView ()

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIImageView *coverImgView;

@end

@implementation JLArtDetailVideoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _coverImgView = [[UIImageView alloc] init];
    _coverImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_coverImgView];
    [_coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setImage:[UIImage imageNamed:@"nft_video_play_icon2"] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playBtn];
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(@60);
    }];
}

#pragma mark - event response
- (void)playBtnClick: (UIButton *)sender {
    if (_playOrStopBlock) {
        _playOrStopBlock(sender.isSelected);
    }
    
    sender.selected = !sender.selected;
}

#pragma mark - setters and getters
- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    _artDetailData = artDetailData;
    
    
    if ([NSString stringIsEmpty:self.artDetailData.img_main_file2[@"url"]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.coverImgView.image = [UIImage thumbnailImageForVideo:[NSURL URLWithString:self.artDetailData.img_main_file2[@"url"]] atTime:1.0];
//        self.coverImgView.image = [UIImage thumbnailImageForVideo:[NSURL URLWithString:self.artDetailData.video_url] atTime:1.0];
    });
}

@end
