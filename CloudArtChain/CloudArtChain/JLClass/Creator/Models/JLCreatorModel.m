//
//  JLCreatorModel.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/3/2.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLCreatorModel.h"

@implementation JLCreatorModel
@end

//////////////////////////////////////////////////////////////////////////
#pragma mark /members/:id/arts 用户的作品
@implementation Model_members_arts_Req
@end
@implementation Model_members_arts_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"members/%@/arts", self.request.author_id];
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /members/:id/follow 关注
@implementation Model_members_follow_Req
@end
@implementation Model_members_follow_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"members/%@/follow", self.request.author_id];
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /members/:id/unfollow 取消关注
@implementation Model_members_unfollow_Req
@end
@implementation Model_members_unfollow_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"members/%@/unfollow", self.request.author_id];
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /members/artist_topic 置顶艺术家
@implementation Model_members_artist_topic_Req
@end
@implementation Model_members_artist_topic_Rsp
- (NSString *)interfacePath {
    return @"members/artist_topic";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /members/pre_artist_topic 往期艺术家推荐
@implementation Model_members_pre_artist_topic_Data
@end
@implementation Model_members_pre_artist_topic_Req
@end
@implementation Model_members_pre_artist_topic_Rsp
- (NSString *)interfacePath {
    return @"members/pre_artist_topic";
}
@end
//////////////////////////////////////////////////////////////////////////
