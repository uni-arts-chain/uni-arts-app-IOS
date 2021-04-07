//
//  JLLaunchAuctionTimeInputView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/7.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLLaunchAuctionTimeInputView : JLBaseView
@property (nonatomic, strong) NSString *inputContent;
@property (nonatomic, copy) void(^selectBlock)(NSDate *selectDate);
- (instancetype)initWithTitle:(NSString *)title defaultContent:(NSString *)defaultContent;
- (void)refreshSelectedDate:(NSDate *)selectedDate;
@end

NS_ASSUME_NONNULL_END
