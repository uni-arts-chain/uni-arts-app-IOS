//
//  JLNewAuctionArtDetailBottomView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/19.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLNewAuctionArtDetailBottomView.h"

@interface JLNewAuctionArtDetailBottomView ()

@property (nonatomic, strong) UIView *leftBgView;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UIButton *treadBtn;

@property (nonatomic, strong) UIButton *collectBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) MASConstraint *rightBtnWidthConstraint;

@property (nonatomic, assign) JLNewAuctionArtDetailBottomViewStatus status;

@end

@implementation JLNewAuctionArtDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JL_color_white_ffffff;
        
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.shadowColor = [UIColor colorWithHexString:@"#404040" alpha:0.19].CGColor;
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 5.0f;
}

- (void)setupUI {
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.backgroundColor = JL_color_red_D70000;
    [_rightBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = kFontPingFangSCRegular(15);
    _rightBtn.layer.cornerRadius = 17;
    _rightBtn.layer.masksToBounds = YES;
    [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self).offset(-(KTouch_Responder_Height / 2));
        make.height.mas_equalTo(@34);
        self.rightBtnWidthConstraint = make.width.mas_equalTo(@137);
    }];
    
    _leftBgView = [[UIView alloc] init];
    [self addSubview:_leftBgView];
    [_leftBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.bottom.equalTo(self).offset(-KTouch_Responder_Height);
        make.right.equalTo(self.rightBtn.mas_left);
    }];
    
    _likeBtn = [[UIButton alloc] init];
    [_likeBtn setTitle:@"0喜欢" forState:UIControlStateNormal];
    [_likeBtn setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
    _likeBtn.titleLabel.font = kFontPingFangSCRegular(10.0f);
    [_likeBtn setImage:[UIImage imageNamed:@"icon_product_like"] forState:UIControlStateNormal];
    [_likeBtn setImagePosition:LXMImagePositionTop spacing:7];
    [_likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_leftBgView addSubview:_likeBtn];

    _treadBtn = [[UIButton alloc] init];
    [_treadBtn setTitle:@"0踩" forState:UIControlStateNormal];
    [_treadBtn setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
    _treadBtn.titleLabel.font = kFontPingFangSCRegular(10.0f);
    [_treadBtn setImage:[UIImage imageNamed:@"icon_product_dislike"] forState:UIControlStateNormal];
    [_treadBtn setImagePosition:LXMImagePositionTop spacing:7];
    [_treadBtn addTarget:self action:@selector(treadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_leftBgView addSubview:_treadBtn];
    
    _collectBtn = [[UIButton alloc] init];
    [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [_collectBtn setTitleColor:JL_color_gray_101010 forState:UIControlStateNormal];
    _collectBtn.titleLabel.font = kFontPingFangSCRegular(10.0f);
    [_collectBtn setImage:[UIImage imageNamed:@"icon_product_collect"] forState:UIControlStateNormal];
    [_collectBtn setImagePosition:LXMImagePositionTop spacing:7];
    [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_leftBgView addSubview:_collectBtn];
    
    NSArray *arr = @[_likeBtn, _treadBtn, _collectBtn];
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:10 tailSpacing:30];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.leftBgView);
    }];
}

#pragma mark - event response
- (void)likeBtnClick: (UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(like:artId:)]) {
        [_delegate like:!_auctionsData.art.liked_by_me artId:_auctionsData.art.ID];
    }
}

- (void)treadBtnClick: (UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(tread:artId:)]) {
        [_delegate tread:!_auctionsData.art.disliked_by_me artId:_auctionsData.art.ID];
    }
}

- (void)collectBtnClick: (UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(collected:artId:)]) {
        [_delegate collected:!_auctionsData.art.favorite_by_me artId:_auctionsData.art.ID];
    }
}

- (void)rightBtnClick: (UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(doneStatus:)]) {
        [_delegate doneStatus:_status];
    }
}

