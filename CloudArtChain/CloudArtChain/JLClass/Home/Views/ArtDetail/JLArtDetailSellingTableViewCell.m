//
//  JLArtDetailSellingTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/23.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLArtDetailSellingTableViewCell.h"

@interface JLArtDetailSellingTableViewCell ()
@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIView *priceView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *numView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIView *operationView;
@property (nonatomic, strong) UIButton *operationButton;
@end

@implementation JLArtDetailSellingTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.addressView];
    [self.contentView addSubview:self.priceView];
    [self.contentView addSubview:self.numView];
    [self.contentView addSubview:self.operationView];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(kScreenWidth * 0.25f);
    }];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressView.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(kScreenWidth * 0.25f);
    }];
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceView.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(kScreenWidth * 0.25f);
    }];
    [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numView.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(kScreenWidth * 0.25f);
    }];
    
    [self.addressView addSubview:self.addressLabel];
    [self.priceView addSubview:self.priceLabel];
    [self.numView addSubview:self.numLabel];
    [self.operationView addSubview:self.operationButton];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.addressView);
        make.left.mas_equalTo(16.0f);
        make.right.mas_equalTo(-16.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.priceView);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.numView);
    }];
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50.0f);
        make.height.mas_equalTo(20.0f);
        make.center.equalTo(self.operationView);
    }];
}

- (UIView *)addressView {
    if (!_addressView) {
        _addressView = [[UIView alloc] init];
    }
    return _addressView;
}

- (UIView *)priceView {
    if (!_priceView) {
        _priceView = [[UIView alloc] init];
    }
    return _priceView;
}

- (UIView *)numView {
    if (!_numView) {
        _numView = [[UIView alloc] init];
    }
    return _numView;
}

- (UIView *)operationView {
    if (!_operationView) {
        _operationView = [[UIView alloc] init];
    }
    return _operationView;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
        _addressLabel.numberOfLines = 1;
        _addressLabel.userInteractionEnabled = YES;
        [_addressLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressLabelDidTap:)]];
    }
    return _addressLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_red_D70000 textAlignment:NSTextAlignmentCenter];
    }
    return _priceLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [JLUIFactory labelInitText:@"" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_101010 textAlignment:NSTextAlignmentCenter];
    }
    return _numLabel;
}

- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operationButton setTitleColor:JL_color_mainColor forState:UIControlStateNormal];
        _operationButton.titleLabel.font = kFontPingFangSCRegular(12.0f);
        [_operationButton addTarget:self action:@selector(operationButtonClick) forControlEvents:UIControlEventTouchUpInside];
        ViewBorderRadius(_operationButton, 3.0f, 1.0f, JL_color_mainColor);
    }
    return _operationButton;
}

- (void)operationButtonClick {
    if (self.operationBlock) {
        self.operationBlock(self.sellingOrderData);
    }
}

- (void)addressLabelDidTap: (UITapGestureRecognizer *)ges {
    if (self.lookUserInfoBlock) {
        self.lookUserInfoBlock(self.sellingOrderData);
    }
}

- (void)setSellingOrderData:(Model_arts_id_orders_Data *)sellingOrderData {
    _sellingOrderData = sellingOrderData;
    self.addressLabel.text = sellingOrderData.address;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", sellingOrderData.price];
    self.numLabel.text = [NSString stringWithFormat:@"%@/%@", sellingOrderData.amount, sellingOrderData.total_amount];
    if (sellingOrderData.is_mine) {
        [self.operationButton setTitle:@"下架" forState:UIControlStateNormal];
    } else {
        [self.operationButton setTitle:@"购买" forState:UIControlStateNormal];
    }
}

@end
