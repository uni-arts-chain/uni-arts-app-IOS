//
//  JLAuctionOrderDetailContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/7/20.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLAuctionOrderDetailContentView.h"
#import "JLAuctionOrderDetailContentInfoView.h"
#import "JLAuctionOrderDetailOrderInfoView.h"

@interface JLAuctionOrderDetailContentView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) JLAuctionOrderDetailContentInfoView *artInfoView;

@property (nonatomic, strong) JLAuctionOrderDetailOrderInfoView *orderInfoView;

@end

@implementation JLAuctionOrderDetailContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = JL_color_white_ffffff;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = YES;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    _bgView = [[UIView alloc] init];
    [_scrollView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.text = @"交易成功";
    _statusLabel.textColor = JL_color_gray_212121;
    _statusLabel.font = kFontPingFangSCMedium(21);
    [_bgView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(12);
        make.left.equalTo(self.bgView).offset(15);
    }];
    
    _artInfoView = [[JLAuctionOrderDetailContentInfoView alloc] init];
    [_bgView addSubview:_artInfoView];
    [_artInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(22);
    }];
    
    _orderInfoView = [[JLAuctionOrderDetailOrderInfoView alloc] init];
    [_bgView addSubview:_orderInfoView];
    [_orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.top.equalTo(self.artInfoView.mas_bottom).offset(17);
        make.bottom.equalTo(self.bgView).offset(-20);
    }];
}

- (void)setOrderData:(Model_arts_sold_Data *)orderData {
    _orderData = orderData;
    
    _artInfoView.type = _type;
    _artInfoView.auctionsData = _orderData.auction;
    _orderInfoView.orderData = _orderData;
}

- (void)dealloc
{
    NSLog(@"释放了: %@", self.class);
}

@end
