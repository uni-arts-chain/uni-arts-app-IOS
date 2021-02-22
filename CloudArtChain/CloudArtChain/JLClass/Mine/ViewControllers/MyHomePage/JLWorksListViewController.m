//
//  JLWorksListViewController.m
//  CloudArtChain
//
//  Created by 花田半亩 on 2020/9/6.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLWorksListViewController.h"

#import "JLWorkListBaseTableViewCell.h"
#import "JLWorkListListedCell.h"
#import "JLWorkListNotListCell.h"
#import "JLWorkListSelfBuyCell.h"

@interface JLWorksListViewController ()<UITableViewDelegate,UITableViewDataSource,JLPagetableViewRequestDelegate>

@end

@implementation JLWorksListViewController

-  (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

//这里是必须存在的方法 传递tableView的偏移量
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView.scrollViewDidScroll) {
        self.tableView.scrollViewDidScroll(self.tableView);
    }
}

- (void)JLPagetableView:(JLPagetableView *)JLPagetableView requestFailed:(NSError *)error {
    
}

- (void)JLPagetableView:(JLPagetableView *)JLPagetableView isPullDown:(BOOL)PullDown SuccessData:(id)SuccessData {
    //处理返回的SuccessData 数据之后刷新table
    [self.tableView reloadData];
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.workListType == JLWorkListTypeListed) {
        JLWorkListListedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLWorkListListedCell" forIndexPath:indexPath];
        return cell;
    } else if (self.workListType == JLWorkListTypeNotList) {
        JLWorkListNotListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLWorkListNotListCell" forIndexPath:indexPath];
        return cell;
    }
    JLWorkListBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLWorkListBaseTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (JLPagetableView *)tableView {
    if (!_tableView) {
        _tableView = [[JLPagetableView alloc]initWithFrame:CGRectZero];
        _tableView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height - 40.0f - KStatusBar_Navigation_Height - 47.0f - KTouch_Responder_Height);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.RequestDelegate = self;
        //table是否有刷新
        _tableView.isHasHeaderRefresh = NO;
        _tableView.emptyView.hintText = @"暂无数据";
        _tableView.emptyView.hintTextFont = kFontPingFangSCRegular(15.0f);
        _tableView.emptyView.hintTextColor = JL_color_gray_BBBBBB;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JLWorkListBaseTableViewCell class] forCellReuseIdentifier:@"JLWorkListBaseTableViewCell"];
        [_tableView registerClass:[JLWorkListListedCell class] forCellReuseIdentifier:@"JLWorkListListedCell"];
        [_tableView registerClass:[JLWorkListNotListCell class] forCellReuseIdentifier:@"JLWorkListNotListCell"];
        [_tableView registerClass:[JLWorkListSelfBuyCell class] forCellReuseIdentifier:@"JLWorkListSelfBuyCell"];
    }
    return _tableView;
}
@end
