//
//  JLDappMoreCell.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/27.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappMoreCell.h"

@interface JLDappMoreCell ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation JLDappMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _imgView = [[UIImageView alloc] init];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.layer.cornerRadius = 17.5;
    _imgView.layer.borderWidth = 1;
    _imgView.layer.borderColor = JL_color_gray_DDDDDD.CGColor;
    _imgView.clipsToBounds = YES;
    [self.contentView addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(@35);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = JL_color_gray_101010;
    _nameLabel.font = kFontPingFangSCRegular(15);
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView).offset(-2);
        make.left.equalTo(self.imgView.mas_right).offset(17);
        make.right.equalTo(self.contentView);
    }];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textColor = JL_color_gray_999999;
    _descLabel.font = kFontPingFangSCRegular(12);
    [self.contentView addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgView).offset(2);
        make.left.equalTo(self.imgView.mas_right).offset(17);
        make.right.equalTo(self.contentView);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(66);
        make.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(@1);
    }];
}

#pragma mark - setters and getters
- (void)setDappData:(Model_dapp_Data *)dappData {
    _dappData = dappData;
    
    _nameLabel.text = _dappData.title;
    _descLabel.text = _dappData.desc;
    if (![NSString stringIsEmpty:_dappData.logo.url]) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:_dappData.logo.url]];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
