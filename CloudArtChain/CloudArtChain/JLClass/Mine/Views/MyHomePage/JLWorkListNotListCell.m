//
//  JLWorkListNotListCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWorkListNotListCell.h"

@interface JLWorkListNotListCell ()
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIButton *addToListBtn;
@property (nonatomic, strong) UIButton *applyAuctionBtn;
@property (nonatomic, strong) UIButton *applyAddCertBtn;
@property (nonatomic, strong) UILabel *applyAddCertStatusLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation JLWorkListNotListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.centerView];
    [self.centerView addSubview:self.addToListBtn];
    [self.centerView addSubview:self.applyAuctionBtn];
    [self.centerView addSubview:self.applyAddCertBtn];
    [self.centerView addSubview:self.applyAddCertStatusLabel];
    
    [self.contentView addSubview:self.statusLabel];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.0f);
        make.left.equalTo(self.addressLabel.mas_right);
        make.top.mas_equalTo(20.0f);
        make.bottom.mas_equalTo(-20.0f);
    }];
    [self.addToListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.centerView);
    }];
    [self.applyAuctionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView);
        make.top.equalTo(self.addToListBtn.mas_bottom);
        make.height.equalTo(self.addToListBtn.mas_height);
    }];
    [self.applyAddCertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.applyAuctionBtn.mas_bottom);
        make.right.bottom.equalTo(self.centerView);
        make.height.equalTo(self.applyAuctionBtn.mas_height);
    }];
    [self.applyAddCertStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.applyAuctionBtn.mas_bottom);
        make.right.bottom.equalTo(self.centerView);
        make.height.equalTo(self.applyAuctionBtn.mas_height);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.centerView);
    }];
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
    }
    return _centerView;
}

- (UIButton *)addToListBtn {
    if (!_addToListBtn) {
        _addToListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addToListBtn setTitle:@"上架" forState:UIControlStateNormal];
        [_addToListBtn setTitleColor:JL_color_green_48B422 forState:UIControlStateNormal];
        _addToListBtn.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_addToListBtn addTarget:self action:@selector(addToListBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addToListBtn;
}

- (void)addToListBtnClick {
    if (self.addToListBlock) {
        self.addToListBlock(self.artDetailData);
    }
}

- (UIButton *)applyAuctionBtn {
    if (!_applyAuctionBtn) {
        _applyAuctionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyAuctionBtn setTitle:@"发起拍卖" forState:UIControlStateNormal];
        [_applyAuctionBtn setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        _applyAuctionBtn.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_applyAuctionBtn addTarget:self action:@selector(applyAuctionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyAuctionBtn;
}

- (void)applyAuctionBtnClick {
    if (self.applyAuctionBlock) {
        self.applyAuctionBlock(self.artDetailData);
    }
}

- (UIButton *)applyAddCertBtn {
    if (!_applyAddCertBtn) {
        _applyAddCertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyAddCertBtn setTitle:@"申请加签" forState:UIControlStateNormal];
        [_applyAddCertBtn setTitleColor:JL_color_blue_38B2F1 forState:UIControlStateNormal];
        _applyAddCertBtn.titleLabel.font = kFontPingFangSCRegular(14.0f);
        [_applyAddCertBtn addTarget:self action:@selector(applyAddCertBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyAddCertBtn;
}

- (void)applyAddCertBtnClick {
    if (self.applyAddCertBlock) {
        self.applyAddCertBlock(self.artDetailData);
    }
}

- (UILabel *)applyAddCertStatusLabel {
    if (!_applyAddCertStatusLabel) {
        _applyAddCertStatusLabel = [JLUIFactory labelInitText:@"加签审核中" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_BBBBBB textAlignment:NSTextAlignmentRight];
        _applyAddCertStatusLabel.hidden = YES;
    }
    return _applyAddCertStatusLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [JLUIFactory labelInitText:@"上传审核中" font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_BBBBBB textAlignment:NSTextAlignmentRight];
        _statusLabel.hidden = YES;
    }
    return _statusLabel;
}

- (void)setArtDetail:(Model_art_Detail_Data *)artDetailData {
    if ([artDetailData.aasm_state isEqualToString:@"prepare"]) {
        self.statusLabel.hidden = NO;
        self.addToListBtn.hidden = YES;
        self.applyAuctionBtn.hidden = YES;
        self.applyAddCertBtn.hidden = YES;
        self.applyAddCertStatusLabel.hidden = YES;
    } else {
        self.statusLabel.hidden = YES;
        self.addToListBtn.hidden = NO;
        self.applyAuctionBtn.hidden = NO;
        self.applyAddCertBtn.hidden = NO;
    }
}
@end
