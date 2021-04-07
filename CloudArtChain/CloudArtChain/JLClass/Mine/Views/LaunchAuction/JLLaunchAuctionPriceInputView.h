//
//  JLLaunchAuctionPriceInputView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/7.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLLaunchAuctionPriceInputView : JLBaseView
@property (nonatomic, strong) NSString *inputContent;
- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType;
- (void)setDefaultContent:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
