//
//  JLCreatorTableHeaderViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/6/8.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLCreatorTableHeaderViewCell.h"

@interface JLCreatorTableHeaderViewCell ()
@property (nonatomic, strong) UIView *shadowContentView;
@property (nonatomic, strong) UIImageView *recommendImageView;
@property (nonatomic, strong) UIImageView *platformImageView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation JLCreatorTableHeaderViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.shadowContentView];
    [self.shadowContentView addSubview:self.recommendImageView];
    [self.recommendImageView addSubview:self.platformImageView];
    [self.shadowContentView addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.shadowContentView);
        make.height.mas_equalTo(40.0f);
    }];
    [self.recommendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.shadowContentView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.platformImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recommendImageView);
        make.top.mas_equalTo(15.0f);
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.bottomView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13.0f);
        make.top.bottom.equalTo(self.bottomView);
    }];
}

- (UIView *)shadowContentView {
    if (!_shadowContentView) {
        _shadowContentView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 7.0f, kScreenWidth - 15.0f * 2, 243.0f - 7.0f * 2)];
        _shadowContentView.backgroundColor = JL_color_white_ffffff;
        _shadowContentView.layer.cornerRadius = 5.0f;
        _shadowContentView.layer.masksToBounds = NO;
        _shadowContentView.layer.shadowColor = JL_color_black.CGColor;
        _shadowContentView.layer.shadowOpacity = 0.13f;
        _shadowContentView.layer.shadowOffset = CGSizeZero;
        _shadowContentView.layer.shadowRadius = 7.0f;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:_shadowContentView.bounds];
        _shadowContentView.layer.shadowPath = path.CGPath;
    }
    return _shadowContentView;
}

- (UIImageView *)recommendImageView {
    if (!_recommendImageView) {
        _recommendImageView = [[UIImageView alloc] init];
        _recommendImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [_recommendImageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
    }
    return _recommendImageView;
}

- (UIImageView *)platformImageView {
    if (!_platformImageView) {
        _platformImageView = [JLUIFactory imageViewInitImageName:@"icon_creator_platform"];
//        _platformImageView.hidden = YES;
    }
    return _platformImageView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFontPingFangSCSCSemibold(17.0f);
        _nameLabel.textColor = JL_color_gray_101010;
    }
    return _nameLabel;
}

- (void)setAuthorData:(Model_art_author_Data *)authorData indexPath:(NSIndexPath *)indexPath {
    if (![NSString stringIsEmpty:authorData.recommend_image[@"url"]]) {
        [self.recommendImageView sd_setImageWithURL:[NSURL URLWithString:authorData.recommend_image[@"url"]]];
    } else {
        self.recommendImageView.image = nil;
    }
    self.recommendImageView.frame = CGRectMake(0.0f, 0.0f, self.shadowContentView.frameWidth, self.shadowContentView.frameHeight - 40.0f);
    [self.recommendImageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
    self.nameLabel.text = authorData.display_name;
//    self.platformImageView.hidden = (indexPath.row != 0);
}
@end
