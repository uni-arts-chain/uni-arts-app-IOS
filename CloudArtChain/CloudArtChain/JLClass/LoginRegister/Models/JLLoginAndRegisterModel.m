//
//  JLLoginAndRegisterModel.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/25.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLLoginAndRegisterModel.h"

@implementation JLLoginAndRegisterModel
@end

// ==========================================================
#pragma mark /members/user_address_login 用户地址登录
@implementation Model_members_user_address_login_Req

@end

@implementation Model_members_user_address_login_Rsp
- (NSString *)interfacePath {
    return @"/members/user_address_login";
}
@end

// ==========================================================
#pragma mark 用户信息(持久化登录) /members/user_info
@implementation Model_members_user_info_Req
@end
@implementation Model_members_user_info_Rsp
- (NSString *)interfacePath {
    return @"members/user_info";
}
@end
// ==========================================================