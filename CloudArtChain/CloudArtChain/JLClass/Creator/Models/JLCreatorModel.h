//
//  JLCreatorModel.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/3/2.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLCreatorModel : NSObject
@end

//////////////////////////////////////////////////////////////////////////
#pragma mark /members/:id/arts 用户的作品
@interface Model_members_arts_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
/** 作者id */
@property (nonatomic, strong) NSString *author_id;
@end
@interface Model_members_arts_Rsp : Model_Rsp_V1
@property (nonatomic, strong) Model_members_arts_Req *request;
@property (nonatomic, strong) NSArray<Model_art_Detail_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /members/:id/follow 关注
@interface Model_members_follow_Req : Model_Req
@property (nonatomic, strong) NSString *author_id;
@end
@interface Model_members_follow_Rsp : Model_Rsp_V1
@property (nonatomic, strong) Model_members_follow_Req *request;
@property (nonatomic, strong) Model_art_author_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /members/:id/unfollow 取消关注
@interface Model_members_unfollow_Req : Model_Req
@property (nonatomic, strong) NSString *author_id;
@end
@interface Model_members_unfollow_Rsp : Model_Rsp_V1
@property (nonatomic, strong) Model_members_unfollow_Req *request;
@property (nonatomic, strong) Model_art_author_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
