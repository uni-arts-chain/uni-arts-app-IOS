//
//  JLCashAccountContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLCashAccountContentViewDelegate <NSObject>

- (void)refreshDatas;

- (void)loadMoreDatas;

/// 提现
- (void)withdraw;

@end

@interface JLCashAccountContentView : UIView

@property (nonatomic, weak) id<JLCashAccountContentViewDelegate> delegate;

@property (nonatomic, strong) Model_account_Data *accountData;

- (void)setHistoriesArray:(NSArray *)historiesArray page: (NSInteger)page pageSize: (NSInteger)pageSize;

@end

NS_ASSUME_NONNULL_END
