//
//  JLWalletPwdInputView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/4.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLWalletPwdInputView : JLBaseView
@property (nonatomic, copy) void(^confirmBlock)(void);
@end

NS_ASSUME_NONNULL_END
