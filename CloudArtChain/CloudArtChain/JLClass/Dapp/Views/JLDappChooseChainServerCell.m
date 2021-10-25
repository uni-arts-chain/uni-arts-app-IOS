//
//  JLDappChooseChainServerCell.m
//  CloudArtChain
//
//  Created by jielian on 2021/10/25.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappChooseChainServerCell.h"

@interface JLDappChooseChainServerCell ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation JLDappChooseChainServerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _imgView = [[UIImageView alloc] init];
    _imgView.image = [UIImage imageNamed:@"icon_dapp_choose_network_selected"];
    [self.contentView addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(12, 8));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = JL_color_gray_101010;
    _titleLabel.font = kFontPingFangSCSCSemibold(15);
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(20);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.imgView);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(@1);
    }];
}

#pragma mark - setters and getters
- (void)setIsChoosed:(BOOL)isChoosed {
    _isChoosed = isChoosed;
    
    _imgView.hidden = !_isChoosed;
}

- (void)setRpcServerData:(Model_eth_rpc_server_data *)rpcServerData {
    _rpcServerData = rpcServerData;
    
    _titleLabel.text = _rpcServerData.name;
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
