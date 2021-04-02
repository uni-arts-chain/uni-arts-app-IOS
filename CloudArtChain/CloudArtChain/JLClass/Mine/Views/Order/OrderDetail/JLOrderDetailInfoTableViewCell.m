//
//  JLOrderDetailInfoTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/29.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLOrderDetailInfoTableViewCell.h"
#import "NSDate+Extension.h"

@interface JLOrderDetailInfoTableViewCell ()
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *orderNoLabel;
@property (nonatomic, strong) UIButton *pasteBtn;
@property (nonatomic, strong) UILabel *createTimeLabel;
@end

@implementation JLOrderDetailInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.shadowView];
    [self.shadowView addSubview:self.shadowImageView];
    [self.shadowView addSubview:self.titleLabel];
    [self.shadowView addSubview:self.orderNoLabel];
    [self.shadowView addSubview:self.pasteBtn];
    [self.shadowView addSubview:self.createTimeLabel];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(5.0f);
        make.bottom.mas_equalTo(-5.0f);
    }];
    [self.shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shadowView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8.0f);
        make.top.mas_equalTo(22.0f);
    }];
    [self.orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(25.0f);
    }];
    [self.pasteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNoLabel.mas_right).offset(20.0f);
        make.centerY.equalTo(self.orderNoLabel.mas_centerY);
    }];
    [self.createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.orderNoLabel.mas_bottom).offset(20.0f);
        make.bottom.mas_equalTo(-32.0f);
    }];
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
    }
    return _shadowView;
}

- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [JLUIFactory imageViewInitImageName:@"icon_address_back"];
    }
    return _shadowImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JLUIFactory labelInitText:@"订单信息" font:kFontPingFangSCMedium(15.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UILabel *)orderNoLabel {
    if (!_orderNoLabel) {
        _orderNoLabel = [JLUIFactory labelInitText:@"订单号：" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _orderNoLabel;
}

- (UIButton *)pasteBtn {
    if (!_pasteBtn) {
        _pasteBtn = [JLUIFactory buttonInitTitle:@"复制" titleColor:JL_color_red_D70000 backgroundColor:JL_color_white_ffffff font:kFontPingFangSCRegular(14.0f) addTarget:self action:@selector(pasteBtnClick)];
    }
    return _pasteBtn;
}

- (void)pasteBtnClick {
    [UIPasteboard generalPasteboard].string = self.orderData.ID;
    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"复制成功" hideTime:KToastDismissDelayTimeInterval];
}

- (UILabel *)createTimeLabel {
    if (!_createTimeLabel) {
        _createTimeLabel = [JLUIFactory labelInitText:@"创建时间：" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _createTimeLabel;
}

- (void)setOrderData:(Model_arts_sold_Data *)orderData {
    _orderData = orderData;
    self.orderNoLabel.text = [NSString stringWithFormat:@"订单号：%@", orderData.ID];
    NSDate *buy_time = [NSDate dateWithTimeIntervalSince1970:orderData.buy_time.doubleValue];
    self.createTimeLabel.text = [NSString stringWithFormat:@"创建时间：%@", [buy_time dateWithCustomFormat:@"yyyy/MM/dd HH:mm:ss"]];
}
@end
