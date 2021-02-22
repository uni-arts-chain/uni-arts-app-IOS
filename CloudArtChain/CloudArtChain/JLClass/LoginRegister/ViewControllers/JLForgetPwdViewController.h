//
//  JLForgetPwdViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLForgetPwdType) {
    JLForgetPwdTypeForget, /** 忘记密码 */
    JLForgetPwdTypeModify, /** 修改密码 */
};

@interface JLForgetPwdViewController : JLBaseViewController
@property (nonatomic, assign) JLForgetPwdType forgetPwdType;
@end

NS_ASSUME_NONNULL_END
