//
//  JLMineModel.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/3/1.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLMineModel : NSObject
@end

//////////////////////////////////////////////////////////////////////////
#pragma mark /members/favorate_arts 作品收藏
@protocol Model_members_favorate_arts_Data @end
@interface Model_members_favorate_arts_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) Model_art_Detail_Data *favoritable;
@property (nonatomic, strong) Model_art_author_Data *favoritor;
@end
@interface Model_members_favorate_arts_Req : Model_Req
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_members_favorate_arts_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_members_favorate_arts_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /members/followings 关注列表
@interface Model_members_followings_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_members_followings_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_art_author_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /members/followers 粉丝列表
@interface Model_members_followers_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_members_followers_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_art_author_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/mine 个人艺术作品
@interface Model_arts_mine_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
/** 状态,多个逗号分割 prepare(上传未上链), online(已上链), bidding(已上架), auctioning(拍卖中) */
@property (nonatomic, strong) NSString *aasm_state;
@end
@interface Model_arts_mine_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_art_Detail_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts 上传艺术品
@interface Model_arts_Req : Model_Req
/** 画作标题 */
@property (nonatomic, strong) NSString *name;
/** 分类id */
@property (nonatomic, strong) NSString *category_id;
/** 题材id */
@property (nonatomic, strong) NSString *theme_id;
/** 材质id */
@property (nonatomic, strong) NSString *material_id;
/** 创作日期 */
@property (nonatomic, strong) NSString *produce_at;
/** 尺寸 长度 */
@property (nonatomic, strong) NSString *size_length;
/** 尺寸 宽度 */
@property (nonatomic, strong) NSString *size_width;
/** 价格 */
@property (nonatomic, strong) NSString *price;
/** 详情说明 */
@property (nonatomic, strong) NSString *details;
/** 主图1 */
@property (nonatomic, strong) NSString *img_main_file1;
/** 主图2 */
@property (nonatomic, strong) NSString *img_main_file2;
/** 主图3 */
@property (nonatomic, strong) NSString *img_main_file3;
/** 细节图1 */
@property (nonatomic, strong) NSString *img_detail_file1;
/** 细节图2 */
@property (nonatomic, strong) NSString *img_detail_file2;
/** 细节说明1 */
@property (nonatomic, strong) NSString *img_detail_file1_desc;
/** 细节说明2 */
@property (nonatomic, strong) NSString *img_detail_file2_desc;
@end
@interface Model_arts_Rsp : Model_Rsp_V1
@end
//////////////////////////////////////////////////////////////////////////
@protocol Model_arts_sold_Data @end
@interface Model_arts_sold_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *art_id;
@property (nonatomic, strong) NSString *collection_id;
@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *buy_time;
@property (nonatomic, strong) NSString *buy_block_number;
@property (nonatomic, strong) Model_art_Detail_Data *art;
@end
#pragma mark 个人艺术作品 - 卖出 /arts/sold
@interface Model_arts_sold_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_arts_sold_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_arts_sold_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 个人艺术作品 - 买入 /arts/bought
@interface Model_arts_bought_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_arts_bought_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_arts_sold_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
