//
//  JLMineModel.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/3/1.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLMineModel.h"

@implementation JLMineModel
@end

//////////////////////////////////////////////////////////////////////////
#pragma mark /members/favorate_arts 作品收藏
@implementation Model_members_favorate_arts_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_members_favorate_arts_Req
@end
@implementation Model_members_favorate_arts_Rsp
- (NSString *)interfacePath {
    return @"members/favorate_arts";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /members/followings 关注列表
@implementation Model_members_followings_Req
@end
@implementation Model_members_followings_Rsp
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /members/followers 粉丝列表
@implementation Model_members_followers_Req
@end
@implementation Model_members_followers_Rsp
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/mine 个人艺术作品
@implementation Model_arts_mine_Req
@end
@implementation Model_arts_mine_Rsp
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts 上传艺术品
@implementation Model_arts_Req

@end
@implementation Model_arts_Rsp

@end
//////////////////////////////////////////////////////////////////////////
