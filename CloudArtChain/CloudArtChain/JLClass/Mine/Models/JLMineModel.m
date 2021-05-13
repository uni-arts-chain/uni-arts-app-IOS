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
#pragma mark /v2/arts/upload_live2d_file 上传live2d zip文件
@implementation Model_arts_upload_live2d_file_Data
@end
@implementation Model_arts_upload_live2d_file_Req
@end
@implementation Model_arts_upload_live2d_file_Rsp
- (NSString *)interfacePath {
    return @"arts/upload_live2d_file";
}
@end
//////////////////////////////////////////////////////////////////////////
@implementation Model_arts_sold_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
#pragma mark 个人艺术作品 - 卖出 /arts/sold
@implementation Model_arts_sold_Req
@end
@implementation Model_arts_sold_Rsp
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 个人艺术作品 - 买入 /arts/bought
@implementation Model_arts_bought_Req
@end
@implementation Model_arts_bought_Rsp
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 请求出售转账地址 art_orders/lock_account_id
@implementation Model_art_orders_lock_account_id_Req
@end
@implementation Model_art_orders_lock_account_id_Rsp
- (NSString *)interfacePath {
    return @"art_orders/lock_account_id";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 出售作品 art_orders
@implementation Model_art_orders_Req
@end
@implementation Model_art_orders_Rsp
- (NSString *)interfacePath {
    return @"art_orders";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 提交订单 art_trades
@implementation Model_art_trades_Req : Model_Req
@end
@implementation Model_art_trades_Rsp
- (NSString *)interfacePath {
    return @"art_trades";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/art_orders/cancel 作品下架
@implementation Model_art_orders_cancel_Req
@end
@implementation Model_art_orders_cancel_Rsp
- (NSString *)interfacePath {
    return @"art_orders/cancel";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/feedbacks 提交反馈
@implementation Model_feedbacks_Req
@end
@implementation Model_feedbacks_Rsp
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/lotteries/get_reward 领奖
@implementation Model_lotteries_get_reward_Req
@end
@implementation Model_lotteries_get_reward_Rsp
- (NSString *)interfacePath {
    return @"lotteries/get_reward";
}
@end
//////////////////////////////////////////////////////////////////////////
