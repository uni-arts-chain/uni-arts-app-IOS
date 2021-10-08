//
//  JLDappCell.m
//  CloudArtChain
//
//  Created by jielian on 2021/10/8.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappCell.h"
#import "JLDappTitleView.h"
#import "JLDappChainView.h"

@interface JLDappCell ()

@property (nonatomic, strong) JLDappTitleView *titleView;

@property (nonatomic, strong) JLDappChainView *chainView;

@end

@implementation JLDappCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    WS(weakSelf)
    _titleView = [[JLDappTitleView alloc] init];
    _titleView.moreBlock = ^(NSInteger index) {
        if (weakSelf.moreBlock) {
            weakSelf.moreBlock(weakSelf.chainCategoryData);
        }
    };
    [self.contentView addSubview:_titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(3);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(@30);
    }];

    _chainView = [[JLDappChainView alloc] init];
    _chainView.lookDappBlock = ^(Model_dapp_Data * _Nonnull dappData) {
        if (weakSelf.lookDappBlock) {
            weakSelf.lookDappBlock(dappData);
        }
    };
    [self.contentView addSubview:_chainView];
    [_chainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - setters and getters
- (void)setChainCategoryData:(Model_chain_category_Data *)chainCategoryData {
    _chainCategoryData = chainCategoryData;
    
    [_titleView setTitleArray:@[_chainCategoryData.title] selectIndex:0 style:JLDappTitleViewStyleNoScroll];
    _chainView.dataArray = _chainCategoryData.dapps;
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
