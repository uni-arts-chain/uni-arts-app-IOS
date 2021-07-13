//
//  JLArtDetailSellingView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/23.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLArtDetailSellingView.h"
#import "JLArtDetailSellingTableViewCell.h"

@interface JLArtDetailSellingView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomCenterView;
@property (nonatomic, strong) UILabel *openCloseLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIButton *openCloseButton;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JLArtDetailSellingView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = JL_color_white_ffffff;
        [self createSubViews];
    }
    return self;
}

- (void)setSellingArray:(NSArray *)sellingArray {
    _sellingArray = sellingArray;
    if (sellingArray.count > 4) {
        self.bottomView.hidden = NO;
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
    } else {
        self.bottomView.hidden = YES;
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.bottom.equalTo(self);
        }];
    }
    [self.tableView reloadData];
}

- (void)createSubViews {
    // 标题高度 55.0f
    [self addSubview:self.titleLabel];
    [self addSubview:self.bottomView];
    // 底部高度 48.0f
    [self.bottomView addSubview:self.bottomCenterView];
    [self.bottomCenterView addSubview:self.openCloseLabel];
    [self.bottomCenterView addSubview:self.arrowImageView];
    [self.bottomView addSubview:self.openCloseButton];
    // 35.0f + 38.0f * row
    [self addSubview:self.tableView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17.0f);
        make.top.mas_equalTo(10.0f);
        make.height.mas_equalTo(45.0f);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.mas_equalTo(-15.0f);
        make.height.mas_equalTo(33.0f);
    }];
    
    [self.bottomCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomView);
    }];
    [self.openCloseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomView);
    }];
    [self.openCloseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bottomCenterView);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomCenterView);
        make.width.mas_equalTo(12.0f);
        make.height.mas_equalTo(7.0f);
        make.left.equalTo(self.openCloseLabel.mas_right).offset(4.0f);
        make.centerY.equalTo(self.bottomCenterView.mas_centerY);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"出售列表" font:kFontPingFangSCSCSemibold(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UIView *)bottomCenterView {
    if (!_bottomCenterView) {
        _bottomCenterView = [[UIView alloc] init];
    }
    return _bottomCenterView;
}

- (UILabel *)openCloseLabel {
    if (!_openCloseLabel) {
        _openCloseLabel = [JLUIFactory labelInitText:@"展开全部列表" font:kFontPingFangSCRegular(13.0f) textColor:JL_color_gray_999999 textAlignment:NSTextAlignmentCenter];
    }
    return _openCloseLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [JLUIFactory imageViewInitImageName:@"icon_artdetail_selling_arrow"];
    }
    return _arrowImageView;
}

- (UIButton *)openCloseButton {
    if (!_openCloseButton) {
        _openCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openCloseButton addTarget:self action:@selector(openCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openCloseButton;
}

- (void)openCloseButtonClick {
    self.openCloseButton.selected = !self.openCloseButton.selected;
    self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, M_PI);
    if (self.openCloseButton.selected) {
        self.openCloseLabel.text = @"收起全部列表";
    } else {
        self.openCloseLabel.text= @"展开全部列表";
    }
    if (self.openCloseListBlock) {
        self.openCloseListBlock(self.openCloseButton.selected);
    }
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JL_color_white_ffffff;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 38.0f;
        _tableView.estimatedSectionHeaderHeight = 35.0f;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[JLArtDetailSellingTableViewCell class] forCellReuseIdentifier:@"JLArtDetailSellingTableViewCell"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sellingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    JLArtDetailSellingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLArtDetailSellingTableViewCell" forIndexPath:indexPath];
    cell.sellingOrderData = self.sellingArray[indexPath.row];
    cell.lookUserInfoBlock = ^(Model_arts_id_orders_Data * _Nonnull sellingOrderData) {
        if (weakSelf.lookUserInfoBlock) {
            weakSelf.lookUserInfoBlock(sellingOrderData);
        }
    };
    cell.operationBlock = ^(Model_arts_id_orders_Data * _Nonnull sellingOrderData) {
        if (sellingOrderData.is_mine) {
            // 下架
            if (weakSelf.offFromListBlock) {
                weakSelf.offFromListBlock(sellingOrderData);
            }
        } else {
            if (weakSelf.buyBlock) {
                weakSelf.buyBlock(sellingOrderData);
            }
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 38.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    
    UILabel *sellerLabel = [JLUIFactory labelInitText:@"出售者" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    [headerView addSubview:sellerLabel];
    
    UILabel *priceLabel = [JLUIFactory labelInitText:@"单价" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    [headerView addSubview:priceLabel];
    
    UILabel *numLabel = [JLUIFactory labelInitText:@"份数" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    [headerView addSubview:numLabel];
    
    UILabel *operationLabel = [JLUIFactory labelInitText:@"操作" font:kFontPingFangSCSCSemibold(15.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    [headerView addSubview:operationLabel];
    
    [sellerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(headerView);
        make.width.mas_equalTo(kScreenWidth * 0.25f);
    }];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(headerView);
        make.left.equalTo(sellerLabel.mas_right);
        make.width.mas_equalTo(kScreenWidth * 0.25f);
    }];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(headerView);
        make.left.equalTo(priceLabel.mas_right);
        make.width.mas_equalTo(kScreenWidth * 0.25f);
    }];
    [operationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(headerView);
        make.left.equalTo(numLabel.mas_right);
        make.width.mas_equalTo(kScreenWidth * 0.25f);
    }];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}

@end
