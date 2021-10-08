//
//  JLDappTrackCell.m
//  CloudArtChain
//
//  Created by jielian on 2021/10/8.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappTrackCell.h"
#import "JLDappEmptyView.h"

@interface JLDappTrackCell ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) JLDappEmptyView *emptyView;

@end

@implementation JLDappTrackCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
    
    _bgView = [[UIView alloc] init];
    [_scrollView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = JL_color_gray_DDDDDD;
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(@1);
    }];
    
    _emptyView = [[JLDappEmptyView alloc] init];
    _emptyView.hidden = YES;
    [_scrollView addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.scrollView);
    }];
}

- (void)updateDapps {
    [_bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (_trackArray.count == 0) {
        _emptyView.hidden = NO;
    }else {
        _emptyView.hidden = YES;
    }
    
    CGFloat itemW = 71;
    for (int i = 0; i < _trackArray.count; i++) {
        Model_dapp_Data *data = _trackArray[i];
        
        UIView *itemView = [[UIView alloc] init];
        itemView.tag = 100 + i;
        itemView.userInteractionEnabled = YES;
        [itemView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewDidTap:)]];
        [_bgView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.bgView);
            make.left.equalTo(self.bgView).offset(i * itemW);
            make.width.mas_equalTo(@(itemW));
            if (i == _trackArray.count - 1) {
                make.right.equalTo(self.bgView);
            }
        }];
        
        UIView *contentView = [[UIView alloc] init];
        [itemView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(itemView);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.layer.cornerRadius = 17.5;
        imgView.layer.borderWidth = 1;
        imgView.layer.borderColor = JL_color_gray_DDDDDD.CGColor;
        imgView.clipsToBounds = YES;
        if (![NSString stringIsEmpty:data.logo.url]) {
            [imgView sd_setImageWithURL:[NSURL URLWithString:data.logo.url]];
        }
        [contentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(contentView);
            make.width.height.mas_equalTo(@35);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = data.title;
        label.textColor = JL_color_gray_666666;
        label.font = kFontPingFangSCRegular(13);
        label.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(contentView);
            make.centerX.equalTo(contentView);
            make.top.equalTo(imgView.mas_bottom).offset(10);
        }];
    }
}

#pragma mark - event response
- (void)itemViewDidTap: (UITapGestureRecognizer *)ges {
    if (_lookDappBlock) {
        _lookDappBlock(_trackArray[ges.view.tag - 100]);
    }
}

#pragma mark - setters and getters
- (void)setTrackArray:(NSArray *)trackArray {
    _trackArray = trackArray;
    
    [self updateDapps];
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
