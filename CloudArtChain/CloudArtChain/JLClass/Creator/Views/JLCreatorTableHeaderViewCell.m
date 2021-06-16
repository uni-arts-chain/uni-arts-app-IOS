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
    [self.shadowContentView addSubview:self.nameLabel];
    
    [self.shadowContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(7.0f);
        make.left.equalTo(self.contentView).offset(15.0f);
        make.right.equalTo(self.contentView).offset(-15.0f);
        make.bottom.equalTo(self.contentView).offset(-7.0f);
    }];

    [self.recommendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.shadowContentView);
        make.height.mas_equalTo(190.0f);
    }];
    [self.platformImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recommendImageView);
        make.top.mas_equalTo(15.0f);
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recommendImageView.mas_bottom).offset(9.0f);
        make.left.equalTo(self.shadowContentView).offset(13.0f);
        make.right.equalTo(self.shadowContentView).offset(-10.0f);
    }];
}

- (UIView *)shadowContentView {
    if (!_shadowContentView) {
        _shadowContentView = [[UIView alloc] init];
        _shadowContentView.backgroundColor = JL_color_white_ffffff;
        _shadowContentView.layer.cornerRadius = 5.0f;
        _shadowContentView.layer.masksToBounds = NO;
        _shadowContentView.layer.shadowColor = JL_color_black.CGColor;
        _shadowContentView.layer.shadowOpacity = 0.13f;
        _shadowContentView.layer.shadowOffset = CGSizeZero;
        _shadowContentView.layer.shadowRadius = 7.0f;
    }
    return _shadowContentView;
}

- (UIImageView *)recommendImageView {
    if (!_recommendImageView) {
        _recommendImageView = [[UIImageView alloc] init];
        _recommendImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _recommendImageView;
}

- (UIImageView *)platformImageView {
    if (!_platformImageView) {
        _platformImageView = [JLUIFactory imageViewInitImageName:@"icon_creator_platform"];
    }
    return _platformImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFontPingFangSCSCSemibold(17.0f);
        _nameLabel.textColor = JL_color_gray_101010;
        _nameLabel.numberOfLines = 0;
        _nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _nameLabel;
}

- (void)setAuthorData:(Model_art_author_Data *)authorData indexPath:(NSIndexPath *)indexPath {
    if (![NSString stringIsEmpty:authorData.recommend_image[@"url"]]) {
        [self.recommendImageView sd_setImageWithURL:[NSURL URLWithString:authorData.recommend_image[@"url"]]];
    } else {
        self.recommendImageView.image = nil;
    }
    self.nameLabel.text = authorData.display_name;
    
    [self.recommendImageView layoutIfNeeded];
    [self.recommendImageView setCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:CGSizeMake(5.0f, 5.0f)];
}
@end
