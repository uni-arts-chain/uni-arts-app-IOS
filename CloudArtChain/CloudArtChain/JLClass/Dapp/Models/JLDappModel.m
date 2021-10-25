//
//  JLDappModel.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/27.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappModel.h"

@implementation JLDappModel

@end
////////////////////////////////////entity(实体)//////////////////////////////////////
#pragma mark - dapp 信息
@implementation Model_dapp_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
#pragma mark - 链信息
@implementation Model_chain_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
#pragma mark - 链分类信息
@implementation Model_chain_category_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
#pragma mark - 最近使用dapp信息
@implementation Model_recently_dapp_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
#pragma mark - 收藏dapp信息
@implementation Model_favorite_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
#pragma mark - 链服务
@implementation Model_eth_rpc_server_data
+ (BOOL)supportsSecureCoding {
    return YES;
}
/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeInteger:self.chain_id forKey:@"chain_id"];
    [encoder encodeInteger:self.network_id forKey:@"network_id"];
    [encoder encodeObject:self.rpc_url forKey:@"rpc_url"];
}
/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.chain_id = [decoder decodeIntegerForKey:@"chain_id"];
        self.network_id = [decoder decodeIntegerForKey:@"network_id"];
        self.rpc_url = [decoder decodeObjectForKey:@"rpc_url"];
    }
    return self;
}
@end
@implementation Model_chain_server_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
////////////////////////////////////api(接口)//////////////////////////////////////
#pragma mark - /chains 链列表
@implementation Model_chains_Req
@end
@implementation Model_chains_Rsp
@end
#pragma mark - /v2/chains/{:id}/categories 链的分类
@implementation Model_chains_id_categories_Req
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_chains_id_categories_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"chains/%@/categories", _request.ID];
}
@end
#pragma mark - /v2/chains/{:id}/recommend_dapps 推荐的dapp列表
@implementation Model_chains_id_recommend_dapps_Req
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_chains_id_recommend_dapps_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"chains/%@/recommend_dapps", _request.ID];
}
@end
#pragma mark - /v2/dapps/category_dapps 链分类下的dapps
@implementation Model_dapps_category_dapps_Req
@end
@implementation Model_dapps_category_dapps_Rsp
- (NSString *)interfacePath {
    return @"dapps/category_dapps";
}
@end
#pragma mark - /v2/dapps/favorites 收藏的dapp
@implementation Model_dapps_favorites_Req
@end
@implementation Model_dapps_favorites_Rsp
@end
#pragma mark - /v2/member_recently_dapps 最近使用的dapp
@implementation Model_member_recently_dapps_Req
@end
@implementation Model_member_recently_dapps_Rsp
- (NSString *)interfacePath {
    return @"member_recently_dapps";
}
@end
#pragma mark - /v2/dapps/{:id}/favorite 收藏dapp
@implementation Model_dapps_id_favorite_Req
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_dapps_id_favorite_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"dapps/%@/favorite", _request.ID];
}
@end
#pragma mark - /v2/dapps/{:id}/unfavorite 取消收藏dapp
@implementation Model_dapps_id_unfavorite_Req
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_dapps_id_unfavorite_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"dapps/%@/unfavorite", _request.ID];
}
@end
#pragma mark - ​/v2​/dapps​/search 搜索dapp
@implementation Model_dapps_search_Req
@end
@implementation Model_dapps_search_Rsp
@end
#pragma mark - ​/v2​/dapps/hot_search_dapps 热门搜索dapp
@implementation Model_dapps_hot_search_dapps_Req
@end
@implementation Model_dapps_hot_search_dapps_Rsp
- (NSString *)interfacePath {
    return @"dapps/hot_search_dapps";
}
@end
#pragma mark - /v2/member_recently_dapps 上传最近使用的dapp(post)
@implementation Model_member_recently_dapp_Req
@end
@implementation Model_member_recently_dapp_Rsp
- (NSString *)interfacePath {
    return @"member_recently_dapps";
}
@end
#pragma mark - v2/chains/{id:}/networks
@implementation Model_chain_id_networks_Req
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_chain_id_networks_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"chains/%@/networks", _request.ID];
}
@end
