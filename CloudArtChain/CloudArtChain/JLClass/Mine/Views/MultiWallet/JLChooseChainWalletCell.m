//
//  JLChooseChainWalletCell.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLChooseChainWalletCell.h"

@interface JLChooseChainWalletCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation JLChooseChainWalletCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(@40);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = JL_color_gray_101010;
    _titleLabel.font = kFontPingFangSCSCSemibold(17);
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView).offset(-2);
        make.left.equalTo(self.imgView.mas_right).offset(15);
    }];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textColor = JL_color_gray_999999;
    _descLabel.font = kFontPingFangSCRegular(13);
    [self.contentView addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgView).offset(2);
        make.left.equalTo(self.titleLabel);
    }];
    
    _arrowImgView = [[UIImageView alloc] init];
    _arrowImgView.image = [UIImage imageNamed:@"icon_applycert_arrowright"];
    [self.contentView addSubview:_arrowImgView];
    [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-23);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-19);
        make.height.mas_equalTo(@1);
    }];
}

- (void)setSymbol: (JLMultiChainWalletSymbol)symbol name: (JLMultiChainWalletName)name imageNamed: (NSString *)imageNamed {
    _titleLabel.text = symbol;
    _descLabel.text = name;
    _imgView.image = [UIImage imageNamed:imageNamed];
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
