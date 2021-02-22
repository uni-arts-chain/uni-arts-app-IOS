//
//  JLSignTradeView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/2.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLSignTradeView.h"
#import "JLPageMenuView.h"
#import "JLChainQuerySignTableViewCell.h"
#import "JLChainQueryTradeView.h"

@interface JLSignTradeView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) JLPageMenuView *pageMenuView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *signTableView;
@property (nonatomic, strong) JLChainQueryTradeView *tradeView;
@end

@implementation JLSignTradeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.pageMenuView];
    [self.pageMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(65.0f);
    }];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pageMenuView.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
    [self.scrollView addSubview:self.signTableView];
    [self.scrollView addSubview:self.tradeView];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, self.signTableView.frameBottom + 20.0f);
}

- (JLPageMenuView *)pageMenuView {
    if (!_pageMenuView) {
        WS(weakSelf)
        _pageMenuView = [[JLPageMenuView alloc] initWithMenus:@[@"签名信息", @"转让信息"] itemMargin:20.0f];
        _pageMenuView.indexChangedBlock = ^(NSInteger index) {
            [weakSelf.scrollView setContentOffset:CGPointMake(index * kScreenWidth, 0.0f) animated:YES];
        };
    }
    return _pageMenuView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = JL_color_white_ffffff;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

- (JLChainQueryTradeView *)tradeView {
    if (!_tradeView) {
        _tradeView = [[JLChainQueryTradeView alloc] initWithFrame:CGRectMake(kScreenWidth + 15.0f, 0.0f, kScreenWidth - 15.0f * 2, 159.0f)];
        ViewBorderRadius(_tradeView, 5.0f, 0, JL_color_clear);
    }
    return _tradeView;
}

- (UITableView *)signTableView {
    if (!_signTableView) {
        _signTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 74.0f * 3) style:UITableViewStylePlain];
        _signTableView.dataSource = self;
        _signTableView.delegate = self;
        _signTableView.scrollEnabled = NO;
        [_signTableView registerClass:[JLChainQuerySignTableViewCell class] forCellReuseIdentifier:@"JLChainQuerySignTableViewCell"];
    }
    return _signTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLChainQuerySignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLChainQuerySignTableViewCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74.0f;
}

@end
