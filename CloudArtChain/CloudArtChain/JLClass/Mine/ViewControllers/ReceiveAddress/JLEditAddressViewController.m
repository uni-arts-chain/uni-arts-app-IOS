//
//  JLEditAddressViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLEditAddressViewController.h"

#import "JLReceiveAddressInputTableViewCell.h"
#import "JLReceiveAddressSelectTableViewCell.h"
#import "JLReceiveAddressSwitchTableViewCell.h"

@interface JLEditAddressViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableFooterView;
@end

@implementation JLEditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.editAdressType == JLEidtAddressTypeEdit) {
        self.navigationItem.title = @"编辑地址";
        [self addRightBarButton];
    } else {
        self.navigationItem.title = @"添加地址";
    }
    [self addBackItem];
    [self createSubViews];
}

- (void)addRightBarButton {
    NSString *title = @"删除地址";
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(deleteAddressClick)];
    NSDictionary *dic = @{NSForegroundColorAttributeName: JL_color_gray_212121, NSFontAttributeName: kFontPingFangSCRegular(14.0f)};
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)deleteAddressClick {
    
}

- (void)createSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.mas_equalTo(-KTouch_Responder_Height);
    }];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JL_color_white_ffffff;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = self.tableFooterView;
        [_tableView registerClass:[JLReceiveAddressInputTableViewCell class] forCellReuseIdentifier:@"JLReceiveAddressInputTableViewCell"];
        [_tableView registerClass:[JLReceiveAddressSelectTableViewCell class] forCellReuseIdentifier:@"JLReceiveAddressSelectTableViewCell"];
        [_tableView registerClass:[JLReceiveAddressSwitchTableViewCell class] forCellReuseIdentifier:@"JLReceiveAddressSwitchTableViewCell"];
    }
    return _tableView;
}

- (UIView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46.0f)];
        
        UIButton *saveButton = [JLUIFactory buttonInitTitle:@"保存" titleColor:JL_color_white_ffffff backgroundColor:JL_color_blue_50C3FF font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(saveButtonClick)];
        ViewBorderRadius(saveButton, 23.0f, 0.0f, JL_color_clear);
        [_tableFooterView addSubview:saveButton];
        [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.0f);
            make.right.mas_equalTo(-15.0f);
            make.top.bottom.equalTo(_tableFooterView);
        }];
    }
    return _tableFooterView;
}

- (void)saveButtonClick {
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            JLReceiveAddressSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLReceiveAddressSelectTableViewCell" forIndexPath:indexPath];
            [cell setTitle:@"地区" placeholder:@"请选择地区"];
            return cell;
        } else {
            JLReceiveAddressInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLReceiveAddressInputTableViewCell" forIndexPath:indexPath];
            switch (indexPath.row) {
                case 0:
                    [cell setTitle:@"姓名" placeholder:@"请输入联系人"];
                    break;
                case 1:
                    [cell setTitle:@"电话" placeholder:@"请输入联系电话"];
                    break;
                case 3:
                    [cell setTitle:@"详细地址" placeholder:@"请填写详细地址，不少于5个字"];
                    break;
                default:
                    break;
            }
            return cell;
        }
    } else {
        JLReceiveAddressSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLReceiveAddressSwitchTableViewCell" forIndexPath:indexPath];
        [cell setTitle:@"设为默认地址"];
        cell.switchBlock = ^(BOOL isOn) {
            
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

@end
