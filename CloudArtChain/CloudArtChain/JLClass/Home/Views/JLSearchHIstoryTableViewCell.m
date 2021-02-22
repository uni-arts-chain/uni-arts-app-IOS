//
//  JLSearchHIstoryTableViewCell.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLSearchHIstoryTableViewCell.h"

@interface JLSearchHIstoryTableViewCell ()
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation JLSearchHIstoryTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.deleteBtn];
    [self.contentView addSubview:self.lineView];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24.0f);
        make.bottom.mas_equalTo(-10.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-27.0f);
        make.size.mas_equalTo(10.0f);
        make.left.equalTo(self.contentLabel.mas_right).offset(10.0f);
        make.centerY.equalTo(self.contentLabel.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.bottom.equalTo(self.contentView);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(1.0f);
    }];
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = kFontPingFangSCRegular(15.0f);
        _contentLabel.textColor = JL_color_gray_606060;
    }
    return _contentLabel;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"icon_search_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = JL_color_gray_DDDDDD;
    }
    return _lineView;
}

- (void)deleteBtnClick {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (void)setHistoryContent:(NSString *)historyContent {
    self.contentLabel.text = historyContent;
}
@end
