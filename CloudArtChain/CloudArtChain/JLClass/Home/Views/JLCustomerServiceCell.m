//
//  JLCustomerServiceCell.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLCustomerServiceCell.h"

@interface JLCustomerServiceCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIButton *pasteBtn;

@end

@implementation JLCustomerServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = JL_color_clear;
        self.contentView.backgroundColor = JL_color_clear;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = JL_color_white_ffffff;
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
    }];
    
    _topLineView = [[UIView alloc] init];
    _topLineView.backgroundColor = JL_color_gray_EDEDEC;
    [_bgView addSubview:_topLineView];
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(11);
        make.right.equalTo(self.bgView).offset(-11);
        make.height.mas_equalTo(@1);
    }];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textColor = JL_color_black_40414D;
    _descLabel.font = kFontPingFangSCRegular(15);
    [_bgView addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(12);
        make.centerY.equalTo(self.bgView);
    }];
    
    _pasteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pasteBtn setTitle:@"复制" forState:UIControlStateNormal];
    [_pasteBtn setTitleColor:JL_color_red_EF4136 forState:UIControlStateNormal];
    _pasteBtn.titleLabel.font = kFontPingFangSCRegular(14.0f);
    [_pasteBtn addTarget:self action:@selector(pasteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_pasteBtn];
    [_pasteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.bgView);
        make.width.mas_equalTo(@53);
    }];
}

#pragma mark - event response
- (void)pasteBtnClick: (UIButton *)sender {
    [UIPasteboard generalPasteboard].string = _desc;
    [[JLLoading sharedLoading] showMBSuccessTipMessage:@"复制成功" hideTime:KToastDismissDelayTimeInterval];
}

#pragma mark - setters and getters
- (void)setDesc:(NSString *)desc {
    _desc = desc;
    
    _descLabel.text = _desc;
}

- (void)setIsCorner:(BOOL)isCorner {
    _isCorner = isCorner;
    
    [_bgView layoutIfNeeded];
    if (_isCorner) {
        [_bgView setCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:CGSizeMake(8, 8)];
    }else {
        [_bgView setCorners:UIRectCornerAllCorners radius:CGSizeMake(0, 0)];
    }
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
