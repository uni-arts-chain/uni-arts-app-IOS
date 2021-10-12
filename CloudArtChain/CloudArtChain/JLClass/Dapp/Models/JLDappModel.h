//
//  JLDappModel.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/27.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLDappModel : NSObject

@end

////////////////////////////////////entity(实体)//////////////////////////////////////
#pragma mark -- dapp 信息
@protocol Model_dapp_Data @end
@interface Model_dapp_Data : Model_Interface
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *website_url;
@property (nonatomic, copy) NSString *chain_category_id;
@property (nonatomic, copy) NSString *recommend_sort;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, assign) BOOL favorite_by_me;
@property (nonatomic, strong) Model_Image_Data *logo;
@end
#pragma mark - 链信息
@protocol Model_chain_Data @end
@interface Model_chain_Data : Model_Interface
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@end
#pragma mark - 链分类信息
@protocol Model_chain_category_Data @end
@interface Model_chain_category_Data : Model_Interface
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<Model_dapp_Data> *dapps;
@end
#pragma mark - 最近使用dapp信息
@protocol Model_recently_dapp_Data @end
@interface Model_recently_dapp_Data : Model_Interface
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, strong) Model_dapp_Data *dapp;
@end
#pragma mark - 收藏dapp信息
@protocol Model_favorite_Data @end
@interface Model_favorite_Data : Model_Interface
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, strong) Model_dapp_Data *favoritable;
@end
////////////////////////////////////api(接口)//////////////////////////////////////
#pragma mark - /chains 链列表
@interface Model_chains_Req : Model_Req
@end
@interface Model_chains_Rsp : Model_Rsp_V2
@property (nonatomic, copy) NSArray<Model_chain_Data> *body;
@end
#pragma mark - /v2/chains/{:id}/categories 链的分类信息
@interface Model_chains_id_categories_Req : Model_Req
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_chains_id_categories_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_chains_id_categories_Req *request;
@property (nonatomic, copy) NSArray<Model_chain_category_Data> *body;
@end
#pragma mark - /v2/chains/{:id}/recommend_dapps 推荐的dapp列表
@interface Model_chains_id_recommend_dapps_Req : Model_Req
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_chains_id_recommend_dapps_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_chains_id_recommend_dapps_Req *request;
@property (nonatomic, copy) NSArray<Model_dapp_Data> *body;
@end
#pragma mark - /v2/dapps/category_dapps 链分类下的dapps
@interface Model_dapps_category_dapps_Req : Model_Req
@property (nonatomic, copy) NSString *chain_category_id;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_dapps_category_dapps_Rsp : Model_Rsp_V2
@property (nonatomic, copy) NSArray<Model_dapp_Data> *body;
@end
#pragma mark - /v2/dapps/favorites 收藏的dapp
@interface Model_dapps_favorites_Req : Model_Req
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_dapps_favorites_Rsp : Model_Rsp_V2
@property (nonatomic, copy) NSArray<Model_favorite_Data> *body;
@end
#pragma mark - /v2/member_recently_dapps 最近使用的dapp
@interface Model_member_recently_dapps_Req : Model_Req
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_member_recently_dapps_Rsp : Model_Rsp_V2
@property (nonatomic, copy) NSArray<Model_recently_dapp_Data> *body;
@end
#pragma mark - /v2/dapps/{:id}/favorite 收藏dapp
@interface Model_dapps_id_favorite_Req : Model_Req
@property (nonatomic, copy) NSString *ID;
@end
@interface Model_dapps_id_favorite_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_dapps_id_favorite_Req *request;
@property (nonatomic, copy) NSDictionary *body;
@end
#pragma mark - /v2/dapps/{:id}/unfavorite 取消收藏dapp
@interface Model_dapps_id_unfavorite_Req : Model_Req
@property (nonatomic, copy) NSString *ID;
@end
@interface Model_dapps_id_unfavorite_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_dapps_id_unfavorite_Req *request;
@property (nonatomic, copy) NSDictionary *body;
@end
#pragma mark - ​/v2​/dapps​/search 搜索dapp
@interface Model_dapps_search_Req : Model_Req
@property (nonatomic, copy) NSString *q;
@end
@interface Model_dapps_search_Rsp : Model_Rsp_V2
@property (nonatomic, copy) NSArray<Model_dapp_Data> *body;
@end
#pragma mark - ​/v2​/dapps/hot_search_dapps 热门搜索dapp
@interface Model_dapps_hot_search_dapps_Req : Model_Req
@end
@interface Model_dapps_hot_search_dapps_Rsp : Model_Rsp_V2
@property (nonatomic, copy) NSArray<Model_dapp_Data> *body;
@end
#pragma mark - /v2/member_recently_dapps 上传最近使用的dapp(post)
@interface Model_member_recently_dapp_Req : Model_Req
@property (nonatomic, copy) NSString *dapp_id;
@end
@interface Model_member_recently_dapp_Rsp : Model_Rsp_V2
@property (nonatomic, copy) Model_recently_dapp_Data *body;
@end
