//
//  JLOrderDetailPayMethodTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/15.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLOrderDetailPayMethodTableViewCell.h"

static const CGFloat KMethodViewHeight = 43.0f;

@interface JLOrderDetailPayMethodTableViewCell ()
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *payMethodView;
@property (nonatomic, strong) NSArray *payImageArray;
@property (nonatomic, strong) NSArray *payTitleArray;
@property (nonatomic, strong) NSMutableArray *selectedButtonArray;
@end

@implementation JLOrderDetailPayMethodTableViewCell
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
    [self.shadowView addSubview:self.payMethodView];
    
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
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(17.0f);
    }];
    [self.payMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(self.payImageArray.count * KMethodViewHeight);
        make.bottom.equalTo(self.shadowView).offset(-10.0f);
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
        _titleLabel = [JLUIFactory labelInitText:@"支付方式" font:kFontPingFangSCMedium(17.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UIView *)payMethodView {
    if (!_payMethodView) {
        _payMethodView = [[UIView alloc] init];
        [self.selectedButtonArray removeAllObjects];
        for (int i = 0; i < self.payImageArray.count; i++) {
            UIView *methodView = [self createMethodView:i];
            [_payMethodView addSubview:methodView];
            [methodView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_payMethodView);
                make.height.mas_equalTo(KMethodViewHeight);
                make.top.mas_equalTo(i * KMethodViewHeight);
            }];
        }
    }
    return _payMethodView;
}

- (UIView *)createMethodView:(NSInteger)index  {
    UIView *methodView = [[UIView alloc] init];
    
    UIImageView *maskImageView = [[UIImageView alloc] init];
    maskImageView.image = self.payImageArray[index];
    [methodView addSubview:maskImageView];
    
    UILabel *titleLabel = [JLUIFactory labelInitText:self.payTitleArray[index] font:kFontPingFangSCRegular(14.0f) textColor:JL_color_gray_212121 textAlignment:NSTextAlignmentLeft];
    [methodView addSubview:titleLabel];
    
    UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedButton setImage:[UIImage imageNamed:@"icon_pay_method_normal"] forState:UIControlStateNormal];
    [selectedButton setImage:[UIImage imageNamed:@"icon_pay_method_selected"] forState:UIControlStateSelected];
    [methodView addSubview:selectedButton];
    
    if (index == 0) {
        selectedButton.selected = YES;
        if (self.selectedMethodBlock) {
            self.selectedMethodBlock(JLOrderPayTypeWeChat);
        }
    }
    [self.selectedButtonArray addObject:selectedButton];
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.tag = index;
    [selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [methodView addSubview:selectButton];
    
    [maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(3.0f);
        make.size.mas_equalTo(23.0f);
        make.centerY.equalTo(methodView.mas_centerY);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maskImageView.mas_right).offset(13.0f);
        make.centerY.equalTo(methodView.mas_centerY);
    }];
    [selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(methodView);
        make.size.mas_equalTo(13.0f);
        make.centerY.equalTo(methodView.mas_centerY);
    }];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(methodView);
    }];
    return methodView;
}

- (void)selectButtonClick:(UIButton *)sender {
    for (UIButton *selectedButton in self.selectedButtonArray) {
        selectedButton.selected = NO;
    }
    UIButton *currentSelectedBtn = self.selectedButtonArray[sender.tag];
    currentSelectedBtn.selected = YES;
    if (self.selectedMethodBlock) {
        self.selectedMethodBlock(sender.tag);
    }
}

- (NSArray *)payImageArray {
    if (!_payImageArray) {
        _payImageArray = @[[UIImage imageNamed:@"icon_paymethod_wechat"], [UIImage imageNamed:@"icon_paymethod_alipay"]];
    }
    return _payImageArray;
}

- (NSArray *)payTitleArray {
    if (!_payTitleArray) {
        _payTitleArray = @[@"微信支付", @"支付宝支付"];
    }
    return _payTitleArray;
}

- (NSMutableArray *)selectedButtonArray {
    if (!_selectedButtonArray) {
        _selectedButtonArray = [NSMutableArray array];
    }
    return _selectedButtonArray;
}
@end
