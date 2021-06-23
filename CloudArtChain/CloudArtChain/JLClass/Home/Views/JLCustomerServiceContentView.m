//
//  JLCustomerServiceContentView.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLCustomerServiceContentView.h"
#import "JLCustomerServiceHeaderView.h"
#import "JLCustomerServiceCell.h"

@interface JLCustomerServiceContentView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *titleArray;

@property (nonatomic, copy) NSArray *imageArray;

@property (nonatomic, copy) NSArray<NSArray *> *contactArray;

@end

@implementation JLCustomerServiceContentView

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
    _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage getImageWithColor:JL_color_navBgColor width:1 height:1]];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:_tableView];
    
    [_tableView registerClass:JLCustomerServiceCell.class forCellReuseIdentifier:@"cell"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, 37)];
    titleLabel.text = @"请通过以下方式联系我们：";
    titleLabel.textColor = JL_color_white_ffffff;
    titleLabel.font = kFontPingFangSCMedium(13);
    titleLabel.jl_contentInsets = UIEdgeInsetsMake(12, 12, 12, 0);
    
    _tableView.tableHeaderView = titleLabel;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contactArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JLCustomerServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[JLCustomerServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.desc = self.contactArray[indexPath.section][indexPath.row];
    if (indexPath.row == self.contactArray[indexPath.section].count - 1) {
        cell.isCorner = YES;
    }else {
        cell.isCorner = NO;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JLCustomerServiceHeaderView *headerView = [[JLCustomerServiceHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, 46)];
    headerView.title = self.titleArray[section];
    headerView.imageName = self.imageArray[section];
    headerView.section = section;
    if (self.contactArray[section].count == 0) {
        headerView.rectCorner = UIRectCornerAllCorners;
    }else {
        headerView.rectCorner = UIRectCornerTopLeft|UIRectCornerTopRight;
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 37;
}

#pragma mark - setters and getters
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"微信号",@"QQ号",@"邮箱"];
    }
    return _titleArray;
}

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = @[@"customer_service_wechat_icon",
                        @"customer_service_qq_icon",
                        @"customer_service_email_icon"];
    }
    return _imageArray;
}

- (NSArray<NSArray *> *)contactArray {
    if (!_contactArray) {
        _contactArray = @[@[],
                          @[],
                          @[]];
    }
    return _contactArray;
}

@end
