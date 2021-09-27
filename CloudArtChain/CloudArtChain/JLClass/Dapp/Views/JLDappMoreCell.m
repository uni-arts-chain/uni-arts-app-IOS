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
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.backgroundColor = JL_color_blue_6077DF;
    imgView.layer.cornerRadius = 17.5;
    imgView.layer.borderWidth = 1;
    imgView.layer.borderColor = JL_color_gray_DDDDDD.CGColor;
    imgView.clipsToBounds = YES;
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(@35);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"Uniswap";
    nameLabel.textColor = JL_color_gray_101010;
    nameLabel.font = kFontPingFangSCRegular(15);
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView).offset(-2);
        make.left.equalTo(imgView.mas_right).offset(17);
        make.right.equalTo(self.contentView);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"去中心化流通平台";
    descLabel.textColor = JL_color_gray_999999;
    descLabel.font = kFontPingFangSCRegular(12);
    [self.contentView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imgView).offset(2);
        make.left.equalTo(imgView.mas_right).offset(17);
        make.right.equalTo(self.contentView);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(66);
        make.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(@1);
    }];
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
