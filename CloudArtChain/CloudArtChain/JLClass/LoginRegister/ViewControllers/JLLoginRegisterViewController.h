//
//  JLLoginRegisterViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLLoginSuccessBlock)(void);
typedef void(^JLLoginFailureBlock)(void);
typedef void(^JLLoginBackBlock)(void);

@interface JLLoginRegisterViewController : JLBaseViewController
@property (nonatomic, copy) JLLoginSuccessBlock successBlock;
@property (nonatomic, copy) JLLoginFailureBlock failureBlock;
@property (nonatomic, copy) JLLoginBackBlock backClickBlock;
@end

NS_ASSUME_NONNULL_END
