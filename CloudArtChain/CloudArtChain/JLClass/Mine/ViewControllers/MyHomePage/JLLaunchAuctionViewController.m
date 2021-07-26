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
@end

@implementation JLLaunchAuctionViewController

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
        [_startPriceView setDefaultContent:self.artDetailData.price];
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
            if (![NSString stringIsEmpty:weakSelf.startTimeView.inputContent]) {
                datePicker.maxLimitDate = [NSDate date:weakSelf.startTimeView.inputContent format:@"yyyy-MM-dd HH:mm:ss"];
            }
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
    if ([NSString stringIsEmpty:self.startTimeView.inputContent] || [NSString stringIsEmpty:self.incrementView.inputContent]) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"请将数据填写完整" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *startTime = [formatter dateFromString:self.startTimeView.inputContent];
    NSDate *finishTime = [formatter dateFromString:self.finishTimeView.inputContent];
    NSTimeInterval auctionStartTimeInterval = [startTime timeIntervalSince1970];
    NSTimeInterval auctionEndTimeInterval = [finishTime timeIntervalSince1970];
    if ((auctionEndTimeInterval - auctionStartTimeInterval) / 3600 < 24) {
        [[JLLoading sharedLoading] showMBFailedTipMessage:@"结束时间不能小于24小时" hideTime:KToastDismissDelayTimeInterval];
        return;
    }
    
    [self launchAuction];
}

- (void)launchAuction {
    WS(weakSelf)
    [self.view endEditing:YES];
    if (self.blockNumber > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *startTime = [formatter dateFromString:weakSelf.startTimeView.inputContent];
        NSDate *finishTime = [formatter dateFromString:weakSelf.finishTimeView.inputContent];
        NSTimeInterval auctionStartTimeInterval = [startTime timeIntervalSince1970];
        NSTimeInterval auctionEndTimeInterval = [finishTime timeIntervalSince1970];
        UInt32 auctionStartTimeBlockNumber = (auctionStartTimeInterval - self.currentInterval) / 6 + self.blockNumber;
        UInt32 auctionEndTimeBlockNumber = (auctionEndTimeInterval - self.currentInterval) / 6 + self.blockNumber;
        
        [[JLLoading sharedLoading] showRefreshLoadingOnView:nil];
        // 发起拍卖
        [[JLViewControllerTool appDelegate].walletTool createAuctionCallWithCollectionId:weakSelf.artDetailData.collection_id.intValue itemId:weakSelf.artDetailData.item_id.intValue price:weakSelf.startPriceView.inputContent increment:weakSelf.incrementView.inputContent startTime:auctionStartTimeBlockNumber endTime:auctionEndTimeBlockNumber block:^(BOOL success, NSString * _Nullable message) {
            if (success) {
                [[JLViewControllerTool appDelegate].walletTool authorizeWithAnimated:YES cancellable:YES with:^(BOOL success) {
                    if (success) {
                        [[JLViewControllerTool appDelegate].walletTool createAuctionConfirmWithCallbackBlock:^(BOOL success, NSString * _Nullable message) {
                            [[JLLoading sharedLoading] hideLoading];
                            if (success) {
                                if (weakSelf.createAuctionBlock) {
                                    weakSelf.createAuctionBlock(@(auctionStartTimeBlockNumber).stringValue, @(auctionEndTimeBlockNumber).stringValue);
                                }
                            } else {
                                [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
                            }
                        }];
                    } else {
                        [[JLLoading sharedLoading] hideLoading];
                    }
                }];
            } else {
                [[JLLoading sharedLoading] hideLoading];
                [[JLLoading sharedLoading] showMBFailedTipMessage:message hideTime:KToastDismissDelayTimeInterval];
            }
        }];
    }
}
@end
