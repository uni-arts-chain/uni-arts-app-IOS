//
//  JLArtInfoView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/2.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLArtInfoView.h"
#import "NSDate+Extension.h"

@interface JLArtInfoView ()
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *workDescView;
@property (nonatomic, strong) UIImageView *workDescImageView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *materialLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation JLArtInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _workDescView.layer.cornerRadius = 5.0f;
    _workDescView.layer.masksToBounds = NO;
    _workDescView.layer.shadowColor = JL_color_black.CGColor;
    _workDescView.layer.shadowOpacity = 0.5f;
    _workDescView.layer.shadowOffset = CGSizeZero;
    _workDescView.layer.shadowRadius = 5.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_workDescView.bounds];
    _workDescView.layer.shadowPath = path.CGPath;
}

- (void)createSubviews {
    UIView *titleView = [JLUIFactory titleViewWithTitle:@"艺术品信息"];
    titleView.backgroundColor = JL_color_white_ffffff;
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(65.0f);
    }];
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(titleView.mas_bottom);
    }];
    
    [self.contentView addSubview:self.workDescView];
    [self.workDescView addSubview:self.workDescImageView];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.materialLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.dateLabel];
    
    [self.workDescView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(40.0f);
        make.width.mas_equalTo(150.0f);
        make.height.mas_equalTo(110.0f);
    }];
    [self.workDescImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.workDescView);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(41.0f);
        make.left.equalTo(self.workDescView.mas_right).offset(26.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(8.0f);
        make.left.equalTo(self.descLabel.mas_left);
        make.width.mas_equalTo(21.0f);
        make.height.mas_equalTo(3.0f);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(10.0f);
        make.left.equalTo(self.descLabel.mas_left);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.materialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sizeLabel.mas_bottom).offset(10.0f);
        make.left.equalTo(self.descLabel.mas_left);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.materialLabel.mas_bottom).offset(10.0f);
        make.left.equalTo(self.descLabel.mas_left);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom).offset(10.0f);
        make.left.equalTo(self.descLabel.mas_left);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(12.0f);
    }];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIView *)workDescView {
    if (!_workDescView) {
        _workDescView = [[UIView alloc] init];
        _workDescView.backgroundColor = JL_color_white_ffffff;
    }
    return _workDescView;
}

- (UIImageView *)workDescImageView {
    if (!_workDescImageView) {
        _workDescImageView = [[UIImageView alloc] init];
    }
    return _workDescImageView;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _descLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_101010;
    }
    return _lineView;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [JLUIFactory labelInitText:@"尺寸：" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_606060 textAlignment:NSTextAlignmentLeft];
    }
    return _sizeLabel;
}

- (UILabel *)materialLabel {
    if (!_materialLabel) {
        _materialLabel = [JLUIFactory labelInitText:@"材质：" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_606060 textAlignment:NSTextAlignmentLeft];
    }
    return _materialLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [JLUIFactory labelInitText:@"作品类型：" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_606060 textAlignment:NSTextAlignmentLeft];
    }
    return _typeLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [JLUIFactory labelInitText:@"创作时间：" font:kFontPingFangSCRegular(12.0f) textColor:JL_color_gray_606060 textAlignment:NSTextAlignmentLeft];
    }
    return _dateLabel;
}

- (void)setArtDetailData:(Model_art_Detail_Data *)artDetailData {
    if (![NSString stringIsEmpty:artDetailData.img_main_file1[@"url"]]) {
        [self.workDescImageView sd_setImageWithURL:[NSURL URLWithString:artDetailData.img_main_file1[@"url"]]];
    }
    self.descLabel.text = artDetailData.name;
    self.sizeLabel.text = [NSString stringWithFormat:@"尺寸：%@x%@cm", artDetailData.size_width, artDetailData.size_length];
    self.materialLabel.text = [NSString stringWithFormat:@"材质：%@", [[AppSingleton sharedAppSingleton] getMaterialByID:@(artDetailData.material_id).stringValue]];
    self.typeLabel.text = [NSString stringWithFormat:@"作品类型：%@", [[AppSingleton sharedAppSingleton] getArtCategoryByID:@(artDetailData.category_id).stringValue]];
    self.dateLabel.text = [NSString stringWithFormat:@"创作时间：%@", [[NSDate dateWithTimeIntervalSince1970:artDetailData.produce_at.doubleValue] dateWithCustomFormat:@"yyyy/MM"]];
}
@end
