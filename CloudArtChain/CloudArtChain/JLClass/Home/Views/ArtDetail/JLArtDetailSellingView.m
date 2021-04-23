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
    [self.tableView reloadData];
}

- (void)createSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.tableView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17.0f);
        make.top.mas_equalTo(10.0f);
        make.height.mas_equalTo(45.0f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"出售列表" font:kFontPingFangSCSCSemibold(16.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
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
        [_tableView registerClass:[JLArtDetailSellingTableViewCell class] forCellReuseIdentifier:@"JLArtDetailSellingTableViewCell"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sellingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLArtDetailSellingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLArtDetailSellingTableViewCell" forIndexPath:indexPath];
    cell.sellingOrderData = self.sellingArray[indexPath.row];
    cell.operationBlock = ^(Model_arts_id_orders_Data * _Nonnull sellingOrderData) {
        if (sellingOrderData.is_mine) {
            // 下架
            if (self.offFromListBlock) {
                self.offFromListBlock();
            }
        } else {
            if (self.buyBlock) {
                self.buyBlock(sellingOrderData);
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

@end
