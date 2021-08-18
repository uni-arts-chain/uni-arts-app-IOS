//
//  JLLaunchAuctionViewController.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/7.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLLaunchAuctionViewController.h"

#import "JLLaunchAuctionNumView.h"
#import "JLLaunchAuctionPriceInputView.h"
#import "JLLaunchAuctionTimeInputView.h"
#import "JLDatePicker.h"

#import "NSDate+Extension.h"

#import "JLNewAuctionArtDetailViewController.h"

@interface JLLaunchAuctionViewController ()
@property (nonatomic, strong) JLLaunchAuctionNumView *numView;
@property (nonatomic, strong) JLLaunchAuctionPriceInputView *startPriceView;
@property (nonatomic, strong) JLLaunchAuctionPriceInputView *incrementView;
@property (nonatomic, strong) JLLaunchAuctionTimeInputView *startTimeView;
@property (nonatomic, strong) JLLaunchAuctionTimeInputView *finishTimeView;

@property (nonatomic, strong) UIButton *launchBtn;
@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, assign) UInt32 blockNumber;
@property (nonatomic, assign) NSTimeInterval currentInterval;
@property (nonatomic, assign) NSInteger auctionNum;

// 拍卖地址
@property (nonatomic, strong) NSString *lockAccountId;
@end

@implementation JLLaunchAuctionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestTransferAddress];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发起拍卖";
    [self addBackItem];
    
    self.auctionNum = 1;
    
    NSDate *currentDate = [NSDate date];
    NSString *currentMinuteString = [NSString stringWithFormat:@"%@:00", [currentDate dateWithCustomFormat:@"yyyy-MM-dd HH:mm"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.currentDate = [formatter dateFromString:currentMinuteString];
    [self createSubViews];
    
    [self getBlockNumber];
}

- (void)getBlockNumber {
    WS(weakSelf)
    NSDate *currentDate = [NSDate date];
    NSTimeInterval currentInterval = [currentDate timeIntervalSince1970];
    [[JLViewControllerTool appDelegate].walletTool getBlockWithBlockNumberBlock:^(UInt32 blockNumber) {
        weakSelf.blockNumber = blockNumber;
        weakSelf.currentInterval = currentInterval;
    }];
}

- (void)createSubViews {
    [self.view addSubview:self.numView];
    [self.view addSubview:self.startPriceView];
    [self.view addSubview:self.incrementView];
    [self.view addSubview:self.startTimeView];
    [self.view addSubview:self.finishTimeView];
    [self.view addSubview:self.launchBtn];
    
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50.0f);
    }];
    [self.startPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50.0f);
    }];
    [self.incrementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.startPriceView.mas_bottom);
        make.height.mas_equalTo(55.0f);
    }];
    [self.startTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.incrementView.mas_bottom);
        make.height.mas_equalTo(55.0f);
    }];
    [self.finishTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.startTimeView.mas_bottom);
        make.height.mas_equalTo(55.0f);
    }];
    [self.launchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(self.finishTimeView.mas_bottom).offset(40);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(46.0f);
    }];
}

- (JLLaunchAuctionNumView *)numView {
    if (!_numView) {
        WS(weakSelf)
        _numView = [[JLLaunchAuctionNumView alloc] init];
        if (self.artDetailData.collection_mode == 3) {
            _numView.maxNum = self.artDetailData.total_amount;
        }else {
            _numView.isShowStepper = NO;
        }
        _numView.changeNumBlock = ^(NSInteger num) {
            weakSelf.auctionNum = num;
        };
    }
    return _numView;
}

- (JLLaunchAuctionPriceInputView *)startPriceView {
    if (!_startPriceView) {
        _startPriceView = [[JLLaunchAuctionPriceInputView alloc] initWithTitle:@"起拍价" placeholder:@"请输入起拍价" keyboardType:UIKeyboardTypeDecimalPad];
        NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self.artDetailData.price];
        if ([price isLessThan:[NSDecimalNumber decimalNumberWithString:@"0.2"]]) {
            price = [NSDecimalNumber decimalNumberWithString:@"0.2"];
        }
        [_startPriceView setDefaultContent:price.stringValue];
    }
    return _startPriceView;
}

