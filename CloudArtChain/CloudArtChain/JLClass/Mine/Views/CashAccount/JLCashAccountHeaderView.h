//
//  JLCashAccountHeaderView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WithdrawBlock)(void);

@interface JLCashAccountHeaderView : UIView

@property (nonatomic, copy) WithdrawBlock withdrawBlock;

@property (nonatomic, strong) Model_account_Data *accountData;

@end

NS_ASSUME_NONNULL_END
