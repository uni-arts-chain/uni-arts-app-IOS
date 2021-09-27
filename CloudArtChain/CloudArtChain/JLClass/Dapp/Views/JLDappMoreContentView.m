//
//  JLDappMoreContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/27.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappMoreContentView.h"
#import "JLDappMoreCell.h"

@interface JLDappMoreContentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JLDappMoreContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    _tableView.backgroundColor = JL_color_white_ffffff;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:JLDappMoreCell.class forCellReuseIdentifier:NSStringFromClass(JLDappMoreCell.class)];
    [self addSubview:_tableView];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JLDappMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JLDappMoreCell.class) forIndexPath:indexPath];
    if (!cell) {
        cell = [[JLDappMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(JLDappMoreCell.class)];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(lookDappWithUrl:)]) {
        [_delegate lookDappWithUrl:@"xx"];
    }
}

#pragma mark - setters and getters
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [_tableView reloadData];
}

@end