- (JLLaunchAuctionPriceInputView *)incrementView {
    if (!_incrementView) {
        _incrementView = [[JLLaunchAuctionPriceInputView alloc] initWithTitle:@"加价幅度" placeholder:@"请输入加价幅度" keyboardType:UIKeyboardTypeNumberPad];
    }
    return _incrementView;
}

- (JLLaunchAuctionTimeInputView *)startTimeView {
    if (!_startTimeView) {
        WS(weakSelf)
        _startTimeView = [[JLLaunchAuctionTimeInputView alloc] initWithTitle:@"开始时间" defaultContent:[self.currentDate dateWithCustomFormat:@"yyyy-MM-dd HH:mm:ss"]];
        _startTimeView.selectBlock = ^(NSDate * _Nonnull selectDate) {
            JLDatePicker *datePicker = [[JLDatePicker alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:selectDate == nil ? weakSelf.currentDate : selectDate CompleteBlock:^(NSDate *selectedDate) {
                [weakSelf.startTimeView refreshSelectedDate:selectedDate];
            }];
            datePicker.newStyle = YES;
            datePicker.minLimitDate = weakSelf.currentDate;
            [datePicker show];
        };
    }
    return _startTimeView;
}

- (JLLaunchAuctionTimeInputView *)finishTimeView {
    if (!_finishTimeView) {
        WS(weakSelf)
        NSDate *finishDate = [self.currentDate dateByAddingDays:1];
        _finishTimeView = [[JLLaunchAuctionTimeInputView alloc] initWithTitle:@"结束时间" defaultContent:[finishDate dateWithCustomFormat:@"yyyy-MM-dd HH:mm:ss"]];
        _finishTimeView.selectBlock = ^(NSDate * _Nonnull selectDate) {
            JLDatePicker *datePicker = [[JLDatePicker alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:selectDate == nil ? weakSelf.currentDate : selectDate CompleteBlock:^(NSDate *selectedDate) {
                [weakSelf.finishTimeView refreshSelectedDate:selectedDate];
            }];
            datePicker.newStyle = YES;
            datePicker.minLimitDate = weakSelf.currentDate;
//            if (![NSString stringIsEmpty:weakSelf.startTimeView.inputContent]) {
//                datePicker.minLimitDate = [[NSDate date:weakSelf.startTimeView.inputContent format:@"yyyy-MM-dd HH:mm:ss"] dateByAddingDays:1];
//                datePicker.maxLimitDate = [[NSDate date:weakSelf.startTimeView.inputContent format:@"yyyy-MM-dd HH:mm:ss"] dateByAddingDays:7];
//            }
            [datePicker show];
        };
    }
    return _finishTimeView;
}

- (UIButton *)launchBtn {
    if (!_launchBtn) {
        _launchBtn = [JLUIFactory buttonInitTitle:@"立即发起" titleColor:JL_color_white_ffffff backgroundColor:JL_color_gray_101010 font:kFontPingFangSCRegular(17.0f) addTarget:self action:@selector(launchBtnClick)];
        _launchBtn.contentEdgeInsets = UIEdgeInsetsZero;
        ViewBorderRadius(_launchBtn, 23.0f, 0.0f, JL_color_clear);
    }
    return _launchBtn;
}

- (void)launchBtnClick {
    if ([NSString stringIsEmpty:self.startTimeView.inputContent] ||
        [NSString stringIsEmpty:self.finishTimeView.inputContent] ||
        [NSString stringIsEmpty:self.incrementView.inputContent]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请将数据填写完整" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:self.startPriceView.inputContent];
    if ([price isLessThan:[NSDecimalNumber decimalNumberWithString:@"0.2"]]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"起拍价格不能低于￥0.2" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *startTime = [formatter dateFromString:self.startTimeView.inputContent];
    NSDate *finishTime = [formatter dateFromString:self.finishTimeView.inputContent];
    NSTimeInterval auctionStartTimeInterval = [startTime timeIntervalSince1970];
    NSTimeInterval auctionEndTimeInterval = [finishTime timeIntervalSince1970];
//    if ((auctionEndTimeInterval - auctionStartTimeInterval) / 3600 < 24) {
//        [[JLLoading sharedLoading] showMBFailedTipMessage:@"结束时间不能小于24小时" hideTime:KToastDismissDelayTimeInterval];
//        return;
//    }
    
    [self launchingAuction];
}

#pragma mark - 发起拍卖
- (void)launchingAuction {
    WS(weakSelf)
    [self.view endEditing:YES];

    if (![NSString stringIsEmpty:self.lockAccountId]) {
        [[JLViewControllerTool appDelegate].walletTool getAccountBalanceWithBalanceBlock:^(NSString * _Nonnull amount) {
            NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:amount];
            if ([amountNumber isGreaterThanZero]) {
                [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
                [[JLViewControllerTool appDelegate].walletTool productSellCallWithAccountId:weakSelf.lockAccountId collectionId:weakSelf.artDetailData.collection_id.intValue itemId:weakSelf.artDetailData.item_id.intValue value:@(weakSelf.auctionNum).stringValue block:^(BOOL success, NSString * _Nonnull message) {
                    [[JLLoading sharedLoading] hideLoading];
                    if (success) {
                        [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
                            if (success) {
                                [weakSelf postLaunchingAuctionToService];
                            }
                        }];
                    } else {
                        [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
                    }
                }];
            } else {
                UIAlertController *alertController = [UIAlertController alertShowWithTitle:@"提示" message:@"当前积分为0，无法进行操作\r\n（购买NFT卡片可获得积分）" confirm:@"确定"];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }
    
}

- (void)requestTransferAddress {
    WS(weakSelf)
    Model_auctions_lock_account_id_Req *request = [[Model_auctions_lock_account_id_Req alloc] init];
    Model_auctions_lock_account_id_Rsp *resonse = [[Model_auctions_lock_account_id_Rsp alloc] init];
    
    [JLNetHelper netRequestGetParameters:request respondParameters:resonse callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
        if (netIsWork) {
            weakSelf.lockAccountId = resonse.body[@"lock_account_id"];
            if ([weakSelf.lockAccountId hasPrefix:@"0x"]) {
                weakSelf.lockAccountId = [weakSelf.lockAccountId substringFromIndex:2];
            }
        }
    }];
}

- (void)postLaunchingAuctionToService {
    WS(weakSelf)
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *startTime = [formatter dateFromString:weakSelf.startTimeView.inputContent];
    NSDate *finishTime = [formatter dateFromString:weakSelf.finishTimeView.inputContent];
    NSTimeInterval auctionStartTimeInterval = [startTime timeIntervalSince1970];
    NSTimeInterval auctionEndTimeInterval = [finishTime timeIntervalSince1970];
    
    [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
    [[JLViewControllerTool appDelegate].walletTool productSellConfirmWithBlock:^(NSString * _Nullable transferSignedMessage) {
        if ([NSString stringIsEmpty:transferSignedMessage]) {
            [[JLLoading sharedLoading] hideLoading];
            [[JLLoading sharedLoading] showMBFailedTipMessage:@"签名错误" hideTime:KToastDismissDelayTimeInterval];
        } else {
            // 发送网络请求
            Model_auctions_Req *request = [[Model_auctions_Req alloc] init];
            request.art_id = weakSelf.artDetailData.ID;
            request.amount = @(weakSelf.auctionNum).stringValue;
            request.price = weakSelf.startPriceView.inputContent;
            request.price_increment = weakSelf.incrementView.inputContent;
            request.start_time = @(auctionStartTimeInterval).stringValue;
            request.end_time = @(auctionEndTimeInterval).stringValue;
            request.encrpt_extrinsic_message = transferSignedMessage;
            Model_auctions_Rsp *response = [[Model_auctions_Rsp alloc] init];
            [JLNetHelper netRequestPostParameters:request responseParameters:response callBack:^(BOOL netIsWork, NSString *errorStr, NSInteger errorCode) {
                [[JLLoading sharedLoading] hideLoading];
                if (netIsWork) {
                    NSLog(@"发起拍卖成功");
                    JLNewAuctionArtDetailViewController *vc = [[JLNewAuctionArtDetailViewController alloc] init];
                    vc.auctionsId = response.body.ID;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                } else {
                    [[JLLoading sharedLoading] showMBFailedTipMessage:errorStr hideTime:KToastDismissDelayTimeInterval];
                }
            }];
        }
    }];
}

@end