#pragma mark - setters and getters
- (void)setAuctionsData:(Model_auctions_Data *)auctionsData {
    _auctionsData = auctionsData;
    
    [_likeBtn setTitle:[NSString stringWithFormat:@"%ld喜欢", _auctionsData.art.liked_count] forState:UIControlStateNormal];
    if (_auctionsData.art.liked_by_me) {
        [_likeBtn setImage:[UIImage imageNamed:@"icon_product_like_selected"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_product_like_selected"] forState:UIControlStateHighlighted];
    }else {
        [_likeBtn setImage:[UIImage imageNamed:@"icon_product_like"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"icon_product_like"] forState:UIControlStateHighlighted];
    }
    
    [_treadBtn setTitle:[NSString stringWithFormat:@"%ld踩", _auctionsData.art.dislike_count] forState:UIControlStateNormal];
    if (_auctionsData.art.disliked_by_me) {
        [_treadBtn setImage:[UIImage imageNamed:@"icon_product_dislike_selected"] forState:UIControlStateNormal];
        [_treadBtn setImage:[UIImage imageNamed:@"icon_product_dislike_selected"] forState:UIControlStateHighlighted];
    }else {
        [_treadBtn setImage:[UIImage imageNamed:@"icon_product_dislike"] forState:UIControlStateNormal];
        [_treadBtn setImage:[UIImage imageNamed:@"icon_product_dislike"] forState:UIControlStateHighlighted];
    }

    if (_auctionsData.art.favorite_by_me) {
        [_collectBtn setImage:[UIImage imageNamed:@"icon_product_collect_selected"] forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"icon_product_collect_selected"] forState:UIControlStateHighlighted];
    }else {
        [_collectBtn setImage:[UIImage imageNamed:@"icon_product_collect"] forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"icon_product_collect"] forState:UIControlStateHighlighted];
    }
    
    NSString *statusTitle = @"";
    if (_auctionsData.is_owner) {
        _status = JLNewAuctionArtDetailBottomViewStatusCancelAuction;
        statusTitle = @"取消拍卖";
        
        if (_auctionsData.can_cancel &&
            _auctionsData.server_timestamp.integerValue < _auctionsData.end_time.integerValue) {
            _rightBtn.userInteractionEnabled = YES;
            _rightBtn.backgroundColor = JL_color_red_D70000;
        }else {
            _rightBtn.userInteractionEnabled = NO;
            _rightBtn.backgroundColor = JL_color_gray_DDDDDD;
        }
    }else {
        if (_auctionsData.server_timestamp.integerValue < _auctionsData.start_time.integerValue) {
            _status = JLNewAuctionArtDetailBottomViewStatusNotStarted;
            // 未开始
            statusTitle = @"未开始";
            _rightBtn.userInteractionEnabled = NO;
            _rightBtn.backgroundColor = JL_color_gray_DDDDDD;
        }else {
            // 是否已缴纳保证金
            if (!_auctionsData.deposit_paid) {
                _status = JLNewAuctionArtDetailBottomViewStatusPayEarnestMoney;
                statusTitle = [NSString stringWithFormat:@"缴纳保证金 ￥%@", _auctionsData.deposit_amount];
            }else {
                _status = JLNewAuctionArtDetailBottomViewStatusOffer;
                statusTitle = @"出价";
            }
            // 是否中标
            if (_auctionsData.buyer && [auctionsData.buyer.ID isEqualToString:[AppSingleton sharedAppSingleton].userBody.ID]) {
                _status = JLNewAuctionArtDetailBottomViewStatusWinBidding;
                statusTitle = @"中标去支付";
                if (_auctionsData.buyer_paid) {
                    // 已支付
                    _status = JLNewAuctionArtDetailBottomViewStatusFinished;
                    statusTitle = @"中标已支付";
                    _rightBtn.userInteractionEnabled = NO;
                    _rightBtn.backgroundColor = JL_color_gray_DDDDDD;
                }else {
                    // 未支付
                    if (_auctionsData.server_timestamp.integerValue >= (_auctionsData.end_time.integerValue + _auctionsData.pay_timeout.integerValue)) {
                        // 已超时
                        _status = JLNewAuctionArtDetailBottomViewStatusFinished;
                        statusTitle = @"超时未支付";
                        _rightBtn.userInteractionEnabled = NO;
                        _rightBtn.backgroundColor = JL_color_gray_DDDDDD;
                    }
                }
            }else {
                // 是否已结束
                if (_auctionsData.server_timestamp.integerValue >= _auctionsData.end_time.integerValue) {
                    _status = JLNewAuctionArtDetailBottomViewStatusFinished;
                    statusTitle = @"已结束";
                    _rightBtn.userInteractionEnabled = NO;
                    _rightBtn.backgroundColor = JL_color_gray_DDDDDD;
                }
            }
        }
    }
        
    [_rightBtn setTitle:statusTitle forState:UIControlStateNormal];
    CGFloat statusWidth = [JLTool getAdaptionSizeWithText:statusTitle labelHeight:20 font:kFontPingFangSCRegular(15)].width + 30;
    if (statusWidth < 137) {
        statusWidth = 137;
    }
    [_rightBtnWidthConstraint uninstall];
    [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        self.rightBtnWidthConstraint = make.width.mas_equalTo(@(statusWidth));
    }];
}

@end
