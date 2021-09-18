//
//  JLMultiChainWalletCell.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/18.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLMultiChainWalletCell.h"

@interface JLMultiChainWalletCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *moreImgView;
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation JLMultiChainWalletCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth - 30, 85)];
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;
    [_bgView addGradientFromColor:JL_color_blue_5DD2F2 toColor:JL_color_blue_24B2D8];
    [self.contentView addSubview:_bgView];

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = JL_color_white_ffffff;
    _nameLabel.font = kFontPingFangSCSCSemibold(16);
    [_bgView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(18);
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-60);
    }];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.textColor = JL_color_white_ffffff;
    _addressLabel.font = kFontPingFangSCRegular(13);
    _addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [_bgView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView).offset(-20);
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-58);
    }];
    
    _moreImgView = [[UIImageView alloc] init];
    _moreImgView.image = [UIImage imageNamed:@"icon_mine_multi_wallet_more"];
    [_bgView addSubview:_moreImgView];
    [_moreImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-20);
        make.centerY.equalTo(self.nameLabel);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
}

- (void)setWalletName: (NSString *)name address: (NSString *)address {
    _nameLabel.text = name;
    _addressLabel.text = address;
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
