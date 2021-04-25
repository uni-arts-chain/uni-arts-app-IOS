//
//  JLBindPhoneWithoutPwdViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/19.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLBindPhoneWithoutPwdViewController : JLBaseViewController
@property (nonatomic, copy) void(^bindPhoneSuccessBlock)(NSString *bindPhone);
@end

NS_ASSUME_NONNULL_END
